<?php
/** @var MapasCulturais\Theme $this */
use MapasCulturais\i;

$this->import('
    mapas-card
    confirm-button
');
?>
<entities type="notification" name="notification-list" :query='query' #default='{entities}'>

    <mapas-card :class="['notification-card', styleCss]" v-for="entity in entities" :key="entity.__objectId">
        <div class="avatar">
            <img v-if="hasAvatar(entity)" :src="avatarUrl(entity)">
            <mc-icon v-if="!hasAvatar(entity)" name='agent-1'></mc-icon>
        </div>
        <div class="content">
            <div class="content__header">
                <span class="title" v-html='entity.message'></span>
                <span class="subtitle">{{ entity.createTimestamp?.date('numeric year') }} - {{ entity.createTimestamp?.time() }}</span>
            </div>
            <div class="content__groupButtons" v-if="!entity.request">
                <div class="col-2">
                    <button class="button button--primary-outline" @click="ok(entity)">
                        <?= i::__('Ok') ?>
                    </button>
                </div>
            </div>

            <div class="content__groupButtons" v-else-if="entity.request?.requesterUser?.id === currentUserId">
                <div class="col-2">
                    <button class="button button--primary-outline" @click="cancel(entity)">
                        <?= i::__('Cancelar') ?>
                    </button>
                </div>
                <div class="col-2">
                    <button class="button button--primary-outline" @click="ok(entity)">
                        <?= i::__('Ok') ?>
                    </button>
                </div>
            </div>

            <div class="content__groupButtons" v-else-if="entity.request?.requesterUser?.id !== currentUserId">
                <div class="col-2">
                    <button class="button button--primary-outline" @click="reject(entity)">
                        <?= i::__('Rejeitar') ?>
                    </button>
                </div>
                <div class="col-2">
                    <button class="button button--primary" @click="approve(entity)">
                        <?= i::__('Aceitar') ?>
                    </button>
                </div>
            </div>
        </div>
    </mapas-card>
</entities>