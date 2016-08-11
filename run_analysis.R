setwd("C:/Users/Italo/Documents/RWork/Coursera")

####################################################################
# (1) Merges the training and the test sets to create one data set #
####################################################################

# download and unzip datafile 
if(!file.exists("./dt_cl_project")) dir.create("./dt_cl_project")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./dt_cl_project/projectData_getCleanData.zip")
unzip("./dt_cl_project/projectData_getCleanData.zip", exdir = "./dt_cl_project")

# loads datafiles
X_train <- read.table("./dt_cl_project/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./dt_cl_project/UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./dt_cl_project/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./dt_cl_project/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./dt_cl_project/UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./dt_cl_project/UCI HAR Dataset/test/subject_test.txt")

# merges train, test and subject data
x_merge <- rbind(X_train, X_test)
y_merge <- rbind(y_train, y_test)
subject_merge <- rbind(subject_train, subject_test)

##############################################################################################
# (2) Extracts only the measurements on the mean and standard deviation for each measurement # 
##############################################################################################

# loads feature datafile
features <- read.table("./dt_cl_project/UCI HAR Dataset/features.txt")

# mean and sd extraction
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])
x_merge <- x_merge[, mean_std]
names(x_merge) <- features[mean_std, 2]

##############################################################################
# (3) Uses descriptive activity names to name the activities in the data set #
##############################################################################

# loads activity datafile
activity_labels <- read.table("./dt_cl_project/UCI HAR Dataset/activity_labels.txt")

# label activity names
y_merge[, 1] <- activity_labels[y_merge[, 1], 2]
names(y_merge) <- "activity"

#########################################################################
# (4) Appropriately labels the data set with descriptive variable names #
#########################################################################

# label subject names
names(subject_merge) <- "subject"

# merges all prior datafiles
xysubject <- cbind(x_merge, y_merge, subject_merge)

#####################################################################################################################################################
# (5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject #
#####################################################################################################################################################

# Writes summarized datafile
library(dplyr)
avgdata <- xysubject %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))
write.table(avgdata, "./dt_cl_project/avgdata.txt", row.name=FALSE ) 
