box::use(
  shiny[moduleServer, NS, tags, reactiveVal, observe, icon, verbatimTextOutput, 
        renderPrint, reactive],
  shinyMobile[
    f7Page, f7TabLayout, f7Navbar, f7Toolbar, f7Tabs, f7Tab, updateF7Tabs, f7Link, 
    f7Stepper]
)

box::use(
  app/view/enterPlayers,
  app/view/startGame,
  app/view/affiliationsReady,
  app/view/affiliations,
  app/view/roundsReady,
  app/view/leadersChoice,
  app/logic/calculate_round_team_size
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
            tags$p("Enter players to start the game."),
            tags$h2("Game Options:"),
            f7Stepper(inputId = ns("factionRevealDuration"),
                      label = "Faction Reveal Duration",min = 0,max = 15,value = 5,
                      fill = FALSE)
          ),
          tags$main(
            tags$br(),
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
          roundsReady$roundsReadyUI(ns("roundsReady")),
          verbatimTextOutput(ns("currentPlayers")),
          verbatimTextOutput(ns("currentFactions")),
          verbatimTextOutput(ns("currentLeader")),
          title = "Rounds Prepare",
          tabName = "roundsReady",hidden = TRUE
        ),
        f7Tab(
          title = "Leader Chooses The Team",
          leadersChoice$leadersChoiceUI(ns("leadersChoice")),
          tabName = "leadersChoice",hidden = TRUE
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
    affiliations$affiliationsServer("affiliations", players, player_factions, gameState, 
                                    input$factionRevealDuration)
    round_sizes <- reactive(calculate_round_team_size$calculate_round_team_size(length(players())))
    roundsReady$roundsReadyServer("roundsReady", players, round_sizes, gameState)
    round <- reactiveVal(value = 1, label = "round")
    spy_win_count <- reactiveVal(value = 0, label = "spy_win_count")
    leadersChoice$leadersChoiceServer("leadersChoice", players, round_sizes, round, spy_win_count, gameState)
  })
}