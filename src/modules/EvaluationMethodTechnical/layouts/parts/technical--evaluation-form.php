<?php
use MapasCulturais\i;
$module = $app->modules['EvaluationMethodTechnical'];

$params = ['registration' => $entity, 'opportunity' => $opportunity];
// eval(\Psy\sh());
$cat = $params['registration']->category
?>
<?php $this->applyTemplateHook('evaluationForm.technical', 'before', $params); ?>
<div ng-controller="TechnicalEvaluationMethodFormController" class="technical-evaluation-form">
    <?php $this->applyTemplateHook('evaluationForm.technical', 'begin', $params); ?>
    <section ng-repeat="section in ::data.sections">
        <table>
            <tr class="title" >
                <th colspan="2">
                    {{section.name}}
                </th>
            </tr>
            <tr class="criteria" ng-repeat="cri in ::data.criteria" ng-if="cri.sid == section.id">
                <td>
                    <?php echo $plugin->step ?><label for="{{cri.id}}">{{cri.title}} min: {{cri.min}}<br>max: {{cri.max}}<br>peso: {{cri.weight}}</label>
            </td>
                <td><select id="{{cri.id}}" name="data[{{cri.id}}]" step="<?php echo $plugin->step ?>" ng-model="evaluation[cri.id]" class="autosave"><option value="0">0</option><option value="0.25">0.25</option><option value="0.50">0.50</option><option value="0.75">0.75</option><option value="1">1.00</option></select></td>
            </tr>
            <tr class="subtotal">
                <td><?php i::_e('Subtotal')?></td>
                <td>{{subtotalSection(section)}}</td>
            </tr>
        </table>
    </section>
    <hr>
    <label class="feedback">
        <?php i::_e('Parecer Técnico') ?>
        <textarea name="data[obs]" ng-model="evaluation['obs']" class="autosave"></textarea>
    </label>
    <hr>
    <label>
        <strong><?php i::_e('Recomenda para receber o selo "Periferia Viva é Periferia Sem Risco"?'); ?></strong><span class="required">*</span>
        <br>
        <label class="input-label">
            <input type="radio" name="data[recomenda-selo]" value="sim" ng-model="evaluation['recomenda-selo']" />
            <em><?php i::_e('Sim')?></em> <br>

            <input type="radio" name="data[recomenda-selo]" value="nao" ng-model="evaluation['recomenda-selo']" />
            <em><?php i::_e('Não')?></em>
        </label>
    </label>
    <hr>

    <label ng-show="data.enableViability=='true'">
        <strong> <?php i::_e('Exequibilidade Orçamentária'); ?> </strong> <span class="required">*</span> <br>
        <?php i::_e('Esta proposta está adequada ao orçamento apresentado? Os custos orçamentários estão compatíveis com os praticados no mercado?'); ?>
        <br>
        <label class="input-label">
            <input type="radio" name="data[viability]" value="valid" ng-model="evaluation['viability']" required="required"/>
            <em><?php i::_e('Sim')?></em> <br>

            <input type="radio" name="data[viability]" value="invalid" ng-model="evaluation['viability']"/>
            <em><?php i::_e('Não')?></em>
        </label>
    </label>
    <hr>
    <div class='total'>
        <?php i::_e('Pontuação Total'); ?>: <strong>{{total(total)}}</strong><br>
        <?php i::_e('Pontuação Máxima'); ?>: <strong>{{max(total)}}</strong>
    </div>
    <?php $this->applyTemplateHook('evaluationForm.technical', 'end', $params); ?>
</div>
<?php $this->applyTemplateHook('evaluationForm.technical', 'after', $params); ?>
