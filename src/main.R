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
plot_yield_curve(bonds_df, "2008-11-21")
ggsave(
  file.path(current_dir, "../plots/yield_curve.png"),
  width = 8, height = 6
)

# Load animated yield curve function
source(file.path(current_dir, "functions/plot_animated_curve.R"))

# Generate the animation
animated_plot <- plot_yield_curve_animated(bonds_df, "2024-01-01", "2024-12-31")

# Save the animation with gifski
anim_save(file.path(current_dir, "../plots/yield_curve_animation.gif"),
  animation = animated_plot,
  renderer = gifski_renderer(),
  fps = 10, width = 800, height = 600
)