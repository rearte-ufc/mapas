function checkFilterCount() {
        cy.get('.foundResults').then(($foundResults) => {
                const countPerPage = 20;
                let resultsTextArray = $foundResults.text().split(" ");
                let resultsCount = Number(resultsTextArray[0]);
                let resultsType = resultsTextArray[1];
                const resultsCountPerPage = resultsCount < countPerPage ? resultsCount : countPerPage;

                switch (element) {
                        case "opportunity":
                                cy.get("span.upper." + element + "__color").should("have.length", resultsCountPerPage);
                                cy.wait(1000);
                                cy.contains(resultsCount + " Oportunidades encontradas");
                                
                                break;
                        
                        case "project":
                                cy.get("span.upper." + element + "__color").should("have.length", resultsCountPerPage);
                                cy.wait(1000);
                                cy.contains(resultsCount + " Projetos encontrados");
        
                                break;
                        
                        case "space":
                                cy.get("span.upper." + element + "__color").should("have.length", resultsCountPerPage);
                                cy.wait(1000);
                                cy.contains(resultsCount + " Espaços encontrados");
                
                                break;

                        default:
                                cy.log("checkFilterCount(): tipo inválido");
                                cy.contains("FORCE ERROR");
                                
                                break;
                }
        });
}

module.exports = { checkFilterCountOf };