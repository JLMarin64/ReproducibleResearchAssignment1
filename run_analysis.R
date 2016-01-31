> setwd("C:/Users/Marin/Desktop/Coursera/Cleaning Data/Data")
> # File URL to download
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
 
 # Local data file
 dataFileZIP <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
 dirFile <- "./UCI HAR Dataset"
 #Directory and filename (txt or csv) of the clean/tidy data:
     tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"
 # tidyDataFileAVG <- "./tidy-UCI-HAR-dataset-AVG.csv"
 # Directory and filename (.txt) of the clean/tidy data
 tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"
 # Download the dataset (. ZIP), which does not exist
 if (file.exists(dataFileZIP) == FALSE) {
     download.file(fileURL, destfile = dataFileZIP)
 }

 # Uncompress data file
 if (file.exists(dirFile) == FALSE) {
     unzip(dataFileZIP)
 }
 ## 1. Merges the training and the test sets to create one data set:
 x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
 X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
 y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
 y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
 subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
 subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
 # Combines data table (train vs test) by rows
 x <- rbind(x_train, X_test)
 y <- rbind(y_train, y_test)
 s <- rbind(subject_train, subject_test)
 ## 2. Extracts only the measurements on the mean and standard deviation for each measurement:
 # Read features labels
 features <- read.table("./UCI HAR Dataset/features.txt")
 # Friendly names to features column
 names(features) <- c('feat_id', 'feat_name')
 # Search for matches to argument mean or standard deviation (sd)  within each element of character vector
 index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
 x <- x[, index_features] 
 # Replaces all matches of a string features 
 names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))
 ## 3. Uses descriptive activity names to name the activities in the data set:
 ## 4. Appropriately labels the data set with descriptive activity names:
 # Read activity labels
 activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
 # Friendly names to activities column
 names(activities) <- c('act_id', 'act_name')
 y[, 1] = activities[y[, 1], 2]
 
 names(y) <- "Activity"
 names(s) <- "Subject"
 
 # Combines data table by columns
 tidyDataSet <- cbind(s, y, x)
 # 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject:
 p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
 tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)
 
 # Activity and Subject name of columns 
 names(tidyDataAVGSet)[1] <- "Subject"
 names(tidyDataAVGSet)[2] <- "Activity"# Created csv (tidy data set) in diretory
 # Created csv (tidy data set) in diretory
 write.table(tidyDataSet, tidyDataFile)
 # Created csv (tidy data set AVG) in diretory
 # write.csv(tidyDataAVGSet, tidyDataFileAVG)
 # Created txt (tidy data set AVG) in diretory
 write.table(tidyDataAVGSet, tidyDataFileAVGtxt)