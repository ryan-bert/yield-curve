suppressMessages({
  library(DBI)
  library(RPostgres)
  library(jsonlite)
  library(dplyr)
})

# Load postgress credentials
current_dir <- dirname(sys.frame(1)$ofile)
credentials_path <- file.path("~/Documents/Credentials/Raspberry Pi/financial-database.json")
credentials <- fromJSON(credentials_path)

# Connect to the database
conn <- dbConnect(
  Postgres(),
  dbname = credentials$dbname,
  host = credentials$host,
  port = as.integer(credentials$port),
  user = credentials$user,
  password = credentials$password
)

# Load the data from the database
bonds_df <- dbGetQuery(conn, "SELECT * FROM bonds")

# Load yield curve function
source(file.path(current_dir, "functions/plot_yield_curve.R"))

# Plot the yield curve
plot <- plot_yield_curve(bonds_df, "2004-11-21")

# Load animated yield curve function
source(file.path(current_dir, "functions/plot_animated_curve.R"))

# Define the start and end date for animation
start_date <- "2024-01-01"
end_date <- "2025-01-01"

# Generate the animation
animated_plot <- plot_yield_curve_animated(bonds_df, start_date, end_date)

# Save the animation with gifski
anim_save(file.path(current_dir, "../plots/yield_curve_animation.gif"),
  animation = animated_plot,
  renderer = gifski_renderer(),
  fps = 10, width = 800, height = 600
)