box::use(
  shiny[NS, tagList, moduleServer, tags, textOutput, renderText, reactive, isolate,
        observeEvent],
  shinyMobile[f7Button]
)

box::use(
  app/logic/calculate_round_team_size
)

roundsReadyUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$h1("Get Ready for Missions Stage"),
    tags$p("Make sure everyone knows what their faction is."),
    tags$h2("Team Sizes"),
    tags$ul(
      tags$li("1st Round:", tags$strong(textOutput(ns("firstRoundSize"),inline = TRUE))),
      tags$li("2nd Round:", tags$strong(textOutput(ns("secondRoundSize"),inline = TRUE))),
      tags$li("3rd Round:", tags$strong(textOutput(ns("thirdRoundSize"),inline = TRUE))),
      tags$li("4th Round:", tags$strong(textOutput(ns("fourthRoundSize"),inline = TRUE))),
      tags$li("5th Round:", tags$strong(textOutput(ns("fifthRoundSize"),inline = TRUE)))
    ),
    f7Button(ns("startRounds"),label = "Ready",color = "green")
    
  )
}

roundsReadyServer <- function(id, players, gameState) {
  moduleServer(
    id,
    function(input, output, session) {
      
      round_sizes <- reactive({
        if (gameState() == "roundsReady") {
          number_of_players <- length(players())
          if (number_of_players >= 5 & number_of_players <= 10) {
            print(calculate_round_team_size$calculate_round_team_size(number_of_players))
            calculate_round_team_size$calculate_round_team_size(number_of_players)
          }
        }
      })
      
      output$firstRoundSize <- renderText(round_sizes()[1])
      output$secondRoundSize <- renderText(round_sizes()[2])
      output$thirdRoundSize <- renderText(round_sizes()[3])
      output$fourthRoundSize <- renderText(round_sizes()[4])
      output$fifthRoundSize <- renderText(round_sizes()[5])
      
      observeEvent(input$startRounds,gameState("leadersChoice"))
      
      round_sizes
    }
  )
}