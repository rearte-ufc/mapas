<?php

/**
 * @var MapasCulturais\App $app
 * @var MapasCulturais\Themes\BaseV2\Theme $this
 */

use MapasCulturais\i;

$this->import('
    entity-field
    mc-card
    mc-icon
    mc-confirm-button
    mc-currency-input
');
?>
<mc-card class="registration-workplan" v-if="registration.opportunity.enableWorkplan">
    <template #title>
        <h3 class="card__title"><?= i::esc_attr__('Plano de trabalho') ?></h3>
        <p><?= i::esc_attr__('Descrição do plano de trabalho.') ?></p>
    </template>
    <template #content>
        <div class="field">
            <label><?= i::esc_attr__('Duração do projeto (meses)') ?></label>
            <select v-model="workplan.projectDuration" @blur="save_">
                <option value=""><?= i::esc_attr__('Selecione') ?></option>
                <option v-for="n in opportunity.workplan_dataProjectmaximumDurationInMonths" :key="n" :value="n">{{ n }}</option>
            </select>
        </div>
        
        <div class="field">
            <label><?= i::esc_attr__('Segmento artistico cultural') ?></label>
            <select v-model="workplan.culturalArtisticSegment" @blur="save_">
                <option value=""><?= i::esc_attr__('Selecione') ?></option>
                <option value="Segmento1">Segmento 1</option>
                <option value="Segmento2">Segmento 2</option>
            </select>
        </div>
        
        <!-- Metas -->
        <div v-for="(goal, index) in workplan.goals" :key="index" class="registration-workplan__goals">
            <div @click="toggleCollapse(index)" class="registration-workplan__header-goals">
                <h4 class="registration-workplan__goals-title">{{ goal.title }}</h4>
                <span>
                    <!-- <mc-icon v-if="goal.isCollapsed" name="arrowPoint-up"></mc-icon>
                    <mc-icon v-if="!goal.isCollapsed" name="arrowPoint-down"></mc-icon> -->
                </span>
            </div>
            <h6><?= i::esc_attr__('Meta') ?> {{ index + 1 }}</h6>


            <div>
                <!-- Duração da meta -->
                <div class="registration-workplan__goals-period">
                    <p><?= i::esc_attr__('Duração da meta') ?></p>
                    <div class="registration-workplan__goals-months">
                        <div class="field">
                            <label><?= i::esc_attr__('Mês inicial') ?></label>
                            <select v-model="goal.monthInitial" id="mes-inicial" style="display: block;" @blur="save_">
                                <option value=""><?= i::esc_attr__('Selecione') ?></option>
                                <option v-for="n in parseInt(workplan.projectDuration)" :key="n" :value="n">{{ n }}</option>

                            </select>
                        </div>
                        <div class="field">
                            <label for="mes-final"><?= i::esc_attr__('Mês final') ?></label>
                            <select v-model="goal.monthEnd" id="mes-final" style="display: block;" @blur="save_">
                                <option value=""><?= i::esc_attr__('Selecione') ?></option>
                                <option v-for="n in range(parseInt(goal.monthInitial), parseInt(workplan.projectDuration)) " :key="n" :value="n">{{ n }}</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Título da meta -->
                <div class="field">
                    <label><?= i::esc_attr__('Título da meta') ?></label>
                    <input v-model="goal.title" type="text" @blur="save_">
                </div>

                <!-- Descrição -->
                <div class="field">
                    <label><?= i::esc_attr__('Descrição') ?></label>
                    <textarea v-model="goal.description" @blur="save_"></textarea>
                </div>

                <!-- Etapa do fazer cultural -->
                <div class="field">
                    <label><?= i::esc_attr__('Etapa do fazer cultural') ?></label>
                    <select v-model="goal.culturalMakingStage" @blur="save_">
                        <option value=""><?= i::esc_attr__('Selecione') ?></option>
                        <option value="etapa1">Etapa 1</option>
                        <option value="etapa2">Etapa 2</option>
                    </select>
                </div>

                <!-- Valor da meta -->
                <div class="field">
                    <label><?= i::esc_attr__('Valor da meta (R$)') ?></label>
                    <mc-currency-input v-model="goal.amount" @blur="save_"></mc-currency-input>
                </div>

                <div v-for="(delivery, index_) in goal.deliveries" :key="delivery.id" class="registration-workplan__goals__deliveries">
                    <h4 v-if="delivery.name" class="registration-workplan__goals-title">[{{ delivery.name }}]</h4>

                    <div class="field">
                        <label><?= i::esc_attr__('Nome da entrega') ?></label>
                        <input v-model="delivery.name" type="text" @blur="save_">
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('Descrição') ?></label>
                        <textarea v-model="delivery.description" @blur="save_"></textarea>
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('Tipo de entrega') ?></label>
                        <select v-model="delivery.type" @blur="save_">
                            <option value=""><?= i::esc_attr__('Selecione') ?></option>
                            <option value="tipo1">Tipo 1</option>
                            <option value="tipo2">Tipo 2</option>
                        </select>
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('Segmento artístico cultural da entrega') ?></label>
                        <select v-model="delivery.segmentDelivery" @blur="save_">
                            <option value=""><?= i::esc_attr__('Selecione') ?></option>
                            <option value="seg1">Seg 1</option>
                            <option value="seg2">Seg 2</option>
                        </select>
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('Ação orçamentária') ?></label>
                        <select v-model="delivery.budgetAction" @blur="save_">
                            <option value=""><?= i::esc_attr__('Selecione') ?></option>
                            <option value="acao1">Ação 1</option>
                            <option value="acao2">Ação 2</option>
                        </select>
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('Número previsto de pessoas') ?></label>
                        <input v-model="delivery.expectedNumberPeople" type="number" @blur="save_">
                    </div>

                    <div class="field">
                        <label><?= i::esc_attr__('A entrega irá gerar receita?') ?></label>
                        <select v-model="delivery.generaterRevenue" @blur="save_">
                            <option value=""><?= i::esc_attr__('Selecione') ?></option>
                            <option value="true">Sim</option>
                            <option value="false">Não</option>
                        </select>
                    </div>

                    <div class="grid-12">
                        <div class="field col-4 sm:col-12">
                            <label><?= i::esc_attr__('Quantidade') ?></label>
                            <input v-model="delivery.renevueQtd" type="text" @blur="save_">
                        </div>

                        <div class="field col-4 sm:col-12">
                            <label><?= i::esc_attr__('Previsão de valor unitário') ?></label>
                            <mc-currency-input v-model="delivery.unitValueForecast" @blur="save_"></mc-currency-input>
                        </div>

                        <div class="field col-4 sm:col-12">
                            <label><?= i::esc_attr__(text: 'Previsão de valor total') ?></label>
                            <mc-currency-input v-model="delivery.totalValueForecast" @blur="save_"></mc-currency-input>
                        </div>
                    </div>

                    <div class="registration-workplan__delete-delivery">
                        <mc-confirm-button @confirm="deleteDelivery(delivery.id)">
                            <template #button="{open}">
                                <button class="button button--delete button--icon button--sm" @click="open()" @blur="save_">
                                    <mc-icon name="trash"></mc-icon> <?= i::esc_attr__('Excluir entrega') ?>
                                </button>
                            </template>
                            <template #message="message">
                                <h3><?= i::__('Excluir a entrega'); ?></h3><br>
                                <p><?= i::__('Deseja excluir a entrega selecionada e todas as suas respectivas configurações?') ?></p>
                            </template>
                        </mc-confirm-button>
                    </div>
                </div>

                <div class="registration-workplan__new-delivery">
                    <button class="button button--primary-outline" @click="newDelivery(goal)">
                        + <?= i::esc_attr__('Entrega') ?>
                    </button>
                </div>
                <div class="registration-workplan__delete-goal">
                    <mc-confirm-button @confirm="deleteGoal(goal.id)">
                        <template #button="{open}">
                            <button class="button button--delete button--icon button--sm" @click="open()" @blur="save_">
                                <mc-icon name="trash"></mc-icon> <?= i::esc_attr__('Excluir meta') ?>
                            </button>
                        </template>
                        <template #message="message">
                            <h3><?= i::__('Excluir meta'); ?></h3><br>
                            <p><?= i::__('Deseja excluir a meta selecionada, todas as suas configurações e as respectivas entregas associadas a ela?') ?></p>
                        </template>
                    </mc-confirm-button>
                </div>
            </div>
        </div>

        <div class="registration-workplan__new-goal">
            <button class="button button--primary" @click="newGoal">
                + <?= i::esc_attr__('meta') ?>
            </button>
        </div>
    </template>
</mc-card>