##preparing each set for merging
train <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt", sep="\t")
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt")


test <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt", sep="\t")
test_subject <- read.table("UCI HAR Dataset/test/subject_test.txt")

#adding column features and row identifiers to test and train
features <- read.table("UCI HAR Dataset/features.txt")
colnames(test) <- features[,2]
colnames(train) <- features[,2]

train[,"Labels"] <- train_labels
train[,"Subject"] <- train_subject

test[,"Labels"] <- test_labels
test[,"Subject"] <- test_subject

#Merging the data set 
df <- merge(train, test, all=TRUE)

#Extracting measurements with mean and std. Keeping labels and subject in the new data set
library(dplyr)
col_names <- names(df)
mean_stdcolnames <- grep("mean|std|Labels|Subject", col_names)
mean_std_Measures <- select(df, mean_stdcolnames)


#Descriptive names to activities
mean_std_Measures$Labels <- factor(mean_std_Measures$Labels, levels = c(1,2,3,4,5,6), labels= c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

#Labeling the columns better
names(mean_std_Measures) <-gsub(" *\\(.*?\\) *", "",(names(mean_std_Measures)))
names(mean_std_Measures) <-gsub("-", "_",names(mean_std_Measures))



# Group by Activity and Subject 
#Average of each variable for each activity and each subject
group_activity_subject <- group_by(mean_std_Measures, Labels, Subject)
activitySubjectdf <-group_activity_subject %>% summarise_each(funs(mean))


write.table(activitySubjectdf, "./tidy_dataset.txt", row.names = FALSE)
