<?php

namespace OpportunityWorkplan\Controllers;

use MapasCulturais\App;
use MapasCulturais\Entities\Registration;
use OpportunityWorkplan\Entities\Workplan as EntitiesWorkplan;

class Workplan extends \MapasCulturais\Controller
{
    public function GET_index()
    {
        $app = App::i();

        $registration = $app->repo(Registration::class)->find($this->data['id']);
        $workplan = $app->repo(EntitiesWorkplan::class)->findOneBy(['registration' => $registration->id]);



        $this->json($workplan);
    }

  

}