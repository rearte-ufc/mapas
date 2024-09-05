describe("Projeto", () => {
    it("Garante que o projeto seja clicável", () => {
        cy.visit("https://experimente.mapas.tec.br/projetos");
        cy.get(".search-filter__actions--form-input").type("Teste Garante que o projeto seja clicável cypress");
        cy.wait(1000);
        cy.get('.entity-card__footer--action > .button').click();
        cy.wait(1000);
        cy.contains('p', 'Teste Garante que o projeto seja clicável cypress');
    });
});