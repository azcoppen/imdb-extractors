library(e1071)
library(caret)
ledata = read.csv("imdb.csv")
set.seed(0375)
sample_size <- floor(0.80*nrow(ledata))
TrainInData <- sample(seq_len(nrow(ledata)), size = sample_size)
train <- ledata[TrainInData, ]
test <- ledata[-TrainInData, ]
TrainData <- train[,1:8]
TrainClass <- train[,9]
TestData <- test[,1:8]
TestClass <- test[,9]
bayes <- naiveBayes(TrainData, TrainClass)
prediction = table(predict(bayes, TestData), TestClass)
#sink("myoutput.txt", append = FALSE, split = FALSE)
summary(test)
cm6 <- confusionMatrix(prediction, positive = NULL, prevalence = NULL)
cm6
