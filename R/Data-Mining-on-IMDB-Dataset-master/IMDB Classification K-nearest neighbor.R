library(class)
library(caret)
ledata = read.csv("imdb.csv")
sample_size <- floor(0.80*nrow(ledata))
TrainInData <- sample(seq_len(nrow(ledata)), size = sample_size)
train <- ledata[TrainInData, ]
test <- ledata[-TrainInData, ]
TrainData <- train[,1:8]
TrainClass <- train[,9]
TestData <- test[,1:8]
TestClass <- test[,9]
set.seed(0375)
knearestn <- knn(train = TrainData, test = TestData, cl = TrainClass, k = 5)
prediction <- table(knearestn, TestClass)
cm7 <- confusionMatrix(prediction, positive = NULL, prevalence = NULL)
cm7
summary(test)
plot.default(knearestn)