import { backHomepage } from "../../commands/backHomepage";

describe("Homepage", () => {
    beforeEach(() => {
        cy.viewport(1920, 1080);
        cy.visit("/");
    });

    it("Garante o funcionamento do home", () => {
        backHomepage();
    });

    it("Acessa \"Ver todos\" de Oportunidades", () => {
        cy.get(":nth-child(1) > .card__right > .button").click();
        cy.url().should("include", "/oportunidades/");
        backHomepage();
    });

    it("Acessa \"Ver todos\" de Eventos", () => {
        cy.get(":nth-child(2) > .card__right > .button").click();
        cy.url().should("include", "/eventos/");
        backHomepage();
    });

    it("Acessa \"Ver todos\" de Espaços", () => {
        cy.get(":nth-child(3) > .card__right > .button").click();
        cy.url().should("include", "/espacos/");
        backHomepage();
    });

    it("Acessa \"Ver todos\" de Agentes", () => {
        cy.get(":nth-child(4) > .card__right > .button").click();
        cy.url().should("include", "/agentes/");
        backHomepage();
    });

    it("Acessa \"Ver todos\" de Projetos", () => {
        cy.get(":nth-child(5) > .card__right > .button").click();
        cy.url().should("include", "/projetos/");
        backHomepage();
    });

    it("Navegação entre os cards da seção \"Em destaque\"", () => {
        cy.get(".carousel__next").click();
        cy.wait(1000);
        cy.get(".carousel__prev").click();
    });

    it("Acessa o navbar e o botão \"Acessar\" dos cards da seção \"Em destaque\"", () => {
        cy.get('.all > a > span').click();
        cy.wait(1000);
        cy.get('.carousel__slide--active > .entity-card > .entity-card__footer > .entity-card__footer--action > .button').click();

        backHomepage();

        cy.get(".agents > a > span").click();
        cy.wait(1000);
        cy.get('[style="width: 31.25%; order: 0;"] > .entity-card > .entity-card__footer > .entity-card__footer--action > .button').click();
        cy.url().should("include", "/agente/");

        backHomepage();
        
        cy.get(".spaces > a > span").click();
        cy.wait(1000);
        cy.get('[style="width: 31.25%; order: 0;"] > .entity-card > .entity-card__footer > .entity-card__footer--action > .button').click();
        cy.url().should("include", "/espaco/");

        backHomepage();

        cy.get(".projects > a > span").click();
        cy.wait(1000);
        cy.get('[style="width: 31.25%; order: 1;"] > .entity-card > .entity-card__footer > .entity-card__footer--action > .button').click();
        cy.url().should("include", "/projeto/");

        backHomepage();
    });

    it("Acessa o botão \"Fazer Cadastro\" da quarta seção", () => {
        cy.get(".home-register__content--button").click();
        cy.url().should("include", "autenticacao/register/");

        // A página de registro não existe ainda

        // cy.contains("Novo cadastro");
        // backHomepage();
        
        // Solução temporária
        cy.visit('/');
    });

    it("Acessa o botões de zoom do mapa", () => {
        cy.get(".leaflet-control-zoom-in").click();
        cy.wait(2000);
        cy.get(".leaflet-control-zoom-out").click();
    });

    it("Acessa o botão \"Conheça o repositório\" da seção \"Alô desenvolvedores\"", () => {
        cy.get(".home-developers__content--link > .link").click();
        cy.url().should("include", "https://github.com/mapasculturais");
        cy.visit("/");
    });
});
