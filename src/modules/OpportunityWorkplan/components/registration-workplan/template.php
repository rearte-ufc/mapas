<?php
$this->import('
    entity-field
    mc-card
    mc-icon
');
?>
<mc-card class="registration-workplan" v-if="registration.opportunity.enableWorkplan">
  <template #title>
    <h3 class="card__title">Plano de trabalho</h3>
    <p>Descrição do plano de trabalho.</p>
  </template>
  <template #content>
    <entity-field :entity="registration" prop="workplan_projectDuration" :autosave="30000"></entity-field>

    <!-- Metas -->
    <div v-for="(meta, index) in registration.workplan_goals" :key="meta.id" class="registration-workplan__goals">
      <h4>Meta {{ index + 1 }}</h4>

      <!-- Duração da meta -->
      <div class="registration-workplan__goals-months">
        <div class="field">
          <label for="mes-inicial">Mês inicial</label>
          <select v-model="meta.mesInicial" id="mes-inicial" style="display: block;">
            <option value="">Selecione</option>
            <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
          </select>
        </div>
        <div class="field">
          <label for="mes-final">Mês final</label>
          <select v-model="meta.mesFinal" id="mes-final" style="display: block;">
            <option value="">Selecione</option>
            <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
          </select>
        </div>
      </div>

      <!-- Título da meta -->
      <div class="field">
        <label>Título da meta</label>
        <input v-model="meta.titulo" type="text" placeholder="Digite"  @change="save_">
      </div>

      <!-- Descrição -->
      <div class="field">
        <label>Descrição</label>
        <textarea v-model="meta.descricao" placeholder="Digite"  @change="save_"></textarea>
      </div>

      <!-- Etapa do fazer cultural -->
      <div class="field">
        <label>Etapa do fazer cultural</label>
        <select v-model="meta.etapaFazerCultural"  @change="save_">
          <option value="">Selecione</option>
          <option value="etapa1">Etapa 1</option>
          <option value="etapa2">Etapa 2</option>
          <!-- Adicione mais etapas conforme necessário -->
        </select>
      </div>

      <!-- Ação orçamentária -->
      <div class="field">
        <label>Ação orçamentária</label>
        <select v-model="meta.acaoOrcamentaria" @change="save_">
          <option value="">Selecione</option>
          <option value="acao1">Ação 1</option>
          <option value="acao2">Ação 2</option>
          <!-- Adicione mais ações conforme necessário -->
        </select>
      </div>

      <!-- Valor da meta -->
      <div class="field">
        <label>Valor da meta (R$)</label>
        <input v-model="meta.valor" type="number" placeholder="R$" @change="save_">
      </div>

      <div class="registration-workplan__delete-meta">
        <button class="button button--delete button--icon button--sm" @click="removerMeta(index)" @change="save_">
          <mc-icon name="trash"></mc-icon>  Excluir meta
        </button>
      </div>
    </div>

    <div class="registration-workplan__new-meta">
      <button class="button button--primary" @click="adicionarMeta">
        + meta {{ registration.workplan_goals.length + 1 }}
      </button>
    </div>
  </template>
</mc-card>

<div v-if="!registration.opportunity.enableWorkplan">
  Não habilitado
</div>