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

        return {
            registration: this.registration,
            duracaoProjeto: '',
            workplan_goals: this.registration.workplan_goals,
            meses: [
              "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
              "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro",
            ],
          };
    },
    methods: {
        generateUUIDv4() {
          return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = (Math.random() * 16) | 0;
            const v = c === 'x' ? r : (r & 0x3) | 0x8;
            return v.toString(16);
          });
        },
        async adicionarMeta() {          
          this.registration.workplan_goals.push({
            id: this.generateUUIDv4(),
            mesInicial: '',
            mesFinal: '',
            titulo: '',
            descricao: '',
            etapaFazerCultural: '',
            acaoOrcamentaria: '',
            valor: '',
          });
        },
        async removerMeta(index) {
          this.registration.workplan_goals.splice(index, 1);
          await this.save_();
        },
        async save_() {
          const registration = this.registration;
          registration.workplan_goals = this.workplan_goals;
          return registration.save(300, true);
        }
      },
})