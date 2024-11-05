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
        if (this.registration.workplan_goals == null) {
            this.registration.workplan_goals = [];
        }

        const workplan_goals = this.registration.workplan_goals;

        return {
            registration: this.registration,
            workplan_goals,
            duracaoProjeto: '',
            meses: [
                "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
                "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
            ]
        };
    },
    methods: {
        generateUUIDv4() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                const r = (Math.random() * 16) | 0;
                const v = c === 'x' ? r : (r & 0x3) | 0x8;
                return v.toString(16);
            });
        },
        async newGoal() {
            const objectGoal = {
                id: this.generateUUIDv4(),
                monthInitial: '',
                monthEnd: '',
                title: '',
                description: '',
                culturalMakingStage: '',
                amount: '',
                deliveries: [],
                isCollapsed: true
            };

            this.workplan_goals.push(objectGoal);
        },
        async deleteGoal(index) {
            this.workplan_goals.splice(index, 1);
            await this.save_();
        },
        async newDelivery(indexGoal) {
            const objectDelivery = {
                id: this.generateUUIDv4(),
                name: '',
                description: '',
                type: '',
                artisticCulturalSegmentOfDelivery: '',
                budgetAction: '',
                expectedNumberOfPeople: '',
                deliveryWillGenerateRevenue: '',
                renevueQtd: '',
                unitValueForecast: '',
                TotalValueForecast: '',
            };
            this.workplan_goals[indexGoal].deliveries.push(objectDelivery);
        },
        async deleteDelivery(indexGoal, indexDelivery) {
            this.workplan_goals[indexGoal].deliveries.splice(indexDelivery, 1);
            await this.save_();
        },
        async save_() {
            return this.registration.save(300, true);
        },
        toggleCollapse(index) {
            this.workplan_goals[index].isCollapsed = !this.workplan_goals[index].isCollapsed;
        },
    },
})