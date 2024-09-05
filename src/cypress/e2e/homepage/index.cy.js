describe("Homepage", () => {
    beforeEach(() => {
        cy.visit("https://experimente.mapas.tec.br/");
    });

    it("Garante que a home page funciona", () => {
        cy.contains("label", "Boas vindas ao Mapa Cultural");
    });
});