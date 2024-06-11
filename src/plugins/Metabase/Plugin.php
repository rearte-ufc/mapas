<?php

namespace Metabase;

use MapasCulturais\App;

class Plugin extends \MapasCulturais\Plugin
{
    function __construct($config = [])
    {
        $config += [
            'links' => [],
            'cards' => $this->getCardsConfigs(),
        ];

        parent::__construct($config);
    }

    public function _init()
    {
        $app = App::i();
        //load css
        $app->hook('<<GET|POST>>(<<*>>.<<*>>)', function() use ($app) {
            $app->view->enqueueStyle('app-v2', 'metabase', 'css/plugin-metabase.css');
        });
        $app->hook('component(home-feature):after', function() {
            /** @var \MapasCulturais\Theme $this */
            $this->part('home-metabase');
        });

        $app->hook('template(search.agents.search-tabs):after', function(){
            $this->part('search-tabs/agent');
        });

        $app->hook('template(search.agents.search-header):after', function(){
            $this->part('search-tabs/entity-agent-cards');
        });

        $self= $this;
        $app->hook('app.init:after', function() use ($self){
            $this->view->metabasePlugin = $self;
        });

        $app->hook('component(mc-icon).iconset', function(&$iconset) {
            $iconset['indicator'] = 'cil:chart-line';
        });

    }

    public function register()
    {
        $app = App::i();

        $app->registerController('metabase', 'Metabase\Controllers\Metabase');
    }

    private function getCardsConfigs()
    {
        return 
            [
                // spaces
                [
                    'type' => 'space',
                    'label' => 'Espaços',
                    'icon'=> 'space',
                    'iconClass'=> 'space__color',
                    'panelLink'=> 'painel-espacos',
                    'data'=> [
                        [
                            'label' => 'espaços cadastrados',
                            'entity' => 'MapasCulturais\\Entities\\Space',
                            'query' => [],
                            'value' => null
                        ],
                        [
                            'label'=> 'espaços certificados',
                            'entity'=> 'MapasCulturais\\Entities\\Space',
                            'query'=> [
                                '@verified'=> 1
                            ],
                            'value'=> null
                        ]
                    ]
                ],
                // agents
                [
                    'type' => 'agent',
                    'label' => '',
                    'icon'=> '',
                    'iconClass'=> 'agent__color',
                    'panelLink'=> 'painel-agentes',
                    'data'=> [
                        [
                            'label' => 'Agentes cadastrados',
                            'entity' => 'MapasCulturais\\Entities\\Agent',
                            'query' => [],
                            'value' => null
                        ],
                    ]
                ],
                [
                    'type' => 'agent',
                    'label' => '',
                    'icon'=> '',
                    'iconClass'=> 'agent__color',
                    'panelLink'=> 'painel-agentes',
                    'data'=> [
                        [
                            'label' => 'Agentes individuais',
                            'entity' => 'MapasCulturais\\Entities\\Agent',
                            'query' => ['type' => 'EQ(1)'],
                            'value' => null
                        ],
                    ]
                ], 
                [
                    'type' => 'agent',
                    'label' => '',
                    'icon'=> '',
                    'iconClass'=> 'agent__color',
                    'panelLink'=> 'painel-agentes',
                    'data'=> [
                        [
                            'label' => 'Agentes coletivos',
                            'entity' => 'MapasCulturais\\Entities\\Agent',
                            'query' => ['type' => 'EQ(2)'],
                            'value' => null
                        ],
                    ]
                ],
                [
                    'type' => 'agent',
                    'label' => '',
                    'icon'=> '',
                    'iconClass'=> 'agent__color',
                    'panelLink'=> 'painel-agentes',
                    'data'=> [
                        [
                            'label' => 'Cadastrados nos últimos 7 dias',
                            'entity' => 'MapasCulturais\\Entities\\Agent',
                            'query' => [],
                            'value' => null
                        ],
                    ]
                ],
                // opportunity
                [
                    'type' => 'opportunity',
                    'label' => 'Oportunidades',
                    'icon'=> 'opportunity',
                    'iconClass'=> 'opportunity__color',
                    'panelLink'=> 'painel-oportunidades',
                    'data'=> [
                        [
                            'label' => 'Oportunidades criadas',
                            'entity' => 'MapasCulturais\\Entities\\Opportunity',
                            'query' => [],
                            'value' => null
                        ],
                        [
                            'label' => 'Oportunidades certificadas',
                            'entity' => 'MapasCulturais\\Entities\\Opportunity',
                            'query'=> [
                                '@verified'=> 1
                            ],
                            'value' => null
                        ],
                    ]
                ]
        ];
    }
}
