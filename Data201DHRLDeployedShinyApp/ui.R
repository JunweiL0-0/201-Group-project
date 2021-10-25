# Libraries
library(shiny)
library(ggplot2)
library(tidyverse)

locations = c("Auckland District", "Waikato District", "Bay Of Plenty District", "Eastern District", "Central District", "Tasman District",
              "Canterbury District", "Southern District", "Wellington District", "Northland District")

detail_types = c("Homicide and related offences", "Acts intended to cause injury", "Sexual assault and related offences",
                 "Dangerous or negligent acts endangering persons", "Abduction, harassment and other related offences against a person",
                 "Robbery, extortion and related offences", "Unlawful entry with intent/burglary, break and enter", "Theft and related offences",
                 "Fraud, deception and related offences", "Illicit drug offences", "Prohibited and regulated weapons and explosives offences",
                 "Property damage and environmental pollution", "Public order offences", "Offences against justice procedures, government security and government operations",
                 "Miscellaneous offences")

# Use a fluid Bootstrap layout
ui = fluidPage(
  # Give the page a title
  titlePanel("Crime And Income"),
  # Generate a row with a sidebar
  sidebarLayout(
    # Define the sidebar with one input
    sidebarPanel(
      # Get Location
      selectInput("location", "Locations:",
                  choices=locations),
      # Get Detail
      selectInput("detailType", "Detail:",
                  choices = detail_types,
                  multiple = FALSE),
      # Show summary
      checkboxInput("summary", "Show summary", TRUE)
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("locationIncomePlot"),
      plotOutput("detailPlot"),

      verbatimTextOutput("summary")
    )
  )
)
