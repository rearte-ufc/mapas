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
            this.entity.workplan_dataProjectlimitMaximumDurationOfProjects = false;
            this.entity.workplan_dataProjectmaximumDurationInMonths = 0;
            this.entity.workplan_metaInformTheStageOfCulturalMaking = false;
            this.entity.workplan_metaLimitNumberOfGoals = false;
            this.entity.workplan_metaMaximumNumberOfGoals = 0;
            this.entity.workplan_deliveryReportTheDeliveriesLinkedToTheGoals = false;
            this.entity.workplan_deliveryReportTheNumberOfParticipants = false;
            this.entity.workplan_deliveryReportExpectedRenevue = false;
            this.entity.workplan_monitoringInformAccessibilityMeasures = false;
            this.entity.workplan_monitoringProvideTheProfileOfParticipants = false;
            this.entity.workplan_monitoringInformThePriorityAudience = false;
            this.entity.workplan_monitoringInformDeliveryType = false;
            this.entity.workplan_monitoringReportExecutedRevenue = false;
            this.entity.workplan_monitoringLimitNumberOfDeliveries = false;
            this.entity.workplan_monitoringMaximumNumberOfDeliveries = 0;
        }
    },
})