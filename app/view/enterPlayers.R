box::use(
  shiny[NS, tagList, moduleServer, uiOutput, renderUI, reactive, tagAppendChild,
        observe, isolate],
  shinyMobile[f7Stepper, f7Text]
)

enterPlayersUI <- function(id) {
  ns <- NS(id)
  tagList(
    f7Stepper(inputId = ns("playerCount"),
              label = "Number of players",
              min = 5,max = 10,value = 5,
              step = 1),
    uiOutput(outputId = ns("playerNames"))
  )
}

enterPlayersServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      input_ids <- reactive(paste0("Player", 1:as.numeric(input$playerCount)))
      
      output$playerNames <- renderUI({
        player_name_inputs <- tagList()
        input_ids <- input_ids()
        names(input_ids) <- paste("Player", 1:as.numeric(input$playerCount))
        lapply(
          1:length(input_ids),
          function(i){
            newInputValue <- ""
            if (isolate(input_ids[i]) %in% names(isolate(input))) {
              newInputValue <- isolate(input[[input_ids[i]]])
            }
            player_name_inputs <<- tagAppendChild(
              player_name_inputs,
              f7Text(inputId = ns(input_ids[i]),
                     label = names(input_ids)[i],
                     value = newInputValue,
                     placeholder = paste0("Enter ", names(input_ids)[i],"'s ",
                                          "Name")))
          })
        player_name_inputs
      })
      
      reactive({sapply(input_ids(),function(x) ifelse(is.null(input[[x]]),"",input[[x]]))})
    })
}