app.component('entity-cards', {
    template: $TEMPLATES['entity-cards'],

    props: {
        classes: {
            type: [String, Array, Object],
            required: false
        },
        type: {
            type: String,
            default: '',
        },
    },

    setup({ slots }) {
        const hasSlot = name => !!slots[name];
        const text = Utils.getTexts('entity-cards')
        return { text, hasSlot }
    },

    data() {
        const cards = $MAPAS.config.homeMetabase.filter((c) => {
            return c.type == this.type
        });
        
        return {
            cards: cards,
        }
    },

    computed: { },

    methods: {
        lengthClass(text) {
            const textString = String(text);
            if (textString.length > 5) {
                return 'metabase-card__number--long';
            }
        },
    },
});
