<?php 
/**
 * @var MapasCulturais\App $app
 * @var MapasCulturais\Themes\BaseV2\Theme $this
 */

use MapasCulturais\i;
$this->import('
    entity-field
');
?>

<div v-if="!editable" class="entity-social-media__links">
    <div v-if="entity.instagram" class="entity-social-media__links--link">
        <mc-icon name="instagram"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('instagram')">{{entity.instagram}}</a>
    </div>

    <div v-if="entity.twitter" class="entity-social-media__links--link">
        <mc-icon name="twitter"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('twitter')">{{entity.twitter}}</a>
    </div>

    <div v-if="entity.facebook" class="entity-social-media__links--link">
        <mc-icon name="facebook"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('facebook')">{{entity.facebook}}</a>
    </div>

    <div v-if="entity.youtube" class="entity-social-media__links--link">
        <mc-icon name="youtube"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('youtube')">{{entity.youtube}}</a>
    </div>

    <div v-if="entity.linkedin" class="entity-social-media__links--link">
        <mc-icon name="linkedin"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('linkedin')">{{entity.linkedin}}</a>
    </div>

    <div v-if="entity.vimeo" class="entity-social-media__links--link">
        <mc-icon name="vimeo"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('vimeo')">{{entity.vimeo}}</a>
    </div>

    <div v-if="entity.spotify" class="entity-social-media__links--link">
        <mc-icon name="spotify"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('spotify')">{{entity.spotify}}</a>
    </div>

    <div v-if="entity.pinterest" class="entity-social-media__links--link">
        <mc-icon name="pinterest"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('pinterest')">{{entity.pinterest}}</a>
    </div>
</div>


<!-- <mc-icon name="instagram"></mc-icon> -->
<entity-field  v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="instagram"></entity-field>

<!-- <mc-icon name="twitter"></mc-icon> -->
<entity-field  v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="twitter"></entity-field>

<!-- <mc-icon name="facebook"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="facebook"></entity-field>

<!-- <mc-icon name="vimeo"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="vimeo"></entity-field>

<!-- <mc-icon name="youtube"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="youtube"></entity-field>

<!-- <mc-icon name="linkedin"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="linkedin"></entity-field>

<!-- <mc-icon name="spotify"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="spotify"></entity-field>

<!-- <mc-icon name="pinterest"></mc-icon> -->
<entity-field v-if="editable" classes="col-4 sm:col-12" :entity="entity" prop="pinterest"></entity-field>
