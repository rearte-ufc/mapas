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
    <mc-tab label="<?= i::_e('Válidos (2)') ?>" slug="valid">
        <mc-container>
            <div class="seals-relations-background">
                <h2 class="seals-relations-title">Selos válidos</h2>
                <hr>
                <p>some text</p>
                <hr>

                <div class="seals-relations-item">
                    <div class="seals-relations-item-image">
                        <img src="https://via.placeholder.com/150" alt="">
                    </div>
                    <div class="seals-relations-item-content">
                        <h3>Nome do Selo</h3>
                        <p><b>Criador do selo:</b> nome do criador</p>
                        <p><b>Selo atribuido por:</b> nome do agente</p>
                        <p>Descrição curta do selo</p>
                        <p><mc-icon name="date"></mc-icon> Data de recebimento do selo: 2022-12-31</p>
                        <p><mc-icon name="date"></mc-icon> Validade do selo: 2022-12-31</p>
                    </div>
                </div>
            </div>
            </div>
        </mc-container>
    </mc-tab>

    <mc-tab label="<?= i::_e('Expirados (2)') ?>" slug="expired">22{{entity.seals}}</mc-tab>
</mc-tabs>