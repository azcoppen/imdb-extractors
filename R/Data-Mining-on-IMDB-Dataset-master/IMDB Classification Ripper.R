library(RWeka)
library(caret)
ledata = read.csv("imdb.csv")
set.seed(0375)
smp_size <- floor(0.80*nrow(ledata))
TrainInData <- sample(seq_len(nrow(ledata)), size = smp_size)
train <- ledata[TrainInData, ]
test <- ledata[-TrainInData, ]
TrainData <- train[,1:8]
TrainClass <- train[,9]
TestData <- test[,1:8]
TestClass <- test[,9]
jripperle <- train(TrainData, TrainClass, method = "JRip")
prediction = table(predict(jripperle, TestData), TestClass)
summary(test)
cm7 <- confusionMatrix(prediction, positive = NULL, prevalence = NULL)
cm7
plot(jripperle)