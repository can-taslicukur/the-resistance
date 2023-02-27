box::use(
  shiny[NS, tagList, tags, moduleServer, observeEvent, reactive, textOutput, renderText],
  shinyMobile[f7Button]
)

box::use(
  app/logic/assign_factions
)

affiliationsReadyUI <- function(id) {
  ns <- NS(id)
  tagList(
      tags$h1("Factions Reveal Stage"),
      tags$p("Players will learn their factions in this stage. Pass the phone to the given player and dont say and look at each other's factions."),
      tags$p("Number of Spies: ", tags$span(textOutput(outputId = ns("numberOfSpies"),inline = TRUE), style = "color:red")),
      tags$p("Number of Resistance: ", tags$span(textOutput(outputId = ns("numberOfResistance"), inline = TRUE), style = "color:gold")),
      f7Button(inputId = ns("readyToReveal"),label = "Ready",color = "green")
  )
}

affiliationsReadyServer <- function(id, players, gameState) {
  moduleServer(
    id,
    function(input, output, session) {
      player_factions <- reactive({
        assign_factions$assign_factions(players())
        })
      
      output$numberOfSpies <- renderText({
        length(player_factions()[player_factions()=="Spies"])
      })
      output$numberOfResistance <- renderText({
        length(player_factions()[player_factions()=="Resistance"])
      })
      observeEvent(input$readyToReveal, gameState("affiliations"))
      
      player_factions
    }
  )
}