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
    <mc-modal title="<?= i::__('Nova oportunidade') ?>">
        <template #default>
            <div>
                <div class="field">
                    <label><?= i::__('Título do edital') ?></label>
                    <input type="text" v-model="formData.name">
                </div><br>
            </div>
        </template>

        <template v-if="!sendSuccess"  #actions="modal">
            <button class="button button--primary" @click="save(modal)"><?= i::__('Começar') ?></button>
            <button class="button button--text button--text-del" @click="modal.close()"><?= i::__('cancelar') ?></button>
        </template>

        <template #button="modal">
            <button type="button" @click="modal.open();" class="button button--icon button--sm"><?= i::__('Usar modelo') ?></button>
        </template>
    </mc-modal>
</div>