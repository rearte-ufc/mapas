app.component('opportunity-create-model', {
    template: $TEMPLATES['opportunity-create-model'],
    setup() {
        const messages = useMessages();
        const text = Utils.getTexts('opportunity-create-model')
        return { text, messages }
    },
    props: {
        entity: {
            type: Entity,
            required: true,
        },
    },

    data() {
        let sendSuccess = false;
        let formData = {
            name: this.entity.name,
            description: '',
        }

        return { sendSuccess, formData }
    },

    methods: {
        async save() {
            const api = new API(this.entity.__objectType);

            let objt = this.formData;
            objt.entityId = this.entity.id;
            

            let error = null;

            if (error = this.validade(objt)) {
                let mess = "";
                mess = this.text('Todos os campos são obrigatorio');
                this.messages.error(mess);
                return;
            }

            console.log(this.entity.id);
        },
        validade(objt) {
            let result = null;
            let ignore = [];

            Object.keys(objt).forEach(function (item) {
                if (!objt[item] && !ignore.includes(item)) {
                    result = item;
                    return;
                }
            });
            return result;
        },
    },
});
