# R script to perform the following
# read in and unzip the wearable activity datasets from a given URL
# merge the two datasets train and test 
# filters the measurements to only include mean and standard deviation calculations
# apply descriptive labels to the activities in the dasta
# saves the data into a file called "tidyData.csv"


# load required packages
packages <- c("dplyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

inpath <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
outpath <- "wearable.zip"

# download and unzip	
	if(!file.exists(dirname(outpath)))
		dir.create(dirname(outpath))
	if(!file.exists(outpath))
		download.file(inpath, destfile = outpath)

	dataPath <- "UCI HAR Dataset"
	unzip(zipfile = outpath)

# load the train data
	trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
	trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
	trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))


# load the test data
	testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
	testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
	testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
	features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
  ## note: feature names (in features[, 2]) are not unique
  ##       e.g. fBodyAcc-bandsEnergy()-1,8

# read activity labels
	activities <- read.table(file.path(dataPath, "activity_labels.txt"))
	colnames(activities) <- c("activityId", "activityLabel")

# merge the datasets and add labels
	humanActivity <- rbind(cbind(trainingSubjects, trainingValues, trainingActivity),
							cbind(testSubjects, testValues, testActivity))
	colnames(humanActivity) <- c("subject", features[, 2], "activity")

# filter on mean and std measurements
	columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))
	humanActivity <- humanActivity[, columnsToKeep]

# replace activity values with named factor levels
	humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])

# get column names
	humanActivityCols <- colnames(humanActivity)

# remove special characters
	humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# expand abbreviations and clean up names
	humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
	humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
	humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
	humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
	humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
	humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
	humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
	humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
	humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# use new labels as column names
	colnames(humanActivity) <- humanActivityCols

# group by subject and activity and summarise using mean
	humanActivityMeans <- humanActivity %>% 
	group_by(subject, activity) %>%
	summarise_each(funs(mean))

# save the shiny new data to a file
	write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, quote = FALSE)
