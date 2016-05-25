run_analysis<-function(){
  
  ##1) Download data from source (web)
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipname <- "./data/getdata_projectfiles_UCI HAR Dataset.zip"
    
    # Create data folder
    if (!file.exists("data")) {
      dir.create("data")
    }
    # Unzip file
    if (!file.exists(zipname)){
      download.file(fileurl, destfile=zipname, mode="wb")
      unzip(zipname, exdir="./data")
    }

  ##2) Load necessary packages.
    #Get data.table package
    if(!("data.table" %in% rownames(installed.packages()))){
      
      install.packages("data.table")
      library(data.table)
      
    }else{
      
      library(data.table)
    }
    
    if(!("plyr" %in% rownames(installed.packages()))){
      
      install.packages("plyr")
      library(plyr)
      
    }else{
      
      library(plyr)
    }
  
  ## 3) Merge the training and the test sets to create one data set.
    #3a) Feature Label data
    # Reading in the features data from the features.txt
    features <- read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors=F)
    
    #3b) Activity label data 
    #Reading in the activity labels from the activity_labels.txt (needed to link class labels with activity names)
    activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=F)
    colnames(activity_labels)[1] = "Activity_label_id"
    
    #3c) Subject data (identifies the subject that performed the activity)   
    #Reading in the subjects from the testing and training sets
    subjects_training <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
    subjects_testing <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
    
    #Create new combined data set.
    merged_subjects <- rbind(subjects_testing, subjects_training)
    #Rename coumn with a meaningful name.
    colnames(merged_subjects)[1] = "Subjects_id"
    
    #3d) Activity labels data from subjects
    #Reading in the activity label data from the testing and training sets
    activitylabels_training <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
    activitylabels_testing <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
    
    #Create new combined data set.
    merged_activitylabels <- rbind(activitylabels_testing, activitylabels_training)
    
    #Rename coumn with a meaningful name.
    colnames(merged_activitylabels)[1] = "Activity_label_id"
    
    # Add the activities by their name from the activity_label data table to the subjects dataset.
    merged_activity_labels_with_category <- join(merged_activitylabels,activity_labels, by = "Activity_label_id")
    merged_subjects <- cbind(merged_subjects, merged_activity_labels_with_category$V2)
    colnames(merged_subjects)[2] = "Activity"
    
    #3e) feature reading data from subjects
    #Reading in the feature reading data for each subject.
    featureReadings_training <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
    featureReadings_testing <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
    
    #Create new combined data set.
    merged_featureReadings <- rbind(featureReadings_testing, featureReadings_training)
    
    #Replace feature reading column names with the feature names of the feature data set.
    for(i in 1:ncol(merged_featureReadings))
    {
      merged_subjects<-cbind(merged_subjects,merged_featureReadings[,i])
      names(merged_subjects)[ncol(merged_subjects)]<-features[i,2]
    }
    
    #Give final data set a meaningful name
    complete_dataset <- merged_subjects
    #Cleanup
    rm(merged_subjects)
  
  #4) Extract the mean and standard deviation measurements.
    extracted_meaures <- grep(".*(mean|std).*", colnames(complete_dataset), value = T)
    extracted_dataset <- complete_dataset[,c("Subjects_id", "Activity", extracted_meaures)]
  
  #5) Create descriptive activity names in the data set.
    #Tidy up activity names
    extracted_dataset$Activity <- gsub("SITTING","Sitting",extracted_dataset$Activity)
    extracted_dataset$Activity <- gsub("STANDING","Standing",extracted_dataset$Activity)
    extracted_dataset$Activity <- gsub("LAYING","Laying down",extracted_dataset$Activity)
    extracted_dataset$Activity <- gsub("WALKING_UPSTAIRS","Walking Upstairs",extracted_dataset$Activity)
    extracted_dataset$Activity <- gsub("WALKING_DOWNSTAIRS","Walking Downstairs",extracted_dataset$Activity)
    extracted_dataset$Activity <- gsub("WALKING","Walking",extracted_dataset$Activity)
    
  #6) Appropriately label the data set with descriptive variable names. 
    # Remove brakets from column names
    colnames(extracted_dataset) <- gsub("[/(/)]","",colnames(extracted_dataset))
    
    #Remove hyphens from the column names.
    colnames(extracted_dataset) <- gsub("-"," ",colnames(extracted_dataset))
    
  #7) Create the final summarised dataset.
    # Convert to data table to make use of summary functionality.
    extracted_dataset = data.table(extracted_dataset)
    
    # Group the data by Subjects and Activity and take mean of all the remaining columns.
    extracted_dataset <- extracted_dataset[,lapply(.SD,mean),by='Subjects_id,Activity']
    extracted_dataset <- extracted_dataset[order(extracted_dataset$Subjects_id),]
    
  #8) Writing final data to CSV
    write.csv(extracted_dataset,"Clean_Dataset.csv",row.names=F)
    
    cat("\n# Cleaned and Tidy data set written to CSV in default data directory. #")
}




