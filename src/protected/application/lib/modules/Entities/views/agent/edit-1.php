<?php 
use MapasCulturais\i;
$this->layout = 'entity'; 

$this->import('
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
    mapas-breadcrumb
    mapas-card
    mapas-container
');

$this->breadcramb = [
    ['label'=> i::__('Painel'), 'url' => $app->createUrl('panel', 'index')],
    ['label'=> i::__('Meus Agentes'), 'url' => $app->createUrl('panel', 'agents')],
    ['label'=> $entity->name, 'url' => $app->createUrl('agent', 'edit', [$entity->id])],
];
?>

<div class="main-app">

    <mapas-breadcrumb></mapas-breadcrumb>
            
    <entity-header :entity="entity" :editable="true"></entity-header>

    <mapas-container>

        <mapas-card class="feature">
            <template #title>
                <label><?php i::_e("Informações de Apresentação")?></label>
                <p><?php i::_e("Os dados inseridos abaixo serão exibidos para todos os usuários")?></p>
            </template>
            <template #content>                
                <div class="left">
                    <div class="grid-12 v-bottom">
                        <entity-cover :entity="entity" classes="col-12"></entity-cover>

                        <div class="col-3 sm:col-12">
                            <entity-profile :entity="entity"></entity-profile>
                        </div>

                        <div class="col-9 sm:col-12">
                            <entity-field :entity="entity" prop="name"></entity-field>
                        </div>

                        <div class="col-12">
                            <entity-field :entity="entity" prop="shortDescription"></entity-field>
                        </div>

                        <div class="col-12">
                            <entity-field :entity="entity" prop="site"></entity-field>
                        </div>
                    </div>                      
                </div>

                <div class="divider"></div>

                <div class="right">
                    <div class="grid-12">
                        <entity-terms :entity="entity" taxonomy="area" :editable="true" classes="col-12" title="<?php  i::_e('Áreas de interesse'); ?>"></entity-terms>
                        <entity-social-media :entity="entity" :editable="true" classes="col-12"></entity-social-media>
                    </div>
                </div>
            </template>
        </mapas-card>

        <main>
            <mapas-card>
                <template #title>
                    <label><?php i::_e("Dados Pessoais"); ?></label>
                    <p><?php i::_e("Os dados inseridos abaixo serão registrados apenas no sistema e não serão exibidos publicamente"); ?></p>
                </template>
                <template #content>                
                    <div class="grid-12">
                        <div class="col-12">
                            <entity-field :entity="entity" prop="nomeCompleto" label="<?= i::__('Nome Completo') ?>"></entity-field>
                        </div>

                        <div class="col-12">
                            <entity-field :entity="entity" prop="documento"></entity-field>
                        </div>
                        
                        <div class="col-12">
                            <entity-field :entity="entity" prop="emailPrivado"></entity-field>
                        </div>
                        
                        <div class="col-12">
                            <entity-field :entity="entity" prop="telefonePublico"></entity-field>
                        </div>
                        
                        <div class="col-12">
                            <entity-field :entity="entity" prop="emailPublico"></entity-field>
                        </div>
                        
                        <div class="col-12">
                            <entity-field :entity="entity" prop="telefone1"></entity-field>
                        </div>
                        
                        <div class="col-12">
                            <entity-field :entity="entity" prop="telefone2"></entity-field>
                        </div>
                    
                        <div class="col-12 divider"></div>

                        <entity-location :entity="entity" classes="col-12" :editable="true"></entity-location>
                    </div>
                </template>
                
            </mapas-card>

            <mapas-card>
                <template #title>
                    <label><?php i::_e("Dados pessoais sensíveis"); ?></label>
                    <p><?php i::_e("Os dados inseridos abaixo serão registrados apenas no sistemas e não serão exibidos publicamente"); ?></p>
                </template>
                <template #content>
                    <div class="grid-12">
                        <div class="col-6 sm:col-12">
                            <entity-field :entity="entity" prop="dataDeNascimento" label="<?= i::__('Data de Nascimento') ?>"></entity-field>
                        </div>

                        <div class="col-6 sm:col-12">
                            <entity-field :entity="entity" prop="genero" label="<?= i::__('Selecione o Gênero')?>" ></entity-field>
                        </div>
                        
                        <div class="col-6 sm:col-12">
                            <entity-field :entity="entity" prop="orientacaoSexual" label="<?= i::__('Selecione a Orientação Sexual') ?>"></entity-field>
                        </div>

                        <div class="col-6 sm:col-12">
                            <entity-field :entity="entity" prop="raca" label="<?= i::__('Selecione a Raça/Cor') ?>"></entity-field>
                        </div>
                    </div>
                </template>
            </mapas-card>

            <mapas-card>
                <template #title>
                    <label><?php i::_e("Mais informações públicas"); ?></label>
                    <p><?php i::_e("Os dados inseridos abaixo assim como as informações de apresentação também são exibidos publicamente"); ?></p>
                </template>
                <template #content>
                    <div class="grid-12">
                        <div class="col-12">
                            <entity-field :entity="entity" prop="longDescription"></entity-field>
                        </div>

                        <entity-files-list :entity="entity" group="downloads" classes="col-12"  title= "<?php i::_e('Adicionar arquivos para download'); ?>" :editable="true"></entity-files-list>
                    
                        <entity-links title="<?php i::_e('Adicionar'); ?>" :entity="entity"  :editable="true"></entity-links>
                    
                        <entity-gallery-video title="<?php i::_e('Adicionar vídeos') ?>" :entity="entity" classes="col-12" v :editable="true"></entity-gallery-video>
                    
                        <entity-gallery title="<?php i::_e('Adicionar fotos na galeria') ?>" :entity="entity" classes="col-12" :editable="true"></entity-gallery>
                    </div>
                </template>
            </mapas-card>
        </main>

        <aside>
            <mapas-card>
                <template #content>
                    <div class="grid-12">
                        <entity-admins :entity="entity" classes="col-12" :editable="true"></entity-admins>
                    
                        <entity-terms :entity="entity" taxonomy="tag" classes="col-12" title="Tags" :editable="true"></entity-terms>
                    
                        <entity-related-agents :entity="entity" classes="col-12" :editable="true"></entity-related-agents>
                    
                        <entity-owner :entity="entity" classes="col-12" title="Publicado por" :editable="true"></entity-owner>
                    </div>

                </template>
            </mapas-card>
        </aside>
        
    </mapas-container>    

    <entity-actions :entity="entity"></entity-actions>

</div>
