## run_analysis.R does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Loads required libraries
library(plyr)
library(dplyr)
library(data.table)

## Downloads dataset if not available in the current folder
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "getdata-projectfiles-UCI HAR Dataset.zip")
    dateDownloaded <- date()

    unzip("getdata-projectfiles-UCI HAR Dataset.zip")
    
    setwd("UCI HAR Dataset/")
}


### Reads files

## Reads List of all features
features <- data.table(read.table("features.txt", sep = "", header = FALSE))

## Reads activity labels
activity_labels <- data.table(read.table("activity_labels.txt", sep = "", header = FALSE))

## Reads training set
training_set <- data.table(read.table("train/X_train.txt", sep = "", header = FALSE))
## Sets colnames from features
colnames(training_set) <- as.character(features$V2)

## Read training labels
training_labels <- data.table(read.table("train/y_train.txt", sep ="", header = FALSE))
colnames(training_labels) <- c("Activity")

## Read Subject train IDs
subject_train <- data.table(read.table("train/subject_train.txt", header = FALSE))
colnames(subject_train) <- c("Subject ID")

## Read test set
test_set <- data.table(read.table("test/X_test.txt", sep = "", header = FALSE))
## Sets colnames from features
colnames(test_set) <- as.character(features$V2)

## Read test labels
test_labels <- data.table(read.table("test/y_test.txt", sep = "", header = FALSE))
colnames(test_labels) <- c("Activity")

## Read subject test IDs
subject_test <- data.table(read.table("test/subject_test.txt", header = FALSE))
colnames(subject_test) <- c("Subject ID")


### Merges data

## Joins tables training_labels and training_set
training_set <- data.frame(Activity=training_labels, training_set)

## Joins tables test_labels and test_set
test_set <- data.frame(Activity=test_labels, test_set)

##  Connects training_set and test_set
merged_set <- rbind(training_set, test_set)

## Connects subject_train and subject_test
subject_ids <- rbind(subject_train, subject_test)

## Joins subject IDs with merged set
merged_set <- data.frame(SubjectID=subject_ids, merged_set)

### Isolates data so only std() and mean() measurements are listed
std_and_mean_names <- grep("std()|mean()", names(merged_set))

pruned_set <- select(merged_set, Subject.ID, Activity, std_and_mean_names)

### Changes to descriptive activity names
pruned_set$Activity <- mapvalues(pruned_set$Activity, from = c(1,2,3,4,5,6), to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))


### Creates new tidy dataset with with the average of each variable for each activity and each subject.
subject_grouped <- group_by(pruned_set, Subject.ID, Activity)

summarise(subject_grouped, tBodyAcc.mean...X = mean(tBodyAcc.mean...X))
subjects_mean <- summarise_each(subject_grouped, funs(mean), -Subject.ID, -Activity)

### Writes pruned_set to tidy_data.txt
write.table(subjects_mean, file="../tidy_data.txt", row.names = FALSE)
