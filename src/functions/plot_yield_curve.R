suppressMessages({
  library(dplyr)
  library(ggplot2)
})

# Function to plot the yield curve for a given date
plot_yield_curve <- function(yields_df, date) {

  # Filter the data
  yields_df <- yields_df %>%
    filter(Date == date) %>%
    select(-Date)

  # Define map for maturities
  ticker_mapping <- data.frame(
    Ticker = c(
      "DGS1", "DGS2", "DGS3", "DGS5", "DGS7", "DGS10",
      "DGS20", "DGS30", "DGS1MO", "DGS3MO", "DGS6MO"
    ),
    Years_Left = c(1, 2, 3, 5, 7, 10, 20, 30, 1 / 12, 0.25, 0.5)
  )

  # Merge the data
  yields_df <- yields_df %>%
    left_join(ticker_mapping, by = "Ticker")

  # Plot the data
  plot <- ggplot(yields_df, aes(x = Years_Left, y = Yield)) +
    geom_line() +
    geom_point() +
    labs(
      title = "Yield Curve",
      x = "Years to Maturity",
      y = "Yield (%)"
    )

  return(plot)
}