<?php

/**
 * @var MapasCulturais\App $app
 * @var MapasCulturais\Themes\BaseV2\Theme $this
 */

use MapasCulturais\i;
?>
<div class="opportunity-enable-workplan">
    <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Plano de trabalho') ?></h4>
    <h6><?= $this->text('header-description', i::__('Configurar parâmetros do plano de trabalho')) ?></h6>
    <div class="opportunity-enable-workplan__content">
        <div class="field col-12">
            <div class="field__group">
                <label class="field__checkbox">
                    <input type="checkbox" v-model="entity.enableWorkplan" @click="autoSave()"/><?= i::__("Habilita plano de trabalho") ?>
                </label>
            </div>
        </div>
        
        <div v-if="entity.enableWorkplan">
            <div id="data-project" class="opportunity-enable-workplan__block col-12">
                <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Dados do projeto') ?></h4>
                <div class="field col-12">
                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.dataProjectlimitMaximumDurationOfProjects" @click="autoSave()"/><?= i::__("Limitar a duração máxima dos projetos") ?>
                        </label>
                    </div>

                    <div v-if="entity.dataProjectlimitMaximumDurationOfProjects" class="field__group">
                        <label class="field__group">
                            <?php i::_e('Duração máxima (meses):') ?>
                        </label>
                        <input type="number" v-model="entity.dataProjectmaximumDurationInMonths" @click="autoSave()">
                    </div>
                </div>
            </div>
            <div id="data-metas" class="opportunity-enable-workplan__block  col-12">
                <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Metas') ?></h4>
                <h6><?= $this->text('header-description', i::__('As metas são constituídas por uma ou mais entregas')) ?></h6>
                <div class="field col-12">
                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.metaInformTheStageOfCulturalMaking" @click="autoSave()"/><?= i::__("Informar a etapa do fazer cultural") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                        <input type="checkbox" v-model="entity.metaLimitNumberOfGoals" @click="autoSave()"/><?= i::__("Limitar número de metas") ?>
                        </label>
                    </div>

                    <div v-if="entity.metaLimitNumberOfGoals" class="field__group">
                        <label>
                            <?php i::_e('Número máximo de metas:') ?>   
                        </label>
                        <input type="number" v-model="entity.metaMaximumNumberOfGoals" @click="autoSave()">
                    </div>
                </div>
            </div>
            <div id="data-delivery" class="opportunity-enable-workplan__block  col-12">
                <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Entregas da meta') ?></h4>
                <h6><?= $this->text('header-description', i::__('As entregas são evidências (arquivos ou links) que comprovam a conclusão da meta.')) ?></h6>
                <div class="field col-12">
                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.deliveryReportTheDeliveriesLinkedToTheGoals" @click="autoSave()"/><?= i::__("Informar as entregas vinculadas à meta") ?>
                        </label>
                    </div>
                </div>
            </div>
            <div id="data-registration" class="opportunity-enable-workplan__block  col-12">
                <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Inscrição') ?></h4>
                <h6><?= $this->text('header-description', i::__('As informações que forem marcadas abaixo serão exigidas dos agentes no momento de inscrição na oportunidade.')) ?></h6>
                <div class="field col-12">
                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.deliveryReportTheNumberOfParticipants" @click="autoSave()"/><?= i::__("Informar a quantidade de participantes") ?>
                        </label>
                    </div>
                    <div class="field__group">
                        <label class="field__checkbox">
                        <input type="checkbox" v-model="entity.deliveryReportExpectedRenevue" @click="autoSave()"/><?= i::__("Informar receita prevista") ?>
                        </label>
                    </div>
                </div>
            </div>
            <div id="data-monitoring" class="opportunity-enable-workplan__block  col-12">
                <h4 class="bold opportunity-enable-workplan__title"><?= i::__('Monitoramento') ?></h4>
                <h6><?= $this->text('header-description', i::__('As informações que forem marcadas abaixo serão exigidas dos agentes no momento de monitoramento da oportunidade.')) ?></h6>
                <div class="field col-12">
                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringInformAccessibilityMeasures" @click="autoSave()"/><?= i::__("Informar as medidas de acessibilidade") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringProvideTheProfileOfParticipants" @click="autoSave()"/><?= i::__("Informar o perfil dos participantes") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringInformThePriorityAudience" @click="autoSave()"/><?= i::__("Informar o público prioritário") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringInformDeliveryType" @click="autoSave()"/><?= i::__("Informar tipo de entrega") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringReportExecutedRevenue" @click="autoSave()"/><?= i::__("Informar receita executada") ?>
                        </label>
                    </div>

                    <div class="field__group">
                        <label class="field__checkbox">
                            <input type="checkbox" v-model="entity.monitoringLimitNumberOfDeliveries" @click="autoSave()"/><?= i::__("Limitar número de entregas") ?>
                        </label>
                    </div>

                    <div v-if="entity.monitoringLimitNumberOfDeliveries"  class="field__group">
                        <label>
                            <?php i::_e('Número máximo de entregas:') ?>  
                        </label>
                        <input type="number" v-model="entity.monitoringMaximumNumberOfDeliveries" @click="autoSave()">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="config-phase__line col-12"></div>