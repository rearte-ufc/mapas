const { clearAllFilters } = require("../../commands/clearAllFilters");
const { checkFilterCount } = require("../../commands/checkFilterCount");
const { loginWith } = require("../../commands/login");

describe("Opportunity Page", () => {
    beforeEach(() => {
        cy.viewport(1920, 1080);
    });

    it("Garante que a oportunidades funciona", () => {
        cy.visit("/");
        cy.contains("Boas vindas ao Mapa Cultural");

        cy.contains("a", "Oportunidades").click();
        cy.url().should("include", "oportunidades");

        cy.get("h1").contains("Oportunidades");

        cy.contains("Mais recentes primeiro");
        cy.contains("Oportunidades encontradas");
        cy.contains("Filtros de oportunidades");
        cy.contains("Status das oportunidades");
        cy.contains("Tipo de oportunidade");
        cy.contains("Área de interesse");
    });

    it("Garante que os filtros de oportunidades funcionam quando não existem resultados pra busca textual", () => {
        cy.visit("/oportunidades");

        cy.get(".search-filter__actions--form-input").type("Edital 03/18");

        cy.wait(1000);

        cy.contains("Nenhuma entidade encontrada");
    });

    it("Garante que os filtros de oportunidades funcionam quando existem resultados para a busca textual", () => {
        cy.visit("/oportunidades");

        cy.get(".search-filter__actions--form-input").type("UFPR");

        cy.wait(1000);

        checkFilterCount("opportunity");
    });

    it("Garante que os filtros por status das oportunidades funcionam", () => {
        cy.visit("/oportunidades");

        cy.wait(1000);

        cy.contains("Status das oportunidades");

        cy.get(".form > :nth-child(1) > :nth-child(2)").click();

        cy.wait(1000);

        checkFilterCount("opportunity");

        cy.get('.form > :nth-child(1) > :nth-child(4)').click();

        cy.wait(1000);

        checkFilterCount("opportunity");
    });

    it("Garante que o filtro de oportunidades de editais oficiais funciona", () => {
        cy.visit("/oportunidades");

        cy.wait(1000);

        cy.contains("Status das oportunidades");

        cy.get(".verified > input").click();
        cy.wait(2500);

        checkFilterCount("opportunity");
    });

    it("Garante que os filtros por tipo de oportunidade funcionam", () => {
        cy.visit("/oportunidades");

        cy.wait(1000);

        cy.contains("Tipo de oportunidade");

        cy.get(":nth-child(2) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input").click();
        cy.get(':nth-child(29) > .mc-multiselect__option').click();

        cy.wait(1000);

        checkFilterCount("opportunity");

        cy.reload();

        cy.wait(1000);

        cy.get(':nth-child(2) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input').click();
        cy.get(':nth-child(12) > .mc-multiselect__option').click();

        cy.wait(1000);

        checkFilterCount("opportunity");
    });

    it("Garante que os filtros por área de interesse funcionam", () => {
        cy.visit("/oportunidades");

        cy.wait(1000);

        cy.contains("Área de interesse");

        cy.get(":nth-child(3) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input").click();
        cy.get(':nth-child(5) > .mc-multiselect__option').click();

        cy.wait(1000);

        checkFilterCount("opportunity");

        cy.reload();
        cy.wait(1000);

        cy.get(":nth-child(3) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input").click();
        cy.get(':nth-child(41) > .mc-multiselect__option').click();

        cy.wait(1000);

        checkFilterCount("opportunity");
    });

    it("Garante que o botão limpar filtros na pagina de oportunidades funciona", () => {
        cy.visit("/oportunidades");

        cy.wait(1000);

        checkFilterCount("opportunity");
        
        clearAllFilters([
            ".form > :nth-child(1) > :nth-child(2)",
            ".verified > input",
            ":nth-child(2) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input",
            ":nth-child(1) > .mc-multiselect__option",
            ":nth-child(3) > .mc-multiselect > :nth-child(1) > .v-popper > .mc-multiselect--input",
            ":nth-child(2) > .mc-multiselect__option"
        ]);

        checkFilterCount("opportunity");

        cy.wait(1000);
    });

    it("Garante duplicação da oportunidade", () => {
        cy.visit("/autenticacao/");
        loginWith("Admin@local", "mapas123");

        cy.wait(5000)

        cy.get('[style="width: 304px; height: 78px;"] > div > iframe').click();
        cy.get('.right > .button--primary').click();
        
        cy.wait(1000);

        cy.get('.rowBtn > :nth-child(6)').click();

        cy.contains("Duplicar modelo");
        cy.contains("Todas as configurações atuais da oportunidade, incluindo o vínculo com a entidade associada e os campos de formulário criados, serão duplicadas.");
    
        cy.get('.modal__action > .button--primary').click();
        cy.wait(3000);

        cy.visit("/minhas-oportunidades/#draft");
  
        cy.get('.panel-entity-card__header > .left > .panel-entity-card__header--info > .panel-entity-card__header--info-link > .mc-title').contains("[Cópia]");  
    });

    it("Garante preenchimento obrigatório na geração de modelo baseado em uma oportunidade", () => {
        cy.visit("/autenticacao/");
        loginWith("Admin@local", "mapas123");
        cy.get(':nth-child(4) > :nth-child(1) > a').click();
        cy.get('.right > .button--primary').click();
        
        cy.wait(1000);

        cy.get('.col-12 > .button').click();

        cy.get('.modal__content > :nth-child(3) > :nth-child(1) > input').should('be.visible').clear();

        cy.get(':nth-child(3) > textarea').should('be.visible').clear();

        cy.get('.modal__action > .button--primary').click();

        cy.contains('Todos os campos são obrigatorio');
    });

    it("Garante geração de modelo baseado em uma oportunidade", () => {
        cy.visit("/autenticacao/");
        loginWith("Admin@local", "mapas123");
        cy.get(':nth-child(4) > :nth-child(1) > a').click();
        cy.get('.right > .button--primary').click();
        
        cy.wait(1000);

        cy.get('.col-12 > .button').click();

        cy.contains("Salvar modelo");
        cy.contains("Para salvar um modelo, preencha os campos abaixo.");
        cy.contains("Nome do modelo");
        cy.contains("Breve descrição do modelo");
        cy.contains("Salvar modelo");

        cy.get('.modal__content > :nth-child(3) > :nth-child(1) > input').should('be.visible').clear().type('Nome do modelo');

        cy.get(':nth-child(3) > textarea').should('be.visible').type('Descrição do modelo');

        cy.get('.modal__action > .button--primary').click();
        cy.wait(3000);

        cy.visit("/minhas-oportunidades/#mymodels");
        cy.wait(1000);
        cy.contains("Nome do modelo");
    });
});
