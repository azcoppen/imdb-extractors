library(arules)

cat("importing data\n")
ususalSuspects <- read.csv("usualsuspects.csv", na.strings=c(" ", ""))
ususalSuspects = na.omit(ususalSuspects)

cat("\n")
cat("mining all rules where Support = 0.0002 and Confidence = 0.0\n")
rules <- apriori(ususalSuspects, parameter = list(support = 0.0002, confidence = 0.0))

cat("\n")
cat("sorting by lift\n")
rules.sorted = sort(rules, by="lift")

rules.subset <- subset(rules.sorted, (rhs %in% paste0("Actor=", unique(ususalSuspects$Actor))))

print(inspect(head(rules.subset,n=50)))