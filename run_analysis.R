# Name: Mercera A Silva
# Course: Getting and Cleaning Data Course Project
# Date: July 27, 2020

# Set working directory
setwd("C:/Users/silva333/Documents/R")

# Install and load required packages
install.packages("dplyr")
library(dplyr)

# Download and unzip files from archives
zipURL("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
zipFile("UCI HAR Dataset.zip")

if(!file.exists(download.file)) {
  download.file(zipURL, zipFile, mode="wb")
}

dataPath <- "UCI HAR Dataset"
if(!file.exists(dataPath)) {
  unzip(zipFile)
}

# Read test and training data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# Read features and activity labels
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activities) <-c("activityId", "activityLabel")

# Merge training and test sets into data set
test <- cbind(subject_test, x_test, x_test)
train <- cbind(subject_train, y_train, y_train)
Merged_Data <- rbind(test, train)

# Filter column names and take only mean and standard deviation for each measurement
column.names<-colnames(Merged_Data)
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
Merged_Data.filtered <- Merged_Data[, column.names.filtered] 

# Add descriptive activity names for each activity referenced in data set
Merged_Data.filtered$activitylabel <- factor(Merged_Data.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Create tidy dataset with mean values for each subject and activity
features.colnames=grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
Merged_Data.melt<-melt(Merged_Data.filtered, id= c('activitylabel', 'subject'), measure.vars = features.colnames)
TidyData <- dcast(Merged_Data.melt, activitylabel + subject ~ variable, mean)

# Create tidy data set file
write.table(TidyData, file="TidyData.txt", row.names=FALSE)