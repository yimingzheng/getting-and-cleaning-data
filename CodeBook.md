# CodeBook

This CodeBook describes the implementation details of the run_analysis.R

### Data
[Human Activity Recognition 
 Using Smartphones Dataset (Version 1.0) ](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)     
**X: features**   
X_train.txt: 7352 observations of 561 variables           
X_test.txt: 2947 observations of 561 variabless   
**subject**   
subject_train.txt: 7352 observations of 1 volunteer_id (range from 1 to 30)   
subject_test.txt: 7352 observations of 1 volunteer_id (range from 1 to 30)   
**Y: class**   
X_train.txt: 7352 observations of the 1 activity_id             
X_test.txt: 2947 observations of the 1 activity_id    
**feature info**   
features_info.txt: 561 id-label pairs for features, with ids ranging from 1 to 561      
**activitylabels**   
activity_labels.txt: 6 id-label pairs for activities, with ids ranging from 1 to 6     


### Work flow
1. Download the [Human Activity Recognition Using Smartphones Dataset (Version 1.0) ](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)    
2. Unzip the file to the directory of "UCI HAR Dataset"  
3. Use read.tables function to read and concatenate "train/X_train.txt" and "test/X_test.txt" as "X", "train/Y_train.txt" and "test/Y_test.txt" as "Y", "train/subject_train.txt" and "test/subject_test.txt" as "subject" respectively.     
4. Filter the 66 rows in "feature_info.txt" with the feature description containing either "mean()" or "std()". And extract features from "X" by matching the column index with the feature id.  
5. Add a variable to Y that labels the activities according to their ids     
6. Bind "X", "subject" and "Y$label" to by column form a table of 10299 rows and 68 cols and column names to it    
7. Summarize the mean of each variable for each catagory of (subject + activity)    

### Functions    
  
1. [read.tables()](http://stackoverflow.com/questions/2104483/how-to-read-table-multiple-files-into-a-single-table-in-r?answertab=active#tab-top).     
2. Use *grepl* to extract features with the name that match the pattern of "*mean\\(\\)*|std\\(\\)*"     
3. Use *join* to merge Y and activity_labels by activity_id     
4. Use *cbind* to add subject and Y(activity) as columns to X   
5. Use *melt* and *dcast* functions in *reshape2* library to summarize the group mean of (subject + activity)  
