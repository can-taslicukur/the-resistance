#' @export
assign_factions <- function(players) {
  number_of_players <- length(players)
  if (number_of_players <= 6) {
    number_of_spies <- 2
  } else if (number_of_players <= 9) {
    number_of_spies <- 3
  } else {
    number_of_spies <- 4
  }
  spy_players <- sample(x = players,size = number_of_spies,replace = FALSE)
  players[which(players %in% spy_players)] <- "Spies"
  players[which(players != "Spies")] <- "Resistance"
  players
}