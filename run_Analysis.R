## 1. Download, Unzip, & Merge Data
if(!file.exists("./R Assignments")){dir.create("./R Assignments")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./R Assignments/Dataset.zip")
unzip(zipfile = "./R Assignments/Dataset.zip", exdir = "./R Assignments")

# Reading trainings tables:
x_train <- read.table("./R Assignments/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./R Assignments/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./R Assignments/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./R Assignments/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./R Assignments/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./R Assignments/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./R Assignments/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./R Assignments/UCI HAR Dataset/activity_labels.txt')

# Changing column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

# Merging data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
datamerge <- rbind(mrg_train, mrg_test)

## 2. Extract Mean and SD for Each Measurement
colNames <- colnames(datamerge)
mean_sd <- (grepl("activityId" , colNames) | 
                        grepl("subjectId" , colNames) | 
                        grepl("mean.." , colNames) | 
                        grepl("std.." , colNames) 
)
mean_sd_T <- datamerge[ , mean_sd == TRUE]

## 3. Use Descriptive Activity Names
descMean_SD_T <- merge(mean_sd_T, activityLabels,
                              by='activityId',
                              all.x=TRUE)

## 4. Use Descriptive Label Names
names(descMean_SD_T) <- gsub("Acc", "Accelerator", names(descMean_SD_T))
names(descMean_SD_T) <- gsub("Mag", "Magnitude", names(descMean_SD_T))
names(descMean_SD_T) <- gsub("Gyro", "Gyroscope", names(descMean_SD_T))
names(descMean_SD_T) <- gsub("^t", "time", names(descMean_SD_T))
names(descMean_SD_T) <- gsub("^f", "frequency", names(descMean_SD_T))
names(descMean_SD_T) <- tolower(names(descMean_SD_T))

## 5. Create Tidy Data Set with Average of Each Variable by Activity and Subject
library(plyr)
tidydata = ddply(descMean_SD_T, c("subjectid","activitytype"), numcolwise(mean))
write.table(tidydata, file = "./R Assignments/tidydata.txt")