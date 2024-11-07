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
            workplan: {
                id: null,
                registrationId: this.registration.id,
                projectDuration: null,
                culturalArtisticSegment: null,
                goals: []
            },
            meses: [
                "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
                "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
            ]
        };
    },
    methods: {
        getWorkplan() {
            const api = new API('workplan');
            
            const response = api.GET(`${this.registration.id}`);
            response.then((res) => res.json().then((data) => {
                if (data != null) {
                    this.workplan = data.workplan;
                }
            }));
        },
        async newGoal() {
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
        async save_() {
            // return this.registration.save(300, true);

            const api = new API('workplan');

            let data = {
                registrationId: this.registration.id,
                workplan: this.workplan,
            };

            const response = api.POST(`save`, data);
            response.then((res) => res.json().then((data) => {
                this.workplan = data.workplan;
                
                // this.messages.success('Modificações salvas');
            }));

            
        },
        toggleCollapse(index) {
            this.workplan.goals[index].isCollapsed = !this.workplan.goals[index].isCollapsed;
        },
    },
})