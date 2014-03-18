<div id="busca" ng-class="{'sombra':data.global.viewMode!=='list'}">
    <div id="busca-avancada" class="clearfix">
        <div id="filtro-eventos" class="filtro-objeto clearfix" ng-show="data.global.filterEntity==='event'">
            <form class="form-palavra-chave filtro">
                <label for="palavra-chave-evento">Palavra-chave</label>
                <input ng-model="data.event.keyword" class="campo-de-busca" type="text" name="palavra-chave-evento" placeholder="Digite um palavra-chave" />
            </form>
            <!--#busca-->
            <div class="filtro">
                <label>Intervalo entre</label>
                <a class="tag selected data">00/00/00</a>
                e
                <a class="tag data">00/00/00</a>
            <!-- comentei o datepicker
            <div id="busca-agenda-dia" class="hasDatepicker">
                <div class="ui-datepicker-inline ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all">
                    <div class="ui-datepicker-header ui-widget-header ui-helper-clearfix ui-corner-all">
                        <a class="ui-datepicker-prev ui-corner-all" data-handler="prev" data-event="click" title="Anterior"><span class="icone arrow_carrot-left ui-icon ui-icon-circle-triangle-w"></span></a>
                        <a class="ui-datepicker-next ui-corner-all" data-handler="next" data-event="click" title="Próximo"><span class="icone arrow_carrot-right ui-icon ui-icon-circle-triangle-e"></span></a>
                        <div class="ui-datepicker-title"><span class="ui-datepicker-month">Setembro</span>&nbsp;<span class="ui-datepicker-year">2013</span></div>
                    </div>
                    <table class="ui-datepicker-calendar">
                        <thead>
                        <tr>
                            <th class="ui-datepicker-week-end"><span title="Domingo">D</span>
                            </th><th><span title="Segunda">S</span></th>
                            <th><span title="Terça">T</span></th>
                            <th><span title="Quarta">Q</span></th>
                            <th><span title="Quinta">Q</span></th>
                            <th><span title="Sexta">S</span></th>
                            <th class="ui-datepicker-week-end"><span title="Sábado">S</span></th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">1</a></td>
                            <td class=" ui-datepicker-days-cell-over  ui-datepicker-current-day ui-datepicker-today" data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default ui-state-highlight ui-state-active" href="#">2</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">3</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">4</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">5</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">6</a></td>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">7</a></td>
                        </tr>
                        <tr>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">8</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">9</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">10</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">11</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">12</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">13</a></td>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">14</a></td>
                        </tr>
                        <tr>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">15</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">16</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">17</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">18</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">19</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">20</a></td>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">21</a></td>
                        </tr>
                        <tr>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">22</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">23</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">24</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">25</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">26</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">27</a></td>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">28</a></td>
                        </tr>
                        <tr>
                            <td class=" ui-datepicker-week-end " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">29</a></td>
                            <td class=" " data-handler="selectDay" data-event="click" data-month="8" data-year="2013"><a class="ui-state-default" href="#">30</a></td>
                            <td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">1</span></td>
                            <td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">2</span></td>
                            <td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">3</span></td>
                            <td class=" ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">4</span></td>
                            <td class=" ui-datepicker-week-end ui-datepicker-other-month ui-datepicker-unselectable ui-state-disabled "><span class="ui-state-default">5</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        -->
    </div>
    <!--.filtro-->
    <div class="filtro">
        <label>Linguagem</label>
        <div class="dropdown">
            <div class="placeholder">Selecione as linguagens</div>
            <div class="submenu-dropdown">
                <ul class="lista-de-filtro select">
                    <li ng-repeat="linguagem in linguagens" ng-class="{'selected':isSelected(data.event.linguagens, linguagem.id)}" ng-click="toggleSelection(data.event.linguagens, linguagem.id)">
                        <span>{{linguagem.name}}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
    <div class="filtro">
        <span class="label">Classificação</span>
        <div id="classificacao" class="dropdown">
            <div class="placeholder">Livre</div>
            <div class="submenu-dropdown">
                <ul>
                    <li>18 anos</li>
                    <li>16 anos</li>
                    <li>14 anos</li>
                    <li>12 anos</li>
                    <li>10 anos</li>
                    <li>Livre</li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
