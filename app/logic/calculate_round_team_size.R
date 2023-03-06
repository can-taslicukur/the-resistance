#' @export
calculate_round_team_size <- function(number_of_players) {
  if (number_of_players >= 5 & number_of_players <= 10) {
    switch(number_of_players-4,
           c(2,3,2,3,3),
           c(2,3,4,3,4),
           c(2,3,3,4,4),
           c(3,4,4,5,5),
           c(3,4,4,5,5),
           c(3,4,4,5,5)
    )
  } else {
    stop("Invalid number of players")
  }
}
