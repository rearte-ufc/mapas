<?php

namespace OpportunityWorkplan\Controllers;

use MapasCulturais\App;
use MapasCulturais\Entities\Registration;
use OpportunityWorkplan\Entities\GoalDelivery;
use OpportunityWorkplan\Entities\Workplan as EntitiesWorkplan;
use OpportunityWorkplan\Entities\WorkplanGoal;
use MapasCulturais\i;

class Workplan extends \MapasCulturais\Controller
{
    public function GET_index()
    {
        $app = App::i();

        $registration = $app->repo(Registration::class)->find($this->data['id']);
        $workplan = $app->repo(EntitiesWorkplan::class)->findOneBy(['registration' => $registration->id]);

        $data = [
            'workplan' => []
        ];

        if ($workplan) {
            $data = [
                'workplan' => $workplan->jsonSerialize(),
            ];
        }
        

        $this->json($data);
    }

    public function POST_save()
    {
        $app = App::i();

        $app->disableAccessControl();

        $registration = $app->repo(Registration::class)->find($this->data['registrationId']);
        $workplan = $app->repo(EntitiesWorkplan::class)->findOneBy(['registration' => $registration->id]);

        if (!$workplan) {
            $workplan = new EntitiesWorkplan();
        }
        $dataWorkplan = $this->data['workplan'];

        if (array_key_exists('projectDuration', $dataWorkplan)) {
            $workplan->projectDuration = $dataWorkplan['projectDuration'];
        }

        if (array_key_exists('culturalArtisticSegment', $dataWorkplan)) {
            $workplan->culturalArtisticSegment = $dataWorkplan['culturalArtisticSegment'];
        }
    
        $workplan->registration = $registration;
        $workplan->save(true);

        if (array_key_exists('goals', $dataWorkplan)) {
            foreach ($dataWorkplan['goals'] as $g) {
                if ($g['id'] > 0) {
                    $goal = $app->repo(WorkplanGoal::class)->find($g['id']);
                } else {
                    $goal = new WorkplanGoal();
                }

                $goal->monthInitial = $g['monthInitial'] ?? null;
                $goal->monthEnd = $g['monthEnd'] ?? null;
                $goal->title = $g['title'] ?? null;
                $goal->description = $g['description'] ?? null;
                $goal->culturalMakingStage = $g['culturalMakingStage'] ?? null;
                $goal->amount = $g['amount'] ?? null;
                $goal->workplan = $workplan;
                $goal->save(true);


                foreach ($g['deliveries'] as $d) {
                    if ($d['id'] > 0) {
                        $delivery = $app->repo(GoalDelivery::class)->find($d['id']);
                    } else {
                        $delivery = new GoalDelivery();
                    }
    
                    $delivery->name = $d['name'] ?? null;
                    $delivery->description = $d['description'] ?? null;
                    $delivery->type = $d['type'] ?? null;
                    $delivery->segmentDelivery = $d['segmentDelivery'] ?? null;
                    $delivery->budgetAction = $d['budgetAction'] ?? null;
                    $delivery->expectedNumberPeople = $d['expectedNumberPeople'] ?? null;
                    $delivery->generaterRevenue = $d['generaterRevenue'] ?? null;
                    $delivery->renevueQtd = $d['renevueQtd'] ?? null;
                    $delivery->unitValueForecast = $d['unitValueForecast'] ?? null;
                    $delivery->totalValueForecast = $d['totalValueForecast'] ?? null;
                    $delivery->goal = $goal;
                    $delivery->save(true);
                }  
            }      
        }          
        
        $app->enableAccessControl();

        $this->json([
            'workplan' => $workplan->jsonSerialize(),
        ]);
    }
  

    public function DELETE_goal()
    {
        $app = App::i();

        $goal = $app->repo(WorkplanGoal::class)->find($this->data['id']);

        if ($goal) {
            $app->em->remove($goal);
            $app->em->flush(); 
        }
        $this->json(true);
    }

    public function DELETE_delivery()
    {
        $app = App::i();

        $delivery = $app->repo(GoalDelivery::class)->find($this->data['id']);

        if ($delivery) {
            $app->em->remove($delivery);
            $app->em->flush(); 
        }

        $this->json(true);
    }
}