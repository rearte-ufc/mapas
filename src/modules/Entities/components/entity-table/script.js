app.component('entity-table', {
    template: $TEMPLATES['entity-table'],
    emits: ['clear-filters', 'remove-filter'],

    setup(props, { slots }) {
        const hasSlot = name => !!slots[name]
        const messages = useMessages();
        const text = Utils.getTexts('entity-table')
        return { messages, text, hasSlot};
    },

    props: {
        type: {
            type: String,
            required: true
        },
        controller: {
            type: String
        },
        select: String,
        limit: {
            type: Number,
            default: 50
        },
        order: {
            type: String,
            default: 'createTimestamp ASC'
        },
        query: {
            type: Object || String,
            default: {}
        },
        watchDebounce: {
            type: Number,
            default: 1500
        },
        headers: {
            type: Array,
            required: true
        },
        required: {
            type: [String, Array],
            default: ''
        },
        visible: {
            type: [String, Array],
            default: ''
        },
        endpoint: {
            type: String,
            default: 'find'
        },
        showIndex: {
            type: Boolean,
            default: false
        },
        sortOptions: {
            type: Array,
            default: [
                { order: 'createTimestamp DESC', label: __('mais recentes primeiro', 'entity-table') },
                { order: 'createTimestamp ASC',  label: __('mais antidas primeiro', 'entity-table') },
                { order: 'updateTimestamp DESC', label: __('modificadas recentemente', 'entity-table') },
                { order: 'updateTimestamp ASC',  label: __('modificadas há mais tempo', 'entity-table') },
            ]
        },
    },

    created() {
        const visible = this.visible instanceof Array ? this.visible : this.visible.split(",");
        const required = this.required instanceof Array ? this.required : this.required.split(",");

        this.originalQuery = JSON.parse(JSON.stringify(this.query));

        for(let header of this.columns) {
            header.slug = this.parseSlug(header);
            header.visible = visible.includes(header.slug) || required.includes(header.slug);
            header.required = required.includes(header.slug);
        }
    },

    mounted() {
        const searchInput = this.$refs.search;
        searchInput.addEventListener("input", OnInput, false);
        function OnInput() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + "px";
        }
    },

    data() {
        return {
            apiController: this.controller || this.type,
            entitiesOrder: this.order,
            columns: this.headers,
            searchText: '',
        }
    },

    computed: {
        visibleColumns() {
            return this.columns.filter((col) => col.visible);
        },
        $description() {
            return $DESCRIPTIONS[this.type];
        },
        advancedFilters() {
            let filters = {};

            for (let visibleColumn of this.visibleColumns) {
                const description = this.$description[visibleColumn.slug];

                if (description && description.hasOwnProperty('options')) {
                    if (visibleColumn.slug !== 'status' && Object.keys(description.options).length > 0) {
                        filters[visibleColumn.slug] = {
                            label: description.label,
                            options: description.options, 
                        }
                    }
                }
            }
            
            return filters;
        },

        appliedFilters() {
            const query = JSON.parse(JSON.stringify(this.query));
            
            delete query['@limit'];
            delete query['@opportunity'];
            delete query['@order'];
            delete query['@select'];
            delete query['@page'];

            let result = [];
            for (let key of Object.keys(query)) {
                if (this.getFilterLabels(key, query[key])) {
                    result = result.concat(this.getFilterLabels(key, query[key]));
                } 
            }
            return result;
        },
    },

    methods: {
        getFilterLabels(prop, value) {
            // Exemplo: 
            //      key = status  value = EQ(1)

            if (prop == '@keyword') {
                return [{prop, value, label: __('palavras-chave', 'entity-table')}]
            }
            
            let values = this.getFilterValues(value);
            if (values) {
                if (prop == 'status') {
                    let statusDict = {
                        '0': __('rascunhos', 'entity-table'),
                        '1': __('publicadas', 'entity-table'),
                        '-10': __('lixeira', 'entity-table'),
                        '-1': __('arquivadas', 'entity-table'),
                    }

                    if(this.type == 'registration') {
                        statusDict = {
                            '0': __('rascunhos', 'entity-table'),
                            '1': __('pendentes', 'entity-table'),
                            '2': __('invalidas', 'entity-table'),
                            '3': __('nao selecionadas', 'entity-table'),
                            '8': __('suplentes', 'entity-table'),
                            '10': __('selecionadas', 'entity-table'),
                        }
                    }

                    return values.map((value) => { 
                        return {prop, value, label: statusDict[value]} 
                    });
                }

                const fieldDescription = this.$description[prop];
                if (fieldDescription.field_type == 'select') {
                    return values.map((value) => { 
                        return {prop, value, label: fieldDescription.options[value]}
                    });
                } else {
                    return values.map((value) => { 
                        return {prop, value, label: value.replace(/(\\)/g, '')}
                    });
                }
            } else {
                return null;
            }
        },

        getFilterValues(value) {
            // Exemplos: 
            //      EQ(10), EQ(preto), IN(8, 10), IN(preto, pardo)                
            let values = /(EQ|IN|GT|GTE|LT|LTE)\(([^\)]+,?)+\)/.exec(value); 

            if (values) {
                const operator = values[1];
                const _values = values[2];
                
                if (_values) {
                    if(operator == 'IN') {
                        values = _values.replace(/([^\\]),/g, '$1%break%');
                    } else {
                        values = _values;
                    }
                    
                    return values.split('%break%').filter(value => value.trim());
                } else {
                    return null;
                }
            }
            return null;
        },

        parseSlug(header) {
            if (header.slug) {
                return header.slug;
            }
            return header.value;
        },

        getEntityData(obj, value) {
            let val = eval(`obj.${value}`);

            if(val instanceof McDate) {
                val = val.date('numeric year');
            }

            return val;
        },

        // keyword(entities) {
        //     window.dispatchEvent(new CustomEvent('entityTableSearchText', { detail: {searchText: this.searchText} }));
        //     this.query['@keyword'] = this.searchText;
        //     entities.refresh(this.watchDebounce);
        // },

        resetHeaders() {
            const visible = this.visible instanceof Array ? this.visible : this.visible.split(",");
            const required = this.required instanceof Array ? this.required : this.required.split(",");
            
            for (let header of this.columns) {
                if(visible.includes(header.slug) || required.includes(header.slug)) {
                    header.visible = true;
                } else {
                    header.visible = false;
                }
            }
        },

        toggleHeaders(event) {
            const field = event.target.value;
            let column = null;

            for (let header of this.columns) {
                if (header.slug == field) {
                    column = header;
                    if (header.required) {
                        event.preventDefault();
                        event.stopPropagation();
                        this.messages.error(this.text('item obrigatório') + ' ' + header.text);
                    } else {
                        header.visible = !header.visible;
                    }
                }
            }

            if (column && !column.visible) {
                delete this.query[field];
            }
        },

        showAllHeaders() {
            if (!this.$refs.allHeaders.checked) {
                this.resetHeaders();
            } else {
                for (let header of this.columns) {
                    header.visible = true;
                }
            }
        },

        clearFilters(entities) {            
            for (let prop in this.query) {
                if (this.originalQuery[prop]) {
                    this.query[prop] = this.originalQuery[prop];
                } else {
                    delete this.query[prop];
                }
            }

            this.$emit('clear-filters', entities);
        },

        removeFilter(filter, entities) {
            const _values = /(EQ|IN|GT|GTE|LT|LTE)\(([^\)]+,?)+\)/.exec(this.query[filter.prop]);

            if (filter.prop == '@keyword') {
                delete this.query[filter.prop];
                this.searchText = '';
            } else {
                if (_values) {
                    let operator = _values[1];
                    let values = _values[2];

                    if (operator == 'IN') {
                        values = values.replace(/([^\\]),/g, '$1%break%');
                        values = values.split('%break%').filter(value => value.trim());

                        if (values.length > 1) {
                            for (let index of Object.keys(values)) {
                                if (values[index] == filter.value) {
                                    values.splice(index, 1);
                                }
                            }
                            
                            this.query[filter.prop] = `${operator}(${values.toString()})`;
                        } else {
                            delete this.query[filter.prop];
                        }
                    } else {
                        delete this.query[filter.prop];
                    }
                }
            }

            entities.refresh();
            this.$emit('remove-filter', filter);
        },

        toggleAdvancedFilter(fieldName, option) {
            const currentValues = this.getFilterValues(this.query[fieldName] ?? '') || [];

            if (currentValues.includes(option)) {
                currentValues.splice(currentValues.indexOf(option), 1);    
            } else {
                currentValues.push(option);
            }
            
            if (currentValues.length > 0) {
                this.query[fieldName] = `IN(${currentValues.toString()})`;
            } else {
                delete this.query[fieldName];
            }
        },

        advancedFilterChecked(fieldName, option) { 
            const currentValues = this.getFilterValues(this.query[fieldName] ?? '') || [];

            return currentValues.includes(option);
        },
    },
});