<?php

use MapasCulturais\i;

 if($opportunity->registrationProponentTypes): ?>
    <div class="registration-fieldset">
        <div id="category">
            
            <?php if($opportunity->isOpportunityPhase && $entity->preview): ?>
                <div class="alert info">
                    <?= i::__("O campo categoria/opções não será exibido para o usuário final. Está neste formulário somente para auxiliar nos testes dos campos condicionados.");?>
                </div>
            <?php endif?>
            
            <div>
                <!-- TODO: ng-required="requiredField(field)" -->
                <!-- foi trocado ng-blur para ng-change, para dar o trigger na função sempre que uma nova opção no select for escolhida -->
                <select  ng-model="entity.registrationRanges" ng-change="saveField({fieldName:'registrationProponentTypes'}, entity.registrationProponentTypes)" >
                    <option ng-repeat="option in registrationProponentTypes" value="{{::option.indexOf(':') >= 0 ? option.split(':')[0] : option}}">{{::option.indexOf(':') >= 0 ? option.split(':')[1] : option}}</option>
                </select>
            </div>
        </div>
        <!-- <div ng-repeat="error in data.errors.category" class="alert danger">{{error}}</div> -->
    </div>
    
<?php endif; ?>