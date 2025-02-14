suppressMessages({
  library(dplyr)
  library(ggplot2)
})

# Function to plot the yield curve for multiple dates
plot_yield_curve <- function(yields_df, date) {

  # Convert date column to Date type
  yields_df <- yields_df %>%
    mutate(Date = as.Date(.data$Date))

  # Get previous 1-month, 2-month, 3-month dates
  previous_dates <- as.character(as.Date(date) - c(30, 60, 90))
  selected_dates <- c(date, previous_dates)

  # Filter data for the selected dates
  yields_df <- yields_df %>%
    filter(.data$Date %in% selected_dates) %>%
    select(.data$Date, .data$Ticker, .data$Yield)

  # Define map for maturities
  ticker_mapping <- data.frame(
    Ticker = c("DGS1", "DGS2", "DGS3", "DGS5", "DGS7", "DGS10",
               "DGS20", "DGS30", "DGS1MO", "DGS3MO", "DGS6MO"),
    Years_Left = c(1, 2, 3, 5, 7, 10, 20, 30, 1 / 12, 0.25, 0.5)
  )

  # Merge with maturity years
  yields_df <- yields_df %>%
    left_join(ticker_mapping, by = "Ticker")

  # Define color mapping
  color_mapping <- c("darkblue", "steelblue3", "steelblue2", "lightblue")
  yields_df$Date <- factor(yields_df$Date, levels = rev(selected_dates))

  # Define grayscale color mapping
  color_mapping <- c("black", "gray60", "gray80", "gray100")
  yields_df$Date <- factor(yields_df$Date, levels = rev(selected_dates))

  # Plot
  plot <- ggplot(yields_df, aes(x = .data$Years_Left, y = .data$Yield, color = .data$Date)) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    scale_color_manual(values = color_mapping) +
    labs(
      title = "Yield Curve Over Time",
      x = "Years to Maturity",
      y = "Yield (%)",
      color = "Date"
    )

  return(plot)
}