</div>
<!--#filtro-eventos-->
<div id="filtro-agentes" class="filtro-objeto clearfix" ng-show="data.global.filterEntity==='agent'">
    <form class="form-palavra-chave filtro">
        <label>Palavra-chave</label>
        <input ng-model="data.agent.keyword" class="campo-de-busca" type="text" name="busca" placeholder="Digite um palavra-chave" />
    </form>
    <!--#busca-->
    <div class="filtro">
        <span class="label">Área de Atuação</span>
        <div class="dropdown">
            <div class="placeholder">Selecione as áreas</div>
            <div class="submenu-dropdown">
                <ul class="lista-de-filtro">
                    <li ng-repeat="area in areas" ng-class="{'selected':isSelected(data.agent.areas, area.id)}" ng-click="toggleSelection(data.agent.areas, area.id)">
                        <span>{{area.name}}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
    <div class="filtro">
        <span class="label">Tipo</span>
        <div id="tipo-de-agente" class="dropdown">
            <div class="placeholder">{{getName(types.agent, data.agent.type)}}&nbsp;</div>
            <div class="submenu-dropdown">
                <ul>
                    <li ng-repeat="type in types.agent" ng-click="data.agent.type = type.id">
                        <span>{{type.name}}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
</div>
<!--#filtro-agentes-->
<div id="filtro-espacos" class="filtro-objeto clearfix" ng-show="data.global.filterEntity==='space'">
    <form class="form-palavra-chave filtro">
        <label for="palavra-chave-espaco">Palavra-chave</label>
        <input ng-model="data.space.keyword" class="campo-de-busca" type="text" name="palavra-chave-espaco" placeholder="Digite um palavra-chave" />
    </form>
    <!--#busca-->
    <div class="filtro">
        <span class="label">Área de Atuação</span>
        <div class="dropdown">
            <div class="placeholder">Selecione as áreas</div>
            <div class="submenu-dropdown">
                <ul class="lista-de-filtro">
                    <li ng-repeat="area in areas" ng-class="{'selected':isSelected(data.space.areas, area.id)}" ng-click="toggleSelection(data.space.areas, area.id)">
                        <span>{{area.name}}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
    <div class="filtro">
        <span class="label">Tipo</span>
        <div class="dropdown">
            <div class="placeholder">Selecione os tipos</div>
            <div class="submenu-dropdown">
                <ul class="lista-de-filtro">
                    <li ng-repeat="type in types.space" ng-class="{'selected':isSelected(data.space.types, type.id)}" ng-click="toggleSelection(data.space.types, type.id)">
                        <span>{{type.name}}</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <!--.filtro-->
    <div class="filtro">
        <span class="icone icon_check" ng-click="data.space.acessibilidade=!data.space.acessibilidade" ng-class="{'selected':data.space.acessibilidade}"></span>
        <span id="label-da-acessibilidade" class="label">
            Acessibilidade
        </span>
    </div>
    <!--.filtro-->
</div>
<!--#filtro-espacos-->
<div class="wrap clearfix">
    <div id="filtro-local" class="filtro-geral clearfix" ng-controller="SearchSpatialController">
        <form id="form-local" method="post" action="#">
            <label for="proximo-a">Local: </label>
            <input id="endereco" type="text" class="proximo-a" name="proximo-a" placeholder="Digite um endereço" />
            <!--<p class="mensagem-erro-proximo-a-mim mensagens">Não foi possível determinar sua localização. Digite seu endereço, bairro ou CEP </p>-->

            <input type="hidden" name="lat" />
            <input type="hidden" name="lng" />
        </form>
        ou
        <a class="hltip proximo-a-mim botao principal" ng-class="{'selected':data.global.locationFilters.enabled==='neighborhood'}" ng-click="filterNeighborhood()" title="Buscar somente resultados próximos a mim.">Próximo a mim</a>
        ou
        <a class="hltip botao principal" ng-class="{'selected':data.global.locationFilters.enabled==='circle'}" ng-click="drawCircle()" title="Buscar somente resultados em uma área delimitada">Delimitar uma área</a>
    </div>
    <!--#filtro-local-->
        <!--
        <form id="form-projeto" class="filtro-geral">
            <label for="nome-do-projeto">Projeto: </label>
            <input class="autocomplete" name="nome-do-projeto" type="text" placeholder="Selecione um projeto" />
            <a class="hltip botao principal" href="#" title="Clique para ver a lista de projetos">Ver projetos</a>
        </form>-->
        <!-- #form-projeto-->
        <div id="filtro-prefeitura" class="filtro-geral">
            <a class="hltip botao principal" ng-class="{'selected':data.global.isVerified}" title="Exibir somente resultados da Secretaria Municipal de Cultura" ng-click="toggleVerified()">Resultados da SMC</a>
        </div>
        <!-- #filtro-prefeitura-->
        <div id="busca-combinada" class="filtro-geral">
            <span class="icone icon_check" ng-click="toggleCombined()" ng-class="{'selected':data.global.isCombined }" ></span>
            <span class="label hltip" title="Nesse modo é possível combinar agentes e espaços no mesmo resultado de busca">
                Busca Combinada
            </span>
        </span>
        <!---<input ng-model="combinedSearch" type="checkbox"/> <label style="display: inline-block;">Busca Combinada (Bó, o html correto tá comentado)</label>-->
    </div>
