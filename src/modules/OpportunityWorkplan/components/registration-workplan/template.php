<?php
$this->import('
    entity-field
    mc-card
');
?>
<mc-card v-if="registration.opportunity.enableWorkplan">
  <template #title>
    <h3 class="card__title">Plano de trabalho</h3>
    <p>Descrição do plano de trabalho.</p>
  </template>
  <template #content>
    <entity-field :entity="registration" prop="projectDuration" :autosave="60000"></entity-field>



    <!-- Metas -->
    <div v-for="(meta, index) in registration.workplan_goals" :key="meta.id" style="border: 1px solid #ddd; padding: 16px; margin-bottom: 16px;">
      <h3>Meta {{ index + 1 }}</h3>

      <!-- Duração da meta -->
      <div style="display: flex; gap: 8px; margin-bottom: 8px;">
        <div>
          <label for="mes-inicial">Mês inicial</label>
          <select v-model="meta.mesInicial" id="mes-inicial" style="display: block;">
            <option value="">Selecione</option>
            <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
          </select>
        </div>
        <div>
          <label for="mes-final">Mês final</label>
          <select v-model="meta.mesFinal" id="mes-final" style="display: block;">
            <option value="">Selecione</option>
            <option v-for="mes in meses" :key="mes" :value="mes" @change="save_">{{ mes }}</option>
          </select>
        </div>
      </div>

      <!-- Título da meta -->
      <div style="margin-bottom: 8px;">
        <label>Título da meta</label>
        <input v-model="meta.titulo" type="text" placeholder="Digite"  @change="save_" style="display: block; width: 100%; padding: 4px;">
      </div>

      <!-- Descrição -->
      <div style="margin-bottom: 8px;">
        <label>Descrição</label>
        <textarea v-model="meta.descricao" placeholder="Digite"  @change="save_" style="display: block; width: 100%; padding: 4px;"></textarea>
      </div>

      <!-- Etapa do fazer cultural -->
      <div style="margin-bottom: 8px;">
        <label>Etapa do fazer cultural</label>
        <select v-model="meta.etapaFazerCultural" style="display: block; width: 100%; padding: 4px;"  @change="save_">
          <option value="">Selecione</option>
          <option value="etapa1">Etapa 1</option>
          <option value="etapa2">Etapa 2</option>
          <!-- Adicione mais etapas conforme necessário -->
        </select>
      </div>

      <!-- Ação orçamentária -->
      <div style="margin-bottom: 8px;">
        <label>Ação orçamentária</label>
        <select v-model="meta.acaoOrcamentaria" style="display: block; width: 100%; padding: 4px;"  @change="save_">
          <option value="">Selecione</option>
          <option value="acao1">Ação 1</option>
          <option value="acao2">Ação 2</option>
          <!-- Adicione mais ações conforme necessário -->
        </select>
      </div>

      <!-- Valor da meta -->
      <div style="margin-bottom: 8px;">
        <label>Valor da meta (R$)</label>
        <input v-model="meta.valor" type="number" placeholder="R$" style="display: block; width: 100%; padding: 4px;"  @change="save_">
      </div>

      <!-- Botão de Remover Meta -->
      <button @click="removerMeta(index)" style="color: red; border: none; background: transparent; cursor: pointer;"  @change="save_">
        Excluir meta
      </button>
    </div>

    <!-- Botão de Adicionar Meta -->
    <button @click="adicionarMeta" style="margin-top: 16px; padding: 8px 16px; background-color: #007bff; color: white; border: none; cursor: pointer;">
      + meta
    </button>
  </template>
</mc-card>

<div v-if="!registration.opportunity.enableWorkplan">
  Não habilitado
</div>