app.component('registration-workplan', {
    template: $TEMPLATES['registration-workplan'],
    setup() {
        const text = Utils.getTexts('registration-workplan');
        return { text };
    },
    props: {
        registration: {
            type: Entity,
            required: true
        },
    },
    data() {
        this.getWorkplan();

        return {
            opportunity: this.registration.opportunity,
            workplan: {
                id: null,
                registrationId: this.registration.id,
                projectDuration: null,
                culturalArtisticSegment: null,
                goals: []
            },
        };
    },
    methods: {
        getWorkplan() {
            const api = new API('workplan');
            
            const response = api.GET(`${this.registration.id}`);
            response.then((res) => res.json().then((data) => {
                if (data.workplan != null) {
                    this.workplan = data.workplan;
                }
            }));
        },
        async newGoal() {
            if (!this.validateGoal()) {
                return false;
            }

            const objectGoal = {
                id: null,
                monthInitial: null,
                monthEnd: null,
                title: null,
                description: null,
                culturalMakingStage: null,
                amount: null,
                deliveries: [],
                isCollapsed: true
            };

            this.workplan.goals.push(objectGoal);
        },
        async deleteGoal(goalId) {
            const api = new API('workplan');

            const response = api.DELETE('goal', {id: goalId});
            response.then((res) => res.json().then((data) => {
                this.workplan.goals = this.workplan.goals.filter(goal => goal.id !== goalId);
            }));
        },
        async newDelivery(goal) {
            if (!this.validateDelivery(goal)) {
                return false;
            }

            const objectDelivery = {
                id: null,
                name: null,
                description: null,
                type: null,
                segmentDelivery: null,
                budgetAction: null,
                expectedNumberPeople: null,
                generaterRevenue: null,
                renevueQtd: null,
                unitValueForecast: null,
                totalValueForecast: null,
            };

            goal.deliveries.push(objectDelivery);
        },
        async deleteDelivery(deliveryId) {
            const api = new API('workplan');

            const response = api.DELETE('delivery', {id: deliveryId});
            response.then((res) => res.json().then((data) => {
                this.workplan.goals = this.workplan.goals.map(goal => {
                    if (goal.deliveries) {
                        goal.deliveries = goal.deliveries.filter(delivery => delivery.id !== deliveryId);
                    }
                    return goal;
                });
            }));
        },
        validateGoal() {
            const messages = useMessages();

            let validationMessages = [];

            this.workplan.goals.forEach((goal, index) => {
                let emptyFields = [];
                let position = index+1;
        
                // Verificar cada campo do objeto `goal`
                if (!goal.monthInitial) emptyFields.push("Mês inicial");
                if (!goal.monthEnd) emptyFields.push("Mês final");
                if (!goal.title) emptyFields.push("Título da meta");
                if (!goal.description) emptyFields.push("Descrição");
                if (this.opportunity.workplan_metaInformTheStageOfCulturalMaking && !goal.culturalMakingStage) emptyFields.push("Etapa do fazer cultural");
                if (this.opportunity.workplan_metaInformTheValueGoals && goal.amount == null || goal.amount === "") emptyFields.push("Valor da meta (R$)");
                if (goal.deliveries.length === 0) emptyFields.push("Entrega");

                const validateDelivery = this.validateDelivery(goal);
                if (validateDelivery.length > 0) {
                    emptyFields.push(validateDelivery);
                }
        
                // Adicionar mensagem ao array se houver campos vazios
                if (emptyFields.length > 0) {
                    validationMessages.push(
                        `<br>A meta ${position} possui os seguintes campos vazios:<br> ${emptyFields.join(", ")}<br>`
                    );
                }
            });
        
            if (validationMessages.length > 0) {
                messages.error(validationMessages);
                return false;
            }
            
            return true;
        },
        validateDelivery(goal) {
            const messages = useMessages();

            let validationMessages = [];

            goal.deliveries.forEach((delivery, index) => {
                let emptyFields = [];
                let position = index+1;
        
                if ('name' in delivery && !delivery.name) emptyFields.push("Nome da entrega");
                if ('description' in delivery && !delivery.description) emptyFields.push("Descrição");
                if ('type' in delivery && !delivery.type) emptyFields.push("Tipo de entrega");
                if (this.opportunity.workplan_registrationInformCulturalArtisticSegment && 'segmentDelivery' in delivery && !delivery.segmentDelivery) emptyFields.push("Segmento artístico cultural da entrega");
                if (this.opportunity.workplan_registrationInformActionPAAR && 'budgetAction' in delivery && !delivery.budgetAction) emptyFields.push("Ação orçamentária");
                if (this.opportunity.workplan_registrationReportTheNumberOfParticipants && 'expectedNumberPeople' in delivery && !delivery.expectedNumberPeople) emptyFields.push("Número previsto de pessoas");
                if (this.opportunity.workplan_registrationReportExpectedRenevue && 'generaterRevenue' in delivery && !delivery.generaterRevenue) emptyFields.push("A entrega irá gerar receita?");
                if (delivery.generaterRevenue == 'true' && 'renevueQtd' in delivery && !delivery.renevueQtd) emptyFields.push("Quantidade");
                if (delivery.generaterRevenue == 'true' && 'unitValueForecast' in delivery && !delivery.unitValueForecast) emptyFields.push("Previsão de valor unitário");
                if (delivery.generaterRevenue == 'true' && 'totalValueForecast' in delivery && !delivery.totalValueForecast) emptyFields.push("Previsão de valor total");
                
                if (emptyFields.length > 0) {
                    validationMessages.push(
                        `<br>A entrega ${position} possui os seguintes campos vazios:<br> ${emptyFields.join(", ")}<br>`
                    );
                }
            });
        
            return validationMessages;
        },
        async save_() {    
            if (!this.validateGoal()) {
                return false;
            }
            const messages = useMessages();        
            const api = new API('workplan');

            let data = {
                registrationId: this.registration.id,
                workplan: this.workplan,
            };

            const response = api.POST(`save`, data);
            response.then((res) => res.json().then((data) => {                
                this.getWorkplan();
                messages.success('Modificações salvas');
            }));    
        },
        toggleCollapse(index) {
            this.workplan.goals[index].isCollapsed = !this.workplan.goals[index].isCollapsed;
        },
        range(start, end) {
            return Array.from({ length: end - start + 1 }, (_, i) => start + i);
        },
        enableNewGoal(workplan) {
            if (workplan.projectDuration == null || workplan.culturalArtisticSegment == null) {
                return false;
            }

            if (!this.opportunity.workplan_metaLimitNumberOfGoals) {
                return true;
            }
            
            return this.opportunity.workplan_metaMaximumNumberOfGoals > workplan.goals.length;
        },
        enableNewDelivery(goal) {
            if (this.opportunity.workplan_deliveryReportTheDeliveriesLinkedToTheGoals) {
                if (this.opportunity.workplan_deliveryLimitNumberOfDeliveries) {
                    return this.opportunity.workplan_deliveryMaximumNumberOfDeliveries > goal.deliveries.length;
                }
                return true;
            }
            return false;
        },
        totalValueForecastToCurrency(delivery, renevueQtd, unitValueForecast) {
            let value = renevueQtd * unitValueForecast;
            delivery.totalValueForecast = value;
            return new Intl.NumberFormat("pt-BR", {
                style: "currency",
                currency: "BRL"
              }).format(value);
        },
    },
})