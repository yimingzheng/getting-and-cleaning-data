# Dependencies
library(plyr)
library(reshape2)

# Helper function. Link: http://stackoverflow.com/questions/2104483/how-to-read-table-multiple-files-into-a-single-table-in-r?answertab=active#tab-top
read.tables=function(file_names,...){
        ldply(file_names, function(file_name) data.frame(read.table(file_name,...)))
}

# 0. Gets data
zipFileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFileName="getdata-projectfiles-UCI HAR Dataset.zip";
if(!file.exists(zipFileName)){
        download.file(zipFileUrl, zipFileName, method="curl")
}
unzip(zipFileName,exdir = ".")
rawDataDir="UCI HAR Dataset"

# 1. Merges the training and the test sets to create one data set.
X=read.tables(c(file.path(rawDataDir,"train/X_train.txt"), file.path(rawDataDir,"test/X_test.txt")),colClasses=rep("numeric",561))

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features=read.table(file.path(rawDataDir,"features.txt"),colClasses=c("numeric","character"),col.names=c("index","description"))
features=features[grepl("*mean\\(\\)*|std\\(\\)*",features$description),]
X=X[,features$index]

# 3. Uses descriptive activity names to name the activities in the data set
Y=read.tables(c(file.path(rawDataDir,"train/Y_train.txt"), file.path(rawDataDir,"test/Y_test.txt")),colClasses="numeric",col.names=c("activity"))
activity_labels=read.table(file.path(rawDataDir,"activity_labels.txt"),colClasses=c("numeric","character"),col.names=c("activity","label"))
Y=join(Y,activity_labels,by="activity")

# 4. Appropriately labels the data set with descriptive variable names.
subjects=read.tables(c(file.path(rawDataDir,"train/subject_train.txt"), file.path(rawDataDir,"test/subject_test.txt")),colClasses="numeric")
X=cbind(X,subjects,Y$label)
colnames(X)=c(features$description,"subject","activity")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
data_melt<-melt(X,id.vars=c("subject","activity"),measure.vars=features$description)
dcast_mean=dcast(data_melt, subject + activity ~ variable,mean)

# 6. Outputs the clean data as txt file 
write.table(dcast_mean,"UCIHARDataset_subject_activity_variablemean.txt",row.name=FALSE)
