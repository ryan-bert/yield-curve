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
print(plot)