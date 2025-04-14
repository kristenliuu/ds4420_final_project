library(shiny)
library(shinydashboard)
library(plotly)

conf_matrix <- matrix(c(
  5, 3, 2, 7, 1, 8, 29,
  6, 4, 5, 3, 1, 31, 7,
  1, 2, 3, 10, 37, 5, 5,
  6, 7, 6, 25, 1, 3, 9,
  4, 4, 7, 9, 2, 6, 8,
  0, 45, 0, 0, 1, 1, 2,
  38, 6, 1, 4, 8, 3, 4
), 
nrow = 7, byrow = TRUE)

rownames(conf_matrix) <- c("Trash", "Plastic", "Paper", "Metal", "Glass", "Compost", "Cardboard")
colnames(conf_matrix) <- c("Cardboard", "Compost", "Glass", "Metal", "Paper", "Plastic", "Trash")

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Climate ML Project"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About Project", tabName = "About", icon = icon("info-circle")),
      menuItem("CNN Results", tabName = "Results", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "About",
              h2("About This Project"),
              p("Climate change continues to be one of the most urgent challenges of our time, threatening ecosystems, public health, and the stability of global weather patterns. This project aims to address two environmental issues that contribute to climate change but operate at different scales: improper waste disposal and rising air pollution levels. Mis-sorting waste not only increases landfill sizes and contamination but also leads to greater greenhouse gas emissions. Similarly, poor air quality from industrial, vehicular, and environmental sources poses major public health risks and intensifies the greenhouse effect."),
              p("To explore solutions for these issues, we applied two distinct machine learning approaches. First, we built a Convolutional Neural Network (CNN) in R to classify waste images into seven categories: cardboard, compost, glass, metal, paper, plastic, and trash. The goal was to improve waste-sorting accuracy, which can help increase recycling efficiency and minimize contamination. Second, we developed Time Series models in Python to analyze and forecast PM2.5 air pollution levels in Portland, Oregon. Accurate air quality predictions can help guide public health decisions, identify at-risk populations, and support emission-reduction strategies."),
              p("For the waste classification model, we used a dataset sourced from Kaggle and implemented data preprocessing, regularization techniques, and data augmentation to improve model performance. Although our CNN showed strengths in classifying certain categories like trash and compost, it faced challenges distinguishing visually similar recyclable materials. Increasing dataset size, applying additional augmentations, and simplifying classification categories are potential future improvements."),
              p("In our air pollution analysis, we manually implemented AR and ARMA time series models to predict PM2.5 concentrations. While the ARMA model showed better overall accuracy than the basic AR model, both struggled with capturing short-term fluctuations caused by unpredictable events. These results highlight the potential of time series modeling for air quality forecasting, while suggesting that more advanced techniques like SARIMA may be better suited for handling the complex, non-monotonic patterns in environmental data."),
              p("Overall, this project demonstrates how machine learning can be used to address environmental challenges on both individual and community levels — from improving household waste sorting to forecasting air quality for public health planning.")
      ),
      
      tabItem(tabName = "Results",
              h2("CNN Confusion Matrix"),
              p("The interactive heatmap below displays our model's classification results across the seven waste categories."),
              
              plotlyOutput("confMatrixPlot", height = "600px")
      )
    )
  )
)

# server
server <- function(input, output) {
  
  output$confMatrixPlot <- renderPlotly({
    plot_ly(
      x = colnames(conf_matrix),
      y = rownames(conf_matrix),
      z = conf_matrix,
      type = "heatmap",
      colors = "Blues"
    ) %>%
      layout(
        xaxis = list(title = "Predicted Class"),
        yaxis = list(title = "Actual Class")
      )
  })
}

# run app
shinyApp(ui, server)
