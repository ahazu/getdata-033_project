## run_analysis.R does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Loads required libraries
library(dplyr)
library(data.table)

## Downloads dataset if not available in the current folder
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
    dateDownloaded <- date()

    unzip("getdata-projectfiles-UCI HAR Dataset.zip")
    
    setwd("UCI HAR Dataset/")
}

## Sets data directories
#datadir <- setwd("UCI HAR Dataset/")
#testdata <- setwd("UCI HAR Dataset/test")
#traindata <- setwd("UCI HAR Dataset/train")

### Reads features

## Reads List of all features
features <- data.table(read.table("features.txt", sep = "", header = FALSE))

## Reads activity labels
activity_labels <- data.table(read.table("activity_labels.txt", sep = "", header = FALSE))

## Reads training set
training_set <- data.table(read.table("train/X_train.txt", sep = "", header = FALSE))

## Read training labels
training_labels <- data.table(read.table("train/y_train.txt", sep ="", header = FALSE))
colnames(training_labels) <- c("Labels")

## Read test set
test_set <- data.table(read.table("test/X_test.txt", sep = "", header = FALSE))

## Read test labels
test_labels <- data.table(read.table("test/y_test.txt", sep = "", header = FALSE))
colnames(test_labels) <- c("Labels")

## Joins tables training_labels and training_set
training_set <- data.frame(Label=training_labels, training_set)

## Joins tables test_labels and test_set
test_set <- data.frame(Label=test_labels, test_set)

##  Merges training_set and test_set
merged_set <- rbind(training_set, test_set)
