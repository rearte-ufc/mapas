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
');
?>
<mc-card class="registration-workplan" v-if="registration.opportunity.enableWorkplan">
  <template #title>
    <h3 class="card__title"><?= i::esc_attr__('Plano de trabalho') ?></h3>
    <p><?= i::esc_attr__('Descrição do plano de trabalho.') ?></p>
  </template>
  <template #content>
    <entity-field :entity="registration" prop="workplan_projectDuration" :autosave="30000"></entity-field>
    <entity-field :entity="registration" prop="workplan_culturalArtisticSegment" :autosave="30000"></entity-field>

    <!-- Metas -->
    <div v-for="(goal, index) in registration.workplan_goals" :key="goal.id" class="registration-workplan__goals">
      <h4 v-if="goal.titulo" class="registration-workplan__goals-title">[{{ goal.titulo }}]</h4>
      <h6><?= i::esc_attr__('Meta') ?> {{ index + 1 }}</h6>

      <!-- Duração da meta -->
      <div class="registration-workplan__goals-period">
        <p><?= i::esc_attr__('Duração da meta') ?></p>
        <div class="registration-workplan__goals-months">
          <div class="field">
            <label><?= i::esc_attr__('Mês inicial') ?></label>
            <select v-model="goal.mesInicial" id="mes-inicial" style="display: block;">
              <option value=""><?= i::esc_attr__('Selecione') ?></option>
              <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
            </select>
          </div>
          <div class="field">
            <label for="mes-final"><?= i::esc_attr__('Mês final') ?></label>
            <select v-model="goal.mesFinal" id="mes-final" style="display: block;">
              <option value=""><?= i::esc_attr__('Selecione') ?></option>
              <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Título da meta -->
      <div class="field">
        <label><?= i::esc_attr__('Título da meta') ?></label>
        <input v-model="goal.titulo" type="text" @change="save_">
      </div>

      <!-- Descrição -->
      <div class="field">
        <label><?= i::esc_attr__('Descrição') ?></label>
        <textarea v-model="goal.descricao" @change="save_"></textarea>
      </div>

      <!-- Etapa do fazer cultural -->
      <div class="field">
        <label><?= i::esc_attr__('Etapa do fazer cultural') ?></label>
        <select v-model="goal.etapaFazerCultural"  @change="save_">
          <option value=""><?= i::esc_attr__('Selecione') ?></option>
          <option value="etapa1">Etapa 1</option>
          <option value="etapa2">Etapa 2</option>
        </select>
      </div>

      <!-- Valor da meta -->
      <div class="field">
        <label><?= i::esc_attr__('Valor da meta (R$)') ?></label>
        <input v-model="goal.valor" type="number" placeholder="R$" @change="save_">
      </div>

      <div v-for="(delivery, index_) in goal.deliveries" :key="delivery.id" class="registration-workplan__goals__deliveries">
        <h4 v-if="delivery.name" class="registration-workplan__goals-title">[{{ delivery.name }}]</h4>
      
        <div class="field">
          <label><?= i::esc_attr__('Nome da entrega') ?></label>
          <input v-model="delivery.name" type="text" @change="save_">
        </div>
      </div>

      <div class="registration-workplan__new-delivery">
        <button class="button button--primary-outline" @click="newDelivery(index)">
          + <?= i::esc_attr__('Entrega') ?>
        </button>
      </div>
      <div class="registration-workplan__delete-goal">
        <button class="button button--delete button--icon button--sm" @click="deleteGoal(index)" @change="save_">
          <mc-icon name="trash"></mc-icon>  <?= i::esc_attr__('Excluir meta') ?>
        </button>
      </div>
    </div>

    <div class="registration-workplan__new-goal">
      <button class="button button--primary" @click="newGoal">
        + <?= i::esc_attr__('meta') ?> {{ registration.workplan_goals.length + 1 }}
      </button>
    </div>
  </template>
</mc-card>