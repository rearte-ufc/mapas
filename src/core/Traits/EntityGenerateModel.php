<?php
namespace MapasCulturais\Traits;

use MapasCulturais\App;
use MapasCulturais\Entities\ProjectOpportunity;
use MapasCulturais\Entity;

trait EntityGenerateModel {

    function ALL_generatemodel(){
        $app = App::i();

        $this->requireAuthentication();
        $this->opportunity = $this->requestedEntity;
        
       
        if($this->isAjax()){
            $this->json($this->opportunity);
        }else{
            $app->redirect($app->request->getReferer());
        }
    }
}
