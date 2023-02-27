box::use(
  shiny[
    NS, tagList, tags, moduleServer, textOutput, renderText, invalidateLater, reactive,
    reactiveVal, observe, observeEvent, uiOutput, renderUI, req, HTML
  ],
  shinyMobile[f7Button, f7Popup]
)

affiliationsUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$h5("Pass the phone to:",align = "center"),
    tags$h1(tags$span(textOutput(outputId = ns("player"))), align = "center"),
    uiOutput(outputId = ns("revealFaction"))
  )
}

affiliationsServer <- function(id, players, player_factions, gameState, reveal_duration) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      number_of_players <- reactive(length(players()))
      current_player <- reactiveVal(1) #index of the current player, initial to 1st player
      current_player_name <- reactive(players()[current_player()]) #name of the current player
      output$player <- renderText(current_player_name())
      
      #variable to hold target time initially empty.
      timerReference <- reactiveVal()
      #Only set it when user gets to the affiliations page or player changes
      observe({
        if (gameState()=="affiliations" | current_player()>1) {
          timerReference(Sys.time() + reveal_duration)
        }
      })
      output$revealFaction <- renderUI({
        req(timerReference())
        #Start the countdown
        timeLeft <- round(difftime(timerReference(), Sys.time(), units = "secs"))
        if (timeLeft>=0 & timeLeft <= reveal_duration) {
          invalidateLater(1000, session)
          tags$h4(timeLeft, align = "center")
        } else { #When countdown is over, render a button to reveal faction
          f7Button(inputId = ns("revealFactionButton"),label = "Reveal Faction", color = "orange")
        }
      })
      
      observeEvent(input$revealFactionButton,{ #when the button is pressed, display a popup with the faction info
        player_faction <- player_factions()[current_player()]
        if (player_faction == "Spies") {
          other_spies <- players()[which(player_factions() == "Spies" & players()!=players()[current_player()])]
          popup_text <- tagList(
            tags$h1("You are a", tags$span("Spy!", style = "color:red")),
            tags$p("Sabotage missions and stay hidden to win the game!."),
            tags$h2("Other spies are:"),
            HTML(paste("<strong>",other_spies,"</strong>",collapse = "<br>"))
          )
        } else if (player_faction == "Resistance") {
          popup_text <- tagList(
            tags$h1("You are the", tags$span("Resistance!", style = "color:gold")),
            tags$p("Support missions and reveal spies to win the game!.")
          )
        }
        f7Popup(id = "revealFactionPopup",
                title = player_faction,
                popup_text)
      })
      
      observeEvent(input$revealFactionPopup,{
        if (current_player() < number_of_players() & !input$revealFactionPopup) {
          current_player(current_player() + 1)
        } else if (current_player() == number_of_players() & !input$revealFactionPopup) {
          gameState("roundsReady")
        }
      })
    }
  )
}