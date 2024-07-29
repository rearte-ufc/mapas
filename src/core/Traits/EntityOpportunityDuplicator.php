<?php
namespace MapasCulturais\Traits;

use MapasCulturais\App;
use MapasCulturais\Entities\ProjectOpportunity;
use MapasCulturais\Entity;

trait EntityOpportunityDuplicator {
    function ALL_duplicate(){
        $app = App::i();

        $this->requireAuthentication();
        $opportunity = $this->requestedEntity;
        
        $newOpportunity = $this->cloneOpportunity($opportunity);
        
        $this->duplicateEvaluationMethods($opportunity, $newOpportunity);
        $this->duplicatePhases($opportunity, $newOpportunity);
        $this->duplicateMetadata($opportunity, $newOpportunity);
        $this->duplicateRegistrationFieldsAndFiles($opportunity, $newOpportunity);
        $this->duplicateMetalist($opportunity, $newOpportunity);
        $this->duplicateFiles($opportunity, $newOpportunity);

        $newOpportunity->save();
       
        if($this->isAjax()){
            $this->json($opportunity);
        }else{
            $app->redirect($app->request->getReferer());
        }
    }

    private function cloneOpportunity(ProjectOpportunity $opportunity) : ProjectOpportunity
    {
        $app = App::i();

        $newOpportunity = clone $opportunity;

        $dateTime = new \DateTime();
        $now = $dateTime->format('d-m-Y H:i:s');
        $newOpportunity->setName("$opportunity->name  - [Cópia][$now]");
        $newOpportunity->setStatus(Entity::STATUS_DRAFT);
        $app->em->persist($newOpportunity);
        $app->em->flush();

        return $newOpportunity;
    }

    private function duplicateEvaluationMethods(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        $app = App::i();

        // duplica o método de avaliação para a oportunidade primária
        $evaluationMethodConfigurations = $app->repo('EvaluationMethodConfiguration')->findBy([
            'opportunity' => $opportunity
        ]);
        foreach ($evaluationMethodConfigurations as $evaluationMethodConfiguration) {
            $newMethodConfiguration = clone $evaluationMethodConfiguration;
            $newMethodConfiguration->setOpportunity($newOpportunity);
            $newMethodConfiguration->save(true);

            // duplica os metadados das configurações do modelo de avaliação
            foreach ($evaluationMethodConfiguration->getMetadata() as $metadataKey => $metadataValue) {
                $newMethodConfiguration->setMetadata($metadataKey, $metadataValue);
                $newMethodConfiguration->save(true);
            }
        }
    }

    private function duplicatePhases(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        $app = App::i();

        $phases = $app->repo('Opportunity')->findBy([
            'parent' => $opportunity
        ]);
        foreach ($phases as $phase) {
            if (!$phase->getMetadata('isLastPhase')) {
                $newPhase = clone $phase;
                $newPhase->setParent($newOpportunity);

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
                }
            }
        }
    }

    private function duplicateMetadata(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        foreach ($opportunity->getMetadata() as $metadataKey => $metadataValue) {
            if (!is_null($metadataValue) && $metadataValue != '') {
                $newOpportunity->setMetadata($metadataKey, $metadataValue);
            }
        }

        $newOpportunity->setTerms(['area' => $opportunity->terms['area']]);
        $newOpportunity->setTerms(['tag' => $opportunity->terms['tag']]);
        $newOpportunity->saveTerms();
    }
   
    private function duplicateRegistrationFieldsAndFiles(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        foreach ($opportunity->getRegistrationFieldConfigurations() as $registrationFieldConfiguration) {
            $fieldConfiguration = clone $registrationFieldConfiguration;
            $fieldConfiguration->setOwnerId($newOpportunity->getId());
            $fieldConfiguration->save(true);
        }

        foreach ($opportunity->getRegistrationFileConfigurations() as $registrationFileConfiguration) {
            $fileConfiguration = clone $registrationFileConfiguration;
            $fileConfiguration->setOwnerId($newOpportunity->getId());
            $fileConfiguration->save(true);
        }

    }

    private function duplicateMetalist(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        foreach ($opportunity->getMetaLists() as $metaList_) {
            foreach ($metaList_ as $metaList__) {
                $metalist = clone $metaList__;
                $metalist->setOwner($newOpportunity);
            
                $metalist->save(true);
            }
        }
    }

    private function duplicateFiles(ProjectOpportunity $opportunity, ProjectOpportunity $newOpportunity) : void
    {
        $app = App::i();

        $opportunityFiles = $app->repo('OpportunityFile')->findBy([
            'owner' => $opportunity
        ]);

        foreach ($opportunityFiles as $opportunityFile) {
            $newMethodOpportunityFile = clone $opportunityFile;
            $newMethodOpportunityFile->owner = $newOpportunity;
            $newMethodOpportunityFile->save(true);
        }
    }
}
