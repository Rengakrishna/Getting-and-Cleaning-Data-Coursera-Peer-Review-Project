library(dplyr)



# Downloading the dataset
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/projectdataset.zip")

# Unzip the dataset
unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")



#1. Reading datasets

# 1.1 Reading training datasets
x_train <- read.table("./getcleandata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getcleandata/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getcleandata/UCI HAR Dataset/train/subject_train.txt")

# 1.2 Reading test datasets
x_test <- read.table("./getcleandata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getcleandata/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getcleandata/UCI HAR Dataset/test/subject_test.txt")

# 1.3 Reading feature vector
features <- read.table("./getcleandata/UCI HAR Dataset/features.txt")

# 1.4 Reading activity labels
activityLabels = read.table("./getcleandata/UCI HAR Dataset/activity_labels.txt")

# 1.5 Assigning variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

# 1.6 Merging all datasets into one dataset
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

# 2. Extracting  the measurements on the mean and sd 

# 2.1 Reading column names
colNames <- colnames(finaldataset)

# 2.2 Create vector for defining ID, mean, and sd
MeanStd <- (grepl("activityID", colNames) |
                   grepl("subjectID", colNames) |
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

# 2.3 Making required subset
MeanandStd <- finaldataset[ , MeanStd == TRUE]

# 3. Use descriptive activity names
ActivityNames <- merge(MeanandStd, activityLabels,
                              by = "activityID",
                              all.x = TRUE)
# Appropriately labels the data set with descriptive variable names. 
# completed in above steps 1.5,2.1 & 2.2

# 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#  Making tidy dataset
tidyData <- ActivityNames %>% group_by(subjectID,activityID) %>%  summarise_all(mean)  

tidyData <- tidyData[order(tidyData$subjectID, tidyData$activityID), ]

write.table(tidyData, "tidyData.txt", row.names = FALSE)
