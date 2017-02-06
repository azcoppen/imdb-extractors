library(RWeka)
library(caret)
library(partykit)
ledata = read.csv("imdb.csv")
set.seed(0375)
sample_size <- floor(0.80*nrow(ledata))
TrainInData <- sample(seq_len(nrow(ledata)), size = sample_size)
train <- ledata[TrainInData, ]
test <- ledata[-TrainInData, ]
TrainData <- train[,1:9]
TestData <- test[,1:8]
TestClass <- test[,9]
cfourfive <- J48(genre~., data = TrainData)
prediction = table(predict(cfourfive, TestData), TestClass)
cm5 <- confusionMatrix(prediction, positive = NULL, prevalence = NULL)
cm5
summary(test)
#plot(cfourfive)