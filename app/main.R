box::use(
  shiny[moduleServer, NS, tags, reactiveVal, observe, icon, verbatimTextOutput, renderPrint],
  shinyMobile[
    f7Page, f7TabLayout, f7Navbar, f7Toolbar, f7Tabs, f7Tab, updateF7Tabs, f7Link
  ]
)

box::use(
  app/view/enterPlayers,
  app/view/startGame,
  app/view/affiliationsReady,
  app/view/affiliations
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  f7Page(
    f7TabLayout(
      navbar = f7Navbar(title = "The Resistance"),
      #main content
      f7Tabs(
        id = ns("gameStates"),
        f7Tab(
          tags$header(
            tags$h1("Welcome to The Resistance", align = "center"),
            tags$p("Enter players to start the game.")
          ),
          tags$main(
            enterPlayers$enterPlayersUI(ns("enterPlayers")),
            startGame$startGameUI(ns("startGame"))
          ),
          title = "Start",
          tabName = "start",hidden = TRUE
        ),
        f7Tab(
          affiliationsReady$affiliationsReadyUI(ns("affiliationsReady")),
          title = "Factions Reveal",
          tabName = "affiliationsReady",hidden = TRUE
        ),
        f7Tab(
          affiliations$affiliationsUI(ns("affiliations")),
          title = "Faction",
          tabName = "affiliations",hidden = TRUE
        ),
        f7Tab(
          verbatimTextOutput(outputId = ns("CurrentPlayers")),
          verbatimTextOutput(outputId = ns("CurrentFactions")),
          title = "Rounds Prepare",
          tabName = "roundsReady",hidden = TRUE
        )
      )
    ),
    title = "The Resistance",
    options = list(
      theme = "auto",
      dark = TRUE
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    gameState <- reactiveVal(value = "start",label = "gameState")
    observe(updateF7Tabs(session, id = "gameStates", selected = gameState()))
    players <- enterPlayers$enterPlayersServer("enterPlayers")
    startGame$startGameServer("startGame", players, gameState)
    player_factions <- affiliationsReady$affiliationsReadyServer("affiliationsReady", players, gameState)
    affiliations$affiliationsServer("affiliations", players, player_factions, gameState, 3)
    output$CurrentPlayers <- renderPrint(players())
    output$CurrentFactions <- renderPrint(player_factions())
  })
}
