# getdata-033_project

This is my submission for the Getting and Cleaning Data course at Coursera

The run_analysis.R file does the following:

Download s the UCI HAR dataset [1] from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip unless already present in the current directory, unzips and moves into the directory with the data.

The script imports the following files into data frames:
 - features.txt
 - activity_labels.txt
 - train/X_train.txt
 - train/y_train.txt
 - train/subject_train.txt
 - test/X_test.txt
 - test/y_test.txt
 - test/subject_test.txt

The script merges the data so that training and test sets are included, and merges the Subject IDs and activity codes with the complete data set. The data set is pruned so that only measurements on std() and mean() are included.

The script exchanges the activity codes with the descriptive names.

A new tidy dataset is created containing the averages for each activity and each subject. This dataset is written to file  (tidy_data.txt).

A codebook (codebook.txt) can be found in the repository.

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
