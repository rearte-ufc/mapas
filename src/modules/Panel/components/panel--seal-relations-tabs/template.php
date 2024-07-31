<?php

/**
 * @var \MapasCulturais\Themes\BaseV2\Theme $this
 * @var \MapasCulturais\App $app
 */

use MapasCulturais\i;

$this->import('
    mc-breadcrumb
    mc-container
    mc-tabs
    mc-tab
    mc-icon
');
?>

<mc-tabs>
    <mc-tab :label="validSealsLabel" slug="valid">
        <mc-container>
            <div class="seals-relations-background">
                <p>Esses são os selos que foram atribuídos à você e estão atualmente válidos. Esses selos são apresentados publicamente na plataforma.</p>
                <hr>

                <div class="seals-relations-item">
                    <div class="seals-relations-item-content">
                        <template v-if="validSeals && validSeals.length">
                            <template v-for="seal in validSeals" :key="seal.sealRelationId">
                                <slot :seal="seal">
                                    <div class="seal-relation-content">
                                        <div class="seals-relations-item-image">
                                            <img v-if="seal?.files?.avatar?.transformations?.avatarSmall?.url" :src="seal.files.avatar.transformations.avatarSmall.url" alt="Seal Image">
                                            <img v-else src="https://via.placeholder.com/150" alt="Placeholder Image">
                                        </div>
                                        <h3>{{seal.name}}</h3>
                                        <p><b>Criador do selo: </b>{{seal.sealRelationFullData.seal.owner.name}}</p>
                                        <p><b>Selo atribuido por: </b>{{seal.sealRelationFullData.agent.name}}</p>
                                        <p><b>Descrição curta: </b>{{seal.sealRelationFullData.seal.shortDescription}}</p>
                                        <p><mc-icon name="date"></mc-icon> Data de recebimento do selo: {{ formatReceivedDate(seal) }}</p>
                                        <p><mc-icon name="date"></mc-icon> Validade do selo: {{ formatValidDate(seal) }}</p>
                                    </div>
                                </slot>
                                <hr>
                            </template>
                        </template>
                        <template v-else>
                            <p>No seals available.</p>
                        </template>
                    </div>
                </div>
            </div>
        </mc-container>
    </mc-tab>

    <mc-tab :label="expiredSealsLabel" slug="expired"><mc-container>
            <div class="seals-relations-background">
                <p>Esses são os selos que foram atribuídos à você e estão atualmente válidos. Esses selos são apresentados publicamente na plataforma.</p>
                <hr>

                <div class="seals-relations-item">
                    <div class="seals-relations-item-content">
                        <template v-if="expiredSeals && expiredSeals.length">
                            <template v-for="seal in expiredSeals" :key="seal.sealRelationId">
                                <slot :seal="seal">
                                    <div class="seal-relation-content">
                                        <div class="seals-relations-item-image">
                                            <img v-if="seal?.files?.avatar?.transformations?.avatarSmall?.url" :src="seal.files.avatar.transformations.avatarSmall.url" alt="Seal Image">
                                            <img v-else src="https://via.placeholder.com/150" alt="Placeholder Image">
                                        </div>
                                        <h3>{{seal.name}}</h3>
                                        <p><b>Criador do selo: </b>{{seal.sealRelationFullData.seal.owner.name}}</p>
                                        <p><b>Selo atribuido por: </b>{{seal.sealRelationFullData.agent.name}}</p>
                                        <p><b>Descrição curta: </b>{{seal.sealRelationFullData.seal.shortDescription}}</p>
                                        <p><mc-icon name="date"></mc-icon> Data de recebimento do selo: {{ formatReceivedDate(seal) }}</p>
                                        <p><mc-icon name="date"></mc-icon> Validade do selo: {{ formatValidDate(seal) }}</p>
                                    </div>
                                </slot>
                                <hr>
                            </template>
                        </template>
                        <template v-else>
                            <p>No seals available.</p>
                        </template>
                    </div>
                </div>
            </div>
        </mc-container></mc-tab>
</mc-tabs>