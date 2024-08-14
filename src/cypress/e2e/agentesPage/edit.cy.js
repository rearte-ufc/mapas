const { loginWith } = require("../../commands/login");

//Todos os comenártios devem ser descomentados e remover a linha de comando abaixo dele para o teste rodar no mapas.tec.br ao invés do localhost

let nome = gerarNomeAleatorio();
let genero = "";
let arrobaDoInstagram = "";

describe("Agents Page Edit", () => {
    let expectedCount;
    beforeEach(() => {
        cy.viewport(1920, 1080);
        //cy.visit("/edicao-de-agente/1/");
        cy.visit("http://localhost/edicao-de-agente/1/");
        // loginWith("Admin@local", "mapas123");
        cy.contains("Fazer login com este usuário").click();
    });

    it("Garante que a página de edição de agentes funciona", () => {
        cy.url().should("include", "edicao-de-agente");

        cy.get("h2").contains("Edição do agente individual").should("be.visible");

        cy.contains("Informações de Apresentação");
        cy.contains("Dados Pessoais");
        cy.contains("Dados sensíveis");
        cy.contains("Redes sociais");
        cy.contains("Anexos");
        cy.contains("Salvar");
        cy.contains("Sair");
    });

    
    it("Garante que o accoridon 'Informações de Apresentação' abre corretamente", () => {
        cy.contains("Informações de Apresentação").click();
        cy.contains("Nome de perfil");
        cy.get(".field.entity-terms__edit-agent > input").should("have.value", "Admin@local");
    });

    
    it("Garante que o accoridon 'Dados Pessoais' abre corretamente e testa criar um novo nome social e salvar", () => {
        cy.contains("Dados Pessoais").click();
        cy.contains("Dados de pessoa física");
        cy.get("section > div > div:nth-child(1) > div:nth-child(3) > input[type=text]").clear().type(nome);
        cy.contains("Salvar").click();
        cy.contains("Modificações salvas");
    });


    it("Garante que estão salvando os dados coretamente depois da página ser recarregada.", () => {
        cy.contains("Dados Pessoais").click();
        cy.get("section > div > div:nth-child(1) > div:nth-child(3) > input[type=text]").should("have.value", nome);
        cy.contains("Sair").click();
        cy.contains(nome);
    });

    it("Garante que o accordion Dados sensíveis estão funcionando corretamente.", () => {
        cy.contains("Dados sensíveis").click();

        cy.get("mc-container:nth-child(4) > section > div > div > div:nth-child(3) > div > div > div > div > input[type=text]").click();
        cy.contains("Dom");
        cy.contains("Escolaridade");

        cy.get("mc-container:nth-child(4) > section > div > div > div:nth-child(4) > select").invoke('val').then((valorAtual) => {
            genero = (valorAtual === "Homem Cis") ? "Mulher Cis" : "Homem Cis";

            cy.get("mc-container:nth-child(4) > section > div > div > div:nth-child(4) > select").select(genero);
        });
        cy.contains("Salvar").click();
        cy.contains("Modificações salvas");
    });

    it("Garante que o accordions 'Redes sociais' funcionam corretamente", () => {
        cy.contains("Redes sociais").click();
        cy.contains("Instagram");

        cy.get("mc-container:nth-child(5) > section > div > div > div:nth-child(2) > input[type=socialMedia]").invoke('val').then((valorAtual) => {
            arrobaDoInstagram = (valorAtual === "instagram") ? "bwheitor" : "instagram";

            cy.get("mc-container:nth-child(5) > section > div > div > div:nth-child(2) > input[type=socialMedia]").clear().type(arrobaDoInstagram);
        });
        cy.contains("Salvar").click();
        cy.contains("Modificações salvas");
    });

    it("Garante que o accordions 'Anexos' funcionam corretamente", () => {
        cy.contains("Anexos").click();
        cy.contains("Arquivos para download");
    });

    it("Garante que as informações de genero e de redes sociais estão sendo salvas corretamente", () => {
        cy.contains("Sair").click();
        
        cy.contains(genero);
        cy.contains(arrobaDoInstagram);
        cy.contains(nome);
    });
});

function gerarNomeAleatorio(tamanho = 6) {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    let nome = '';
    
    for (let i = 0; i < tamanho; i++) {
        const indice = Math.floor(Math.random() * caracteres.length);
        nome += caracteres[indice];
    }
    
    return nome.charAt(0).toUpperCase() + nome.slice(1);
}