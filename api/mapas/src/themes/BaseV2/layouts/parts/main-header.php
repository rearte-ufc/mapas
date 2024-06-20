<?php
/**
 * @var MapasCulturais\App $app
 * @var MapasCulturais\Themes\BaseV2\Theme $this
 */

use MapasCulturais\i;

$this->import('
    mc-header-menu
    mc-header-menu-user
    mc-icon
    mc-messages
    theme-logo
');
?>
<?php $this->applyTemplateHook('main-header', 'before') ?>
<header class="main-header" id="main-header">
    <?php $this->applyTemplateHook('main-header', 'begin') ?>

    <div class="main-header__content">

        <?php $this->applyTemplateHook('mc-header-menu', 'before') ?>
        <mc-header-menu>

            <!-- Logo -->
            <template #logo>
                <theme-logo href="<?= $app->createUrl('site', 'index') ?>"></theme-logo>
            </template>
            <!-- Menu principal -->
        </mc-header-menu>
        <?php $this->applyTemplateHook('mc-header-menu', 'after') ?>

        <div class="main-header__buttons">
            <?php $this->applyTemplateHook('mc-header-menu-user', 'before') ?>
            <?php if ($app->user->is('guest')): ?>
                <!-- Botão login -->
                <a href="<?= $app->createUrl('auth') ?>?redirectTo=<?=$_SERVER['REQUEST_URI']?>" class="logIn">
                    <?php i::_e('Entrar') ?>
                </a>
            <?php else: ?>
                <!-- Menu do usuário -->
                <mc-header-menu-user></mc-header-menu-user>
            <?php endif; ?>
            <?php $this->applyTemplateHook('mc-header-menu-user', 'after') ?>
        </div>

    </div>

    <?php $this->applyTemplateHook('main-header', 'end') ?>
</header>
<?php $this->applyTemplateHook('main-header', 'after') ?>

<mc-messages></mc-messages>
