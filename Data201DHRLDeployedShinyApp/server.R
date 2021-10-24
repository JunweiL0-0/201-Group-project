# Libraries
library(shiny)
library(ggplot2)
library(tidyverse)
library(readr)
library(glue)


# Dataframe path
vertial_df_location <- "crime_income_vertical.csv"
income_df_location <- "average_income_df_long.csv"

# Load Dataframe
final_df = read_csv(vertial_df_location, show_col_types=FALSE)
income_df = read_csv(income_df_location, show_col_types=FALSE)

# function used to summarise dataframes
summary_dataframe <- function(dataFrame, location, detail){
  # Process dataFrame
  tmp_df <- dataFrame[dataFrame$Detail==detail,]
  tmp_df <- tmp_df[tmp_df$Location==location,]
  # Summary display
  summary <- summary(tmp_df)
  return(summary)
}

# Function used to generate a plot
generate_plot_by_detail <- function(dataFrame, location, detail) {
  # Process dataFrame
  tmp_df <- dataFrame[dataFrame$Detail==detail,]
  tmp_df <- tmp_df[tmp_df$Location==location,]
  # Mapping
  tmp_mapped <- tmp_df %>%
    ggplot(mapping =
             aes(x = Year, # X axis
                 y = Value)) # Y axis
  # Labels
  tmp_labeled <- tmp_mapped +
    ggtitle(glue("{detail} ({location})")) + # Set title
    xlab("Year") + # Change x axis lable
    ylab("Value") + # Change y axis lable
    labs(caption = "Crime dataframe and average income dataframe") # Add caption
  # Plotting
  f_plot <- tmp_labeled +
    geom_line(color = "purple") # Plot
  return(f_plot)
}


# Function used to generate a plot
generate_income_plot_by_location <- function(dataFrame, location) {
  # Process dataFrame
  tmp_df <- dataFrame[dataFrame$Location==location,]
  # Mapping
  tmp_mapped <- tmp_df %>%
    ggplot(mapping =
             aes(x = Year, # X axis
                 y = Average_Income_from_All_Sources_collected)) # Y axis
  # Labels
  tmp_labeled <- tmp_mapped +
    ggtitle(glue("Average Income ({location})")) + # Set title
    xlab("Year") + # Change x axis lable
    ylab("Average Income") + # Change y axis lable
    labs(caption = "Average income dataframe") # Add caption
  # Plotting
  f_plot <- tmp_labeled +
    geom_line(color = "blue") # Plot
  return(f_plot)
}

# Define a server for the Shiny app
server = function(input, output) {
  # Fill in the spot we created for a plot
  # Location income plot
  output$locationIncomePlot <- renderPlot({
    # Render a lineplot
    generate_income_plot_by_location(income_df, input$location) # Generate the income plot for different locations
  })

  # Average income and crime plot
  output$detailPlot <- renderPlot({
    # Render a lineplot
    generate_plot_by_detail(final_df, input$location, input$detailType) # Generate income and crime plot for different locations
  })

  # Data summary information
  output$summary <- renderPrint({
    if (!input$summary) return(cat("The data summary information is hidden."))
    summary_dataframe(final_df, input$location, input$detailType)
  })
}
