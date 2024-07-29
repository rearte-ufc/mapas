app.component("panel--seal-relations-tabs", {
	template: $TEMPLATES["panel--seal-relations-tabs"],
	emits: [],

	setup(props, { slots }) {
		const hasSlot = (name) => !!slots[name];
		return { hasSlot };
	},

	created() {},

	data() {
		console.log(this.entity.seals);
	},

	computed: {},

	props: {
		entity: {
			type: Entity,
			required: true,
		},
	},

	methods: {},
});
