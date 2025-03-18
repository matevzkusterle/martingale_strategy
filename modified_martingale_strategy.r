#we quit after 2nd consecutive win

# Set seed for reproducibility
set.seed(123)

# Parameters
n_simulations <- 1000  # Number of simulations
initial_bet <- 5       # Starting bet (units)
table_limit <- 1000    # Max bet allowed
bankroll <- 1000       # Starting bankroll

# Initialize results
results <- data.frame(
  simulation = 1:n_simulations,
  final_bankroll = numeric(n_simulations),
  rounds_played = numeric(n_simulations),
  stopped_after_win = logical(n_simulations)
)

# Roulette probability parameters
p_win <- 18/37  # European roulette (red/black)
p_lose <- 1 - p_win

# Function to simulate one round
simulate_round <- function(bet, bankroll) {
  if (runif(1) < p_win) {
    return(list(gain = bet, new_bankroll = bankroll + bet, win = TRUE))
  } else {
    return(list(gain = -bet, new_bankroll = bankroll - bet, win = FALSE))
  }
}

# Main simulation loop
for (i in 1:n_simulations) {
  current_bankroll <- bankroll
  current_bet <- initial_bet
  rounds <- 0
  consecutive_wins <- 0
  stopped_after_win <- FALSE
  
  while (current_bankroll >= current_bet && !stopped_after_win) {
    rounds <- rounds + 1
    result <- simulate_round(current_bet, current_bankroll)
    current_bankroll <- result$new_bankroll
    
    if (result$win) {
      consecutive_wins <- consecutive_wins + 1
      if (consecutive_wins == 2) {
        stopped_after_win <- TRUE
      }
    } else {
      consecutive_wins <- 0  # Reset counter on loss
      current_bet <- current_bet * 2
      
      # Check table limit
      if (current_bet > table_limit) {
        break
      }
    }
  }
  
  # Store results
  results[i, ] <- list(
    simulation = i,
    final_bankroll = current_bankroll,
    rounds_played = rounds,
    stopped_after_win = stopped_after_win
  )
}

# Summary statistics
summary_stats <- data.frame(
  metric = c("Mean Final Bankroll", "Median Final Bankroll", "Mean Rounds Played"),
  value = c(
    mean(results$final_bankroll),
    median(results$final_bankroll),
    mean(results$rounds_played)
  )
)

# Probability of stopping after two wins
prob = sum(as.integer(results$stopped_after_win)) / length(results[,1])
prob

# Print results
print(summary_stats)
