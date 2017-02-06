library(oblique.tree)
library(caret)
ledata = read.csv("imdb.csv")
set.seed(0375)
sample_size <- floor(0.80*nrow(ledata))
TrainInData <- sample(seq_len(nrow(ledata)), size = sample_size)
train <- ledata[TrainInData, ]
test <- ledata[-TrainInData, ]
TrainData <- train[,1:9]
TestData <- test[,1:8]
TestClass <- test[,9]
ob.tree <- oblique.tree(formula = genre~., data = TrainData, oblique.splits = "only")
plot(ob.tree);text(ob.tree);title(main = "Oblique Tree")
prediction <- table(predict(ob.tree, newdata = test, type = c("class"), update.oblique.tree = FALSE), TestClass)
cm10 <- confusionMatrix(prediction, positive = NULL, prevalence = NULL)
cm10
summary(test)