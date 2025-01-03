# Load the necessary ggplot2 library for data visualization
library(ggplot2)

# Read in the sample data from a CSV file
sample_data <- read.csv("/Users/sikandertauseef/Desktop/Projects/Team-Research-and-Development/Fat_Supply_Quantity_Data.csv")

# Create a histogram visualization for Obesity Rates
ggplot(sample_data, aes(x = Obesity)) + 
  # Add a histogram layer with a bin width of 2, blue fill, and 70% transparency
  geom_histogram(binwidth = 2, fill = "blue", alpha = 0.7) + 
  # Add a normal distribution curve with mean and standard deviation of Obesity Rates
  stat_function(fun = dnorm, 
                args = list(mean = mean(sample_data$Obesity), sd = sd(sample_data$Obesity)), 
                color = "red", linewidth = 1) + 
  # Add title, x-axis label, and y-axis label to the plot
  labs(title = "Distribution of Obesity Rates in Sample Countries",
       x = "Obesity Rate (%)",
       y = "Frequency") + 
  # Use a minimal theme for the plot
  theme_minimal()

# Save the plot as a PNG file
ggsave("/Users/obstechlaravel/Desktop/sikandertauseef/Team-Research-and-Development/obesity_plot.png", plot = last_plot())

# Open a connection to a text file to write analysis results
fileConn <- file("analysis_results.txt")

# Write analysis results to the text file
writeLines(c(
  "Analysis Results:",
  "",
  paste("Mean Obesity Rate:", mean(sample_data$Obesity)),
  paste("Standard Deviation of Obesity Rate:", sd(sample_data$Obesity)),
  paste("Total Number of Countries Analyzed:", nrow(sample_data))
), fileConn)

# Close the connection to the text file
close(fileConn)

# Open a connection to a text file to write ANOVA results in append mode
anovaFileConn <- file("anova_results.txt", open = "a")

predictor_variables <- c("Animal.Products", "Animal.fats", "Cereals.Excluding.Beer", "Eggs", "Fish.Seafood", "Fruits.Excluding.Wine", "Milk.Excluding.Butter", "Vegetal.Products", "Vegetable.Oils", "Vegetables")

# Open a connection to a text file to write ANOVA results in append mode
anovaFileConn <- file("anova_results.txt", open = "a")

for (variable in predictor_variables) {
  anova_result <- aov(Obesity ~ sample_data[, variable], data = sample_data)
  writeLines(c(
    paste("ANOVA table for", variable),
    "",
    capture.output(summary(anova_result))
  ), anovaFileConn)
}
# Close the connection to the text file
close(anovaFileConn)