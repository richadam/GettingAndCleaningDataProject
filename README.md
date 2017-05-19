# Getting and Cleaning Data course project

This project is focused on data based on wearable computing technology - for example, [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) describes the market competition and it's relevance to data science. 

In this project, data collected from the accelerometer and gyroscope of the Samsung Galaxy S smartphone was retrieved, worked with, and cleaned, to prepare a tidy data that can be used for later analysis.

This repository contains the following files:

- `README.md`, this file, which provides an overview of the data set and how it was created.
- `tidy_data.txt`, which contains the data set.
- `CodeBook.md`, the code book, which describes the contents of the data set (data, variables and transformations used to generate the data).
- `run_analysis.R`, the R script that was used to create the data set (see the [Creating the tidy data set](#creating-tidy-data-set) section below) 

## The study data <a name="the-study-data"></a>

The source data set that this project was based on was obtained from the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#), which describes how the data was initially collected.

Training and test data were first merged together. The measurements on the mean and standard deviation were extracted for each measurement. The measurements were averaged for each subject and activity, resulting in the final data set.

## Creating the tidy data set <a name="creating-tidy-data-set"></a>

The R script `run_analysis.R` is used to create a new tidy data set. It performs the following steps:

- Download and unzip source data if necessary.
- Read data.
- Merge the train and the test data sets to create one data set.
- Filter measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names for the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- Create a new tidy set with the average of each variable for each activity and each subject.
- Write the new tidy data set to the `tidy_data.txt` file.

The `tidy_data.txt` in this repository was created by running the `run_analysis.R` script using R version 3.3.3 on Windows 10.

This script requires the `dplyr` package (v0.5.0 was used).