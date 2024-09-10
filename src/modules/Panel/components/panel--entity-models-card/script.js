app.component('panel--entity-models-card', {
    template: $TEMPLATES['panel--entity-models-card'],
    emits: ['deleted'],

    props: {
        class: {
            type: [String, Array, Object],
            default: ''
        },
        entity: {
            type: Entity,
            required: true
        },

        onDeleteRemoveFromLists: {
            type: Boolean,
            default: true
        }
    },
    data() {
        fetch('/opportunity/findOpportunitiesModels')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            this.models = data;
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });

        return {
            models: [],
        }
    },

    computed: {
        classes() {
            return this.class;
        }, 
        leftButtons() {
            return 'delete';
        },
    }
})
