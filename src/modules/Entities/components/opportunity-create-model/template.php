<?php
/**
 * @var MapasCulturais\App $app
 * @var MapasCulturais\Themes\BaseV2\Theme $this
 */

use MapasCulturais\i;

$this->import(" 
    mc-modal
");
?>
<div class="col-12">
    <mc-modal title="<?= i::__('Salvar modelo') ?>">
        <template v-if="!sendSuccess" #default>
            <p>Para salvar um modelo, preencha os campos abaixo.</p><br>
            <div>
                <div class="field">
                    <label><?= i::__('Nome do modelo') ?></label>
                    <input type="text" v-model="formData.name">
                </div><br>

                <div class="field">
                    <label><?= i::__('Breve descrição do modelo') ?></label>
                    <textarea placeholder="Breve descrição" v-model="formData.description"></textarea>
                </div>
            </div>
        </template>

        <template v-if="!sendSuccess"  #actions="modal">
            <button class="button button--primary" @click="save(modal)"><?= i::__('Salvar modelo') ?></button>
            <button class="button button--text button--text-del" @click="modal.close()"><?= i::__('cancelar') ?></button>
        </template>
        <template  v-if="sendSuccess"  #actions="modal">
            <button class="button button--primary" @click="modal.close()"><?= i::__('Fechar') ?></button>
        </template>

        <template #button="modal">
            <button type="button" @click="modal.open();" class="button button--icon button--sm"><?= i::__('Salvar modelo') ?></button>
        </template>
    </mc-modal>
</div>