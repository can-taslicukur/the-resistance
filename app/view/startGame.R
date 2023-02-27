box::use(
  shiny[NS, tagList, moduleServer, observeEvent],
  shinyMobile[f7Button, f7Dialog]
)

startGameUI <- function(id) {
  ns <- NS(id)
  tagList(
    f7Button(inputId = ns("startGame"), label = "Start the game", color = "red")
  )
}

startGameServer <- function(id, players, gameState) {
  moduleServer(
    id,
    function(input, output, session) {
      observeEvent(input$startGame, {
        if (any(players()=="")) {
          f7Dialog(
            title = "Enter all of the player names",
            text = "Some player names are empty, please fill all of the player names to start the game.",
            type = "alert"
          )
        } else if (length(unique(players())) < length(players())) {
          f7Dialog(
            title = "All players should have unique names",
            text = "You dont want to confuse each other in the game.",
            type = "alert"
          )
        } else {
          gameState("affiliationsReady")
        }
      })
    }
  )
}