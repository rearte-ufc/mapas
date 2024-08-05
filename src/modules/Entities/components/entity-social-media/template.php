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

<!-- editable = false (default) -->
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

    <div v-if="entity.tiktok" class="entity-social-media__links--link">
        <mc-icon name="tiktok"></mc-icon>
        <a target="_blank" :href="buildSocialMediaLink('tiktok')">{{entity.tiktok}}</a>
    </div>
</div>


<!-- Não mostra icon em editaveis (alwaysShowIcons = false) -->
<entity-field  v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="instagram"></entity-field>

<entity-field  v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="twitter"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="facebook"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="vimeo"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="youtube"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="linkedin"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="spotify"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="pinterest"></entity-field>

<entity-field v-if="editable && !showIcons" classes="col-4 sm:col-12" :entity="entity" prop="tiktok"></entity-field>



<!-- Mostra icon em editaveis (alwaysShowIcons = true) -->
<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="instagram"><mc-icon v-if="editable && showIcons" name="instagram"></mc-icon>Instagram</entity-field>

<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="twitter"><mc-icon v-if="editable && showIcons" name="twitter"></mc-icon>X (antigo twitter)</entity-field>

<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="facebook"><mc-icon v-if="showIcons" name="facebook"></mc-icon>Facebook</entity-field>

<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="vimeo"><mc-icon v-if="editable && showIcons" name="vimeo"></mc-icon>Vimeo</entity-field>

<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="youtube"><mc-icon v-if="editable && showIcons" name="youtube"></mc-icon>Youtube</entity-field>


<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="linkedin"><mc-icon v-if="editable && showIcons" name="linkedin"></mc-icon>Linkedin</entity-field>


<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="spotify"><mc-icon v-if="editable && showIcons" name="spotify"></mc-icon>Spotify</entity-field>


<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="pinterest"><mc-icon v-if="editable && showIcons" name="pinterest"></mc-icon>Pinterest</entity-field>


<entity-field v-if="editable && showIcons" classes="col-4 sm:col-12" :entity="entity" prop="tiktok"><mc-icon v-if="editable && showIcons" name="tiktok"></mc-icon>TikTok</entity-field>
