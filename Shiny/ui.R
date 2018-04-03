library(shiny)

shinyUI(pageWithSidebar(
  headerPanel('Kinase Substrates Database'),
  sidebarPanel(
    textInput(inputId = 'protein_id',
              label = 'Protein ID of Arabodopsis (TAIR10):',
              value = 'AT1G01050.1'),
    actionButton("apply", 'Apply')
  ),
  mainPanel(
    h3("Posphosites"),
    tableOutput('psite'),
    h3("Domain"),
    tableOutput('domain'),
    h3("Description"),
    tableOutput('description'),
    h3("Gene Alias"),
    tableOutput('alias'),
    h3("Gene Ontology"),
    tableOutput('GO')
  )
))
