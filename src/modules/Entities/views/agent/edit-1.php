<?php

use MapasCulturais\i;

$this->layout = 'entity';

$this->import('
    confirm-before-exit
    elderly-person
    entity-actions
    entity-admins
    entity-cover
    entity-field
    entity-files-list
    entity-gallery
    entity-gallery-video
    entity-header
    entity-links
    entity-location
    entity-owner
    entity-profile
    entity-related-agents
    entity-social-media
    entity-terms
    entity-status
    mc-breadcrumb
    mc-card
    mc-container
    mc-tabs
    mc-tab

');

$label = $this->isRequestedEntityMine() ? i::__('Meus agentes') : i::__('Agentes');
$this->breadcrumb = [
    ['label' => i::__('Painel'), 'url' => $app->createUrl('panel', 'index')],
    ['label' => $label, 'url' => $app->createUrl('panel', 'agents')],
    ['label' => $entity->name, 'url' => $app->createUrl('agent', 'edit', [$entity->id])],
];
?>

<div class="main-app">
    <mc-breadcrumb></mc-breadcrumb>
    <entity-header :entity="entity" editable></entity-header>

    <mc-tabs class="tabs" sync-hash>
        <?php $this->applyTemplateHook('tabs','begin') ?>
        <mc-tab label="<?= i::_e('Informações') ?>" slug="info">
            <mc-container>
                <entity-status :entity="entity"></entity-status>
                <label><?php i::_e("Campos marcados com <span style='color:red;'>*</span> são de preenchimento obrigatório.") ?></label>
                <mc-card class="feature__full">
                    <template #title>
                        <h3><?php i::_e("Informações de Apresentação") ?></h3>
                        <p><?php i::_e("Os dados inseridos abaixo serão exibidos para todos os usuários") ?></p>
                    </template>
                    <template #content>
                        <div class="grid-12">
                            <entity-cover :entity="entity" classes="col-12"></entity-cover>

                            <div class="col-12 grid-12">
                                <div class="col-2 sm:col-12 card_profile">
                                    <entity-profile :entity="entity" :label="false"></entity-profile>
                                </div>
                            </div>

                            <?php $this->applyTemplateHook('entity-info','begin') ?>
                            <entity-field :entity="entity" classes="col-12" prop="name" label="<?php i::_e('Nome de perfil') ?>"></entity-field>
                            <?php $this->applyTemplateHook('entity-info','end') ?>

                            <?php $this->applyTemplateHook('edit1-entity-info-taxonomie-area','before') ?>
                            <entity-terms :entity="entity" taxonomy="area" editable classes="col-12" title="<?php i::_e('Área(s) de atuação *'); ?>"></entity-terms>
                            <?php $this->applyTemplateHook('edit1-entity-info-taxonomie-area','after') ?>
                            <entity-terms :entity="entity" taxonomy="funcao" editable classes="col-12" title="<?php i::_e('Função(ões) na cultura'); ?>"></entity-terms>
                            <entity-terms :entity="entity" taxonomy="tag" classes="col-12" title="Tags" editable></entity-terms>                                
                        
                            <?php $this->applyTemplateHook('edit1-entity-info-shortDescription','before') ?>
                            <entity-field :entity="entity" classes="col-12" prop="shortDescription" label="<?php i::_e('Descrição curta') ?>"></entity-field>
                            <?php $this->applyTemplateHook('edit1-entity-info-shortDescription','after') ?>

                            <entity-field :entity="entity" classes="col-12" prop="longDescription" editable></entity-field>
                                                        
                            <div class="col-12">Site</div>
                            <?php $this->applyTemplateHook('edit1-entity-info-site','before') ?>
                            <entity-field :entity="entity" classes="col-5 sm:col-12" prop="site"></entity-field>
                            <entity-field :entity="entity" classes="col-7 sm:col-12" prop="siteDescription"></entity-field>
                            <?php $this->applyTemplateHook('edit1-entity-info-site','after') ?>

                            <entity-field :entity="entity" classes="col-5 sm:col-12" prop="emailPublico" label="<?= i::__('E-mail público') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-7 sm:col-12" prop="telefonePublico" label="<?= i::__('Telefone público (com DDD)') ?>"></entity-field>

                        </div>
                    </template>
                </mc-card>

                <mc-card class="feature__full">
                    <template #title>
                        <h3 class="bold"><?php i::_e("Dados Pessoais"); ?></h3>
                        
                    </template>
                    <template #content>
                        <div class="grid-12">
                            <p class="col-12 mc-card__card_info"><?php i::_e("Os dados inseridos abaixo não serão exibidos publicamente, exceto os casos em que forem selecionadas as opções ”Mostrar no perfil”."); ?></p>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="nomeSocial" label="<?= i::__('Nome Social') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="nomeCompleto" label="<?= i::__('Nome Completo') ?>"></entity-field>
                            <entity-field v-if="global.auth.is('admin')" :entity="entity" prop="type" @change="entity.save(true).then(() => global.reload())" classes="col-12 sm:col-12"></entity-field>
                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="cpf"></entity-field>
                            <!-- <entity-field :entity="entity" classes="col-12" prop="cnpj" label="<?= i::__('MEI (CNPJ do MEI)') ?>"></entity-field> -->
                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="emailPrivado" label="<?= i::__('E-mail pessoal') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="telefone1" label="<?= i::__('Telefone pessoal (com DDD)') ?>"></entity-field>
                            <!-- <entity-field :entity="entity" classes="col-6 sm:col-12" prop="telefone2" label="<?= i::__('Telefone privado 2 com DDD') ?>"></entity-field> -->
                            <div class="divider col-12"></div>
                            <entity-location :entity="entity" classes="col-12 sm:col-12" editable></entity-location>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="agenteItinerante" label="<?= i::__('É agente itinerante?') ?>"></entity-field>
                        </div>
                        <div class="divider"></div>
                        <h4>Dados bancário</h4>
                       
                        <div class="grid-12">
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="payment_bank_account_type"></entity-field>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="payment_bank_number"></entity-field>
                            <entity-field :entity="entity" classes="col-3 sm:col-12" prop="payment_bank_account_number"></entity-field>
                            <entity-field :entity="entity" classes="col-3 sm:col-12" prop="payment_bank_dv_account_number"></entity-field>
                            <entity-field :entity="entity" classes="col-3 sm:col-12" prop="payment_bank_branch"></entity-field>
                            <entity-field :entity="entity" classes="col-3 sm:col-12" prop="payment_bank_dv_branch"></entity-field>
                        </div>
                    </template>
                </mc-card>

                <mc-card class="feature__full">
                    <template #title>
                        <h3 class="bold"><?php i::_e("Dados sensíveis"); ?></h3>
                    </template>
                    <template #content>
                        <div class="grid-12">
                            <p class="col-12 mc-card__card_info"><?php i::_e("Os campos em que não forem selecionadas a opção ”Ocultar do perfil” serão exibidos para todos os usuários da plataforma."); ?></p>

                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="dataDeNascimento" label="<?= i::__('Data de Nascimento') ?>"></entity-field>
                            <!-- <div class="field col-6">
                                <label>{{entity.$PROPERTIES['idoso'].label}}</label>
                                <input type="text" disabled :value="entity.idoso ? 'Sim' : 'Não'" />
                            </div>     -->
                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="genero" label="<?= i::__('Gênero') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-4 sm:col-12" prop="orientacaoSexual" label="<?= i::__('Orientação Sexual') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="raca" label="<?= i::__('Raça/Cor') ?>"></entity-field>
                            <entity-field :entity="entity" classes="col-6 sm:col-12" prop="escolaridade" label="<?= i::__('Escolaridade') ?>"></entity-field>
                            
                            <entity-social-media :entity="entity" editable></entity-social-media>
                            </div>
                        </template>
                    </mc-card>
                    <mc-card class="feature__full">
                        <template #title>
                            <label><?php i::_e("Informações públicas"); ?></label>
                            <p><?php i::_e("Os dados inseridos abaixo assim como as informações de apresentação também são exibidos publicamente"); ?></p>
                        </template>
                        <template #content>
                            <div class="grid-12">
                                <entity-files-list :entity="entity" classes="col-12" group="downloads" title="<?php i::_e('Arquivos para download'); ?>" editable></entity-files-list>
                                <entity-links :entity="entity" classes="col-12" title="<?php i::_e('Links'); ?>" editable></entity-links>
                                <entity-gallery-video :entity="entity" classes="col-12" title="<?php i::_e('Vídeos') ?>" editable></entity-gallery-video>
                                <entity-gallery :entity="entity" classes="col-12" title="<?php i::_e('Imagens') ?>" editable></entity-gallery>
                            </div>
                        </template>
                    </mc-card>

                <!-- <aside>
                    <mc-card>
                        <template #content>
                            <div class="grid-12">
                                <entity-admins :entity="entity" classes="col-12" editable></entity-admins>
                                <entity-related-agents :entity="entity" classes="col-12" editable></entity-related-agents>

                                <entity-owner :entity="entity" classes="col-12" title="Publicado por" editable></entity-owner>
                            </div>
                        </template>
                    </mc-card>
                </aside> -->
            </mc-container>
        </mc-tab>
        <?php $this->applyTemplateHook('tabs','end') ?>
    </mc-tabs>
    
    <entity-actions :entity="entity" editable></entity-actions>
</div>
<confirm-before-exit :entity="entity"></confirm-before-exit>