</div>
<!--.wrap-->
<!--#busca-avancada-->
<div id="header-dos-resultados" class="clearfix"> agentes: {{numAgents}} espaços: {{numSpaces}} eventos: {{numEvents}}
    <style>#resultados{width:auto; float:left; position:static;} #filtros-selecionados{float:left; margin-left: auto;}</style>
    <div id="resultados">
        <span ng-show="spinnerCount > 0" style="display:inline">
            <span style="display:inline" us-spinner="{radius:2, width:2, length: 10, lines:11, top:0, left:1, speed:2}"></span>
            <span style="margin-left:35px">obtendo resultados...</span>
        </span>
        <span ng-style="{visibility: viewLoading && 'hidden' || 'visible'}">
            <!--<strong>00</strong> eventos, -->
            <span ng-show="agentSearch.results.length>0">
                <strong>{{numberFixedLength(agentSearch.results.length,2)||'00'}}</strong> agente<span ng-show="agentSearch.results.length>1">s</span>
                <small style="font-weight:normal; cursor:help;" ng-show="agentSearch.results.length>0 && agentSearch.resultsWithoutMarker>0">
                    <span class="hltip hltip-auto-update" title="{{agentSearch.results.length-agentSearch.resultsWithoutMarker}} agentes mostrados no mapa ({{agentSearch.resultsWithoutMarker}} sem localização)">
                        ({{agentSearch.results.length-agentSearch.resultsWithoutMarker}} <span class="icone icon_pin_alt"></span>)
                    </small>
                </span>
                <span ng-show="combinedSearch && agentSearch.results.length>0 && spaceSearch.results.length>0">,</span>
                <span ng-show="spaceSearch.results.length>0">
                    <strong>{{numberFixedLength(spaceSearch.results.length,2)||'00'}}</strong> espaço<span ng-show="spaceSearch.results.length>1">s</span>
                    <small style="font-weight:normal; cursor:help;" ng-show="spaceSearch.results.length>0 && spaceSearch.resultsWithoutMarker>0">
                        <span class="hltip  hltip-auto-update" title="{{spaceSearch.results.length-spaceSearch.resultsWithoutMarker}} espaços mostrados no mapa ({{spaceSearch.resultsWithoutMarker}} sem localização)">
                            ({{spaceSearch.results.length-spaceSearch.resultsWithoutMarker}} <span class="icone icon_pin_alt"></span>)
                        </span>
                    </small>
                </span>
                <span ng-show="agentSearch.results.length>0&&spaceSearch.results.length>0">
                    <strong>. Total: {{numberFixedLength(agentSearch.results.length+spaceSearch.results.length,2)||'00'}}</strong>
                    <small style="font-weight:normal; cursor:help;" ng-show="(agentSearch.results.length>0 && agentSearch.resultsWithoutMarker>0) || (spaceSearch.results.length>0 && spaceSearch.resultsWithoutMarker>0)">
                        <span  class="hltip  hltip-auto-update" title="{{(agentSearch.results.length-agentSearch.resultsWithoutMarker)+(spaceSearch.results.length-spaceSearch.resultsWithoutMarker)}} agentes e espaços mostrados no mapa ({{agentSearch.resultsWithoutMarker+spaceSearch.resultsWithoutMarker}} sem localização)">
                          ({{(agentSearch.results.length-agentSearch.resultsWithoutMarker)+(spaceSearch.results.length-spaceSearch.resultsWithoutMarker)}}<span class="icone icon_pin_alt"></span>)
                      </span>
                  </small>
              </span>
              <span ng-show="combinedSearch && agentSearch.results.length==0 && spaceSearch.results.length==0">Nenhum resultado encontrado</span>
              <span ng-show="!combinedSearch && agentSearch.enabled && agentSearch.results.length==0">Nenhum resultado encontrado</span>
              <span ng-show="!combinedSearch && spaceSearch.enabled && spaceSearch.results.length==0">Nenhum resultado encontrado</span>
          </span>
      </div>
      <!--#resultados-->
      <div id="filtros-selecionados">
        <a class="tag tag-evento" ng-if="data.event.keyword!==''" ng-click="data.event.keyword=''">{{ data.event.keyword }}</a>
        <a class="tag tag-agente" ng-if="data.agent.keyword!==''" ng-click="data.agent.keyword=''">{{ data.agent.keyword }}</a>
        <a class="tag tag-espaco" ng-if="data.space.keyword!==''" ng-click="data.space.keyword=''">{{ data.space.keyword }}</a>

        <a class="tag tag-agente" ng-if="data.agent.type!==null" ng-click="data.agent.type=null">{{ getName(types.agent, data.agent.type) }}</a>
        <a class="tag tag-espaco" ng-repeat="typeId in data.space.types" ng-click="toggleSelection(data.space.types, typeId)">{{ getName(types.space, typeId) }}</a>

        <a class="tag tag-evento" ng-repeat="linguagemId in data.event.linguagens" ng-click="toggleSelection(data.event.linguagens, linguagemId)">{{ getName(linguagens, linguagemId) }}</a>

        <a class="tag tag-agente" ng-repeat="areaId in data.agent.areas" ng-click="toggleSelection(data.agent.areas, areaId)">{{ getName(areas, areaId) }}</a>
        <a class="tag tag-espaco" ng-repeat="areaId in data.space.areas" ng-click="toggleSelection(data.space.areas, areaId)">{{ getName(areas, areaId) }}</a>

        <a class="tag tag-espaco" ng-if="data.space.acessibilidade" ng-click="data.space.acessibilidade=false">Acessibilidade</a>

        <a class="tag" ng-if="data.global.isVerified" ng-click="toggleVerified()">Resultados da SMC</a>
        <a class="tag" ng-if="data.global.locationFilters.enabled==='circle'" ng-click="cleanLocationFilters()">Área Delimitada</a>
        <a class="tag" ng-if="data.global.locationFilters.enabled==='neighborhood'" ng-click="cleanLocationFilters()">Próximo a mim</a>

        <a class="tag remover-tudo" ng-if="hasFilter()" ng-click="cleanAllFilters()">Remover todos filtros</a>
    </div>
    <!--#filtros-selecionados-->
    <div id="ferramentas">
        <div id="compartilhar">
            <a class="botao-de-icone icone social_share" href="#"></a>
            <form id="compartilhar-url"><div class="setinha"></div><label for="url-da-busca">Compartilhar esse resultado: </label><input id="url-da-busca" name="url-da-busca" type="text" ng-value="location.absUrl()" /><a href="#" class="icone social_twitter"></a><a href="#" class="icone social_facebook"></a><a href="#" class="icone social_googleplus"></a></form>
        </div>
        <div id="views" class="clearfix">
            <a class="hltip botao-de-icone icone icon_menu-square_alt" ng-click="switchView('list')" ng-class="{'selected':data.global.viewMode==='list'}" title="Ver resultados em lista"></a>
            <a class="hltip botao-de-icone icone icon_map selected"  ng-click="switchView('map')"  ng-class="{'selected':data.global.viewMode==='map'}" title="Ver resultados no mapa"></a>
        </div>
    </div>
    <!--#ferramentas-->
</div>
<!--#header-dos-resultados-->
</div>
<!--#busca-->
