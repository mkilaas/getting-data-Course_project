##load the test data files for Getting and Cleaning Data Course Project
## Setting up work directory
setwd("C:/Users/Mustafa/Desktop/apps/R/coursera/UCI HAR Dataset")
## Load relevant txt files into R
features <- read.table("features.txt", header = FALSE);  
actlabels <- read.table("activity_labels.txt", header = FALSE);
subjtest <- read.table("subject_test.txt", header = FALSE); 
X_test <- read.table("X_test.txt", header = FALSE); 
Y_test <- read.table("Y_test.txt",header = FALSE); 
subjtrain <- read.table("subject_train.txt", header = FALSE); 
X_train <- read.table("X_train.txt", header = FALSE); 
Y_train <- read.table("Y_train.txt", header = FALSE); 

#### Assigning names to the data for the training dataset
colnames(actlabels) = c('activityId', 'activityType');
colnames(subjtrain) = "subjectId";
colnames(X_train) = features[,2];
colnames(Y_train) = "activityId";

#### Reading the following files for the test dataset


subjtest = read.table("subject_test.txt", header=FALSE);
X_test = read.table("X_test.txt", header=FALSE);
Y_test = read.table("y_test.txt", header=FALSE);


#### Assigning column names 


colnames(subjtest) = "subjectId";
colnames(X_test) = features[,2];
colnames(Y_test) = "activityId";

## 1. Merges the training and the test sets to create one data set.
training = cbind(subjtest, Y_test, X_test )
test = cbind(subjtrain,Y_train, X_train )
Finalset = rbind(training, test) ## #### Combining training and test dataset into one dataset

colNames = colnames(Finalset);
## 2) Extract only measurements of means and standard deviations 
aves <- grep("mean", features$V2) ## Identifies measurements of means 
standard_dev <- grep("std", features$V2) ## Identifies measurements of standard deviataions
newset <- Finalset[,c(aves, standard_dev)] ## subset that Final data set on just the variables that are measurements of means and standard deviataions
##3-4) Use descriptive activity names - This generates a new variable that uses the activity labels
attach(newset)
newset$Activity_Name[activityId == 1] <- "Walking"
newset$Activity_Name[activityId == 2] <- "Walking Upstairs"
newset$Activity_Name[activityId == 3] <- "Walking Downstairs"
newset$Activity_Name[activityId == 4] <- "Sitting"
newset$Activity_Name[activityId == 5] <- "Standing"
newset$Activity_Name[activityId == 6] <- "Laying"
detach(newset)
##5) Creates a tidy data set
# rehape the data to get a row for each mean/std measure for each subject/activity
reshaped <- melt(newset, id = c("subjectId", "activityId", "Activity_Name"))
# get the averages for each subject of each variable for each activityId
tidy <- dcast(reshaped, subjectId + activityId + Activity_Name ~variable, fun.aggregate = mean)
#save the table
write.table(tidy, file = "tidy.txt", sep = "\t")
## END
