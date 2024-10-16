app.component('opportunity-enable-workplan', {
    template: $TEMPLATES['opportunity-enable-workplan'],

    setup() {
        const text = Utils.getTexts('opportunity-enable-workplan');
        return { text };
    },
    props: {
        entity: {
            type: Entity,
            required: true
        }
    },
    data() {
        return {
            entity: this.entity,
            timeOut: null,
        }
    },
    watch: {
        'entity.enableWorkplan'(_new,_old){
            if (!_new) {
                this.disabledWorkPlan();
            }
        },
    },
    methods: {
        autoSave(){
            this.entity.save(3000);
        },
        disabledWorkPlan(){
            this.entity.dataProjectlimitMaximumDurationOfProjects = false;
            this.entity.dataProjectmaximumDurationInMonths = 0;
            this.entity.metaInformTheStageOfCulturalMaking = false;
            this.entity.metaLimitNumberOfGoals = false;
            this.entity.metaMaximumNumberOfGoals = 0;
            this.entity.deliveryReportTheDeliveriesLinkedToTheGoals = false;
            this.entity.deliveryReportTheNumberOfParticipants = false;
            this.entity.deliveryReportExpectedRenevue = false;
            this.entity.monitoringInformAccessibilityMeasures = false;
            this.entity.monitoringProvideTheProfileOfParticipants = false;
            this.entity.monitoringInformThePriorityAudience = false;
            this.entity.monitoringInformDeliveryType = false;
            this.entity.monitoringReportExecutedRevenue = false;
            this.entity.monitoringLimitNumberOfDeliveries = false;
            this.entity.monitoringMaximumNumberOfDeliveries = 0;
        }
    },
    computed: {

    }
})