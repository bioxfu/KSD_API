library(shiny)
library(jsonlite)

shinyServer(function(input, output){
  passData <- eventReactive(input$apply, {
    protein_id <- input$protein_id
    gene_id <- sub('\\..+', '', protein_id)
    api_host <- 'http://10.41.9.210:8282'
    psite <- fromJSON(paste0(api_host, "/v1/psite/", protein_id))$results
    domain <- fromJSON(paste0(api_host, "/v1/domain/", protein_id))$results
    description <- fromJSON(paste0(api_host, "/v1/description/", protein_id))$results
    alias <- fromJSON(paste0(api_host, "/v1/alias/", gene_id))$results
    GO <- fromJSON(paste0(api_host, "/v1/GO/", gene_id))$results
    
    list(psite=psite, domain=domain, description=description, alias=alias, GO=GO)
  })
  
  output$psite <- renderTable({
    passData()$psite
  })
  output$domain <- renderTable({
    passData()$domain
  })
  output$description <- renderTable({
    passData()$description
  })
  output$alias <- renderTable({
    passData()$alias
  })
  output$GO <- renderTable({
    passData()$GO
  })
})


