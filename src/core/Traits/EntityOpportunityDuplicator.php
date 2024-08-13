<?php
namespace MapasCulturais\Traits;
use MapasCulturais\App;
use MapasCulturais\Entities\ProjectOpportunity;
use MapasCulturais\Entities\User;
use MapasCulturais\Entity;

trait EntityOpportunityDuplicator {

    private ProjectOpportunity $newOpportunity;

    function ALL_duplicate(){
        $app = App::i();

        $this->requireAuthentication();
        $this->opportunity = $this->requestedEntity;
        $this->newOpportunity = $this->cloneOpportunity();


        $this->duplicateEvaluationMethods();
        $this->duplicatePhases();
        $this->duplicateMetadata();
        $this->duplicateRegistrationFieldsAndFiles();
        $this->duplicateMetalist();
        $this->duplicateFiles();
        $this->duplicateAgentRelations();
        $this->duplicateSealsRelations();

        $this->newOpportunity->save(true);
       
        if($this->isAjax()){
            $this->json($this->opportunity);
        }else{
            $app->redirect($app->request->getReferer());
        }
    }

    private function cloneOpportunity() : ProjectOpportunity
    {
        $app = App::i();

        $this->newOpportunity = clone $this->opportunity;

        $dateTime = new \DateTime();
        $now = $dateTime->format('d-m-Y H:i:s');
        $name = $this->opportunity->name;
        $this->newOpportunity->setName("$name  - [Cópia][$now]");
        $this->newOpportunity->setStatus(Entity::STATUS_DRAFT);
        $this->newOpportunity->registrationCategories = [];
        $app->em->persist($this->newOpportunity);
        $app->em->flush();

        return $this->newOpportunity;
    }

    private function duplicateEvaluationMethods() : void
    {
        $app = App::i();

        // duplica o método de avaliação para a oportunidade primária
        $evaluationMethodConfigurations = $app->repo('EvaluationMethodConfiguration')->findBy([
            'opportunity' => $this->opportunity
        ]);
        foreach ($evaluationMethodConfigurations as $evaluationMethodConfiguration) {
            $newMethodConfiguration = clone $evaluationMethodConfiguration;
            $newMethodConfiguration->setOpportunity($this->newOpportunity);
            $newMethodConfiguration->save(true);

            // duplica os metadados das configurações do modelo de avaliação
            foreach ($evaluationMethodConfiguration->getMetadata() as $metadataKey => $metadataValue) {
                $newMethodConfiguration->setMetadata($metadataKey, $metadataValue);
                $newMethodConfiguration->save(true);
            }

            foreach ($evaluationMethodConfiguration->getAgentRelations() as $agentRelation_) {
                $agentRelation = clone $agentRelation_;
                $agentRelation->owner = $newMethodConfiguration;
                $agentRelation->save(true);
            }
        }
    }

    private function duplicatePhases() : void
    {
        $app = App::i();

        $phases = $app->repo('Opportunity')->findBy([
            'parent' => $this->opportunity
        ]);
        foreach ($phases as $phase) {
            if (!$phase->getMetadata('isLastPhase')) {
                $newPhase = clone $phase;
                $newPhase->setParent($this->newOpportunity);

                // duplica os metadados das fases
                foreach ($phase->getMetadata() as $metadataKey => $metadataValue) {
                    if (!is_null($metadataValue) && $metadataValue != '') {
                        $newPhase->setMetadata($metadataKey, $metadataValue);
                        $newPhase->save(true);
                    }
                }

                $newPhase->save(true);

                // duplica os modelos de avaliações das fases
                $evaluationMethodConfigurations = $app->repo('EvaluationMethodConfiguration')->findBy([
                    'opportunity' => $phase
                ]);

                foreach ($evaluationMethodConfigurations as $evaluationMethodConfiguration) {
                    $newMethodConfiguration = clone $evaluationMethodConfiguration;
                    $newMethodConfiguration->setOpportunity($newPhase);
                    $newMethodConfiguration->save(true);

                    // duplica os metadados das configurações do modelo de avaliação para a fase
                    foreach ($evaluationMethodConfiguration->getMetadata() as $metadataKey => $metadataValue) {
                        $newMethodConfiguration->setMetadata($metadataKey, $metadataValue);
                        $newMethodConfiguration->save(true);
                    }

                    foreach ($evaluationMethodConfiguration->getAgentRelations() as $agentRelation_) {
                        $agentRelation = clone $agentRelation_;
                        $agentRelation->owner = $newMethodConfiguration;
                        $agentRelation->save(true);
                    }
                }
            }

            if ($phase->getMetadata('isLastPhase')) {
                $publishDate = $phase->getPublishTimestamp();
            }
        }

        if (isset($publishDate)) {
            $phases = $app->repo('Opportunity')->findBy([
                'parent' => $this->newOpportunity
            ]);
    
            foreach ($phases as $phase) {
                if ($phase->getMetadata('isLastPhase')) {
                    $phase->setPublishTimestamp($publishDate);
                    $phase->save(true);
                }
            }
        }       
    }

    private function duplicateMetadata() : void
    {
        foreach ($this->opportunity->getMetadata() as $metadataKey => $metadataValue) {
            if (!is_null($metadataValue) && $metadataValue != '') {
                $this->newOpportunity->setMetadata($metadataKey, $metadataValue);
            }
        }

        $this->newOpportunity->setTerms(['area' => $this->opportunity->terms['area']]);
        $this->newOpportunity->setTerms(['tag' => $this->opportunity->terms['tag']]);
        $this->newOpportunity->saveTerms();
    }
   
    private function duplicateRegistrationFieldsAndFiles() : void
    {
        foreach ($this->opportunity->getRegistrationFieldConfigurations() as $registrationFieldConfiguration) {
            $fieldConfiguration = clone $registrationFieldConfiguration;
            $fieldConfiguration->setOwnerId($this->newOpportunity->getId());
            $fieldConfiguration->save(true);
        }

        foreach ($this->opportunity->getRegistrationFileConfigurations() as $registrationFileConfiguration) {
            $fileConfiguration = clone $registrationFileConfiguration;
            $fileConfiguration->setOwnerId($this->newOpportunity->getId());
            $fileConfiguration->save(true);
        }

    }

    private function duplicateMetalist() : void
    {
        foreach ($this->opportunity->getMetaLists() as $metaList_) {
            foreach ($metaList_ as $metaList__) {
                $metalist = clone $metaList__;
                $metalist->setOwner($this->newOpportunity);
            
                $metalist->save(true);
            }
        }
    }

    private function duplicateFiles() : void
    {
        $app = App::i();

        $opportunityFiles = $app->repo('OpportunityFile')->findBy([
            'owner' => $this->opportunity
        ]);

        foreach ($opportunityFiles as $opportunityFile) {
            $newMethodOpportunityFile = clone $opportunityFile;
            $newMethodOpportunityFile->owner = $this->newOpportunity;
            $newMethodOpportunityFile->save(true);
        }
    }

    private function duplicateAgentRelations() : void
    {
        foreach ($this->opportunity->getAgentRelations(null, true) as $agentRelation_) {
            $agentRelation = clone $agentRelation_;
            $agentRelation->owner = $this->newOpportunity;
            $agentRelation->save(true);
        }
    }

    private function duplicateSealsRelations() : void
    {
        foreach ($this->opportunity->getSealRelations() as $sealRelation) {
            $this->newOpportunity->createSealRelation($sealRelation->seal, true, true);
        }
    }
}
