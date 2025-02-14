suppressMessages({
  library(dplyr)
  library(ggplot2)
  library(gganimate)
})

# Function to plot the animated yield curve (only current date's curve is shown)
plot_yield_curve_animated <- function(yields_df, start_date, end_date) {

  # Convert date column to Date type
  yields_df <- yields_df %>%
    mutate(Date = as.Date(Date)) %>%
    filter(Date >= as.Date(start_date) & Date <= as.Date(end_date))

  # Define map for maturities
  ticker_mapping <- data.frame(
    Ticker = c("DGS1", "DGS2", "DGS3", "DGS5", "DGS7", "DGS10",
               "DGS20", "DGS30", "DGS1MO", "DGS3MO", "DGS6MO"),
    Years_Left = c(1, 2, 3, 5, 7, 10, 20, 30, 1 / 12, 0.25, 0.5)
  )

  # Merge with maturity years
  yields_df <- yields_df %>%
    left_join(ticker_mapping, by = "Ticker")

  # Plot with animation
  plot <- ggplot(yields_df, aes(x = Years_Left, y = Yield)) +
    geom_line(size = 1.5) +
    geom_point(size = 3) +
    scale_color_viridis_d() +
    labs(
      title = "Yield Curve Over Time ({closest_state})",
      x = "Years to Maturity",
      y = "Yield (%)"
    ) +
    theme_minimal() +
    transition_states(Date, transition_length = 2, state_length = 1) +
    ease_aes("linear")

  return(plot)
}