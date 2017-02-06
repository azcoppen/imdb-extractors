library(Matrix)
library(arules)
GoT_data <- read.csv("imdb.csv", header = TRUE)
GoT_data <- GoT_data[,2:9]
gotrules <- apriori(GoT_data, parameter = list(supp = 0.001, conf = 0.1))
inspect(gotrules)
gotrules_sorted <- sort(gotrules, by = "lift")
inspect(gotrules_sorted)
subset.matrix <- is.subset(gotrules_sorted, gotrules_sorted)
subset.matrix[lower.tri(subset.matrix, diag = TRUE)] <- NA
red_gotrules <- colSums(subset.matrix, na.rm = TRUE) >= 1
pruned_gotrules <- gotrules_sorted[!red_gotrules]
inspect(pruned_gotrules)
