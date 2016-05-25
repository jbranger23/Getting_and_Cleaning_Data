
## Getting and Cleaning Data Course Prjoect Codebook.

This document describes the code inside run_analysis.R. and what each section of code does.  
  
###The code is separated into sections by comments:  
    * Download data from source (web)  
    * Load necessary packages.  
    * Merge the training and the test sets to create one data set.  
    * Extract the mean and standard deviation measurements.  
    * Create descriptive activity names in the data set.  
    * Appropriately label the data set with descriptive variable names.   
    * Create the final summarised dataset.  
    * Writing final data to CSV  

  
###Download data from source (web)    
    * Downloads the UCI HAR zip file from source if it doesn't already exist.  
    * Creates a dtaa directory to place the file in if it doesnt already exist.  
    * Unzips the file.  
    
###Load necessary packages      
    * Checks to see if if the plyr and data.table packages are installed, if not they are installed.  
    * Both packages are loaded into memory.  
      
###Merge the training and the test sets to create one data set.      
    * Reads the column names of data (a.k.a. features) to features  
    * Reads the activity labels to activity_labels  
    * Reads the test and training subject data into separate data tables which are then merged.  
    * Reads the test and training activity label data into separate data tables which are then merged.  
    * The activities are then added from the activity label data table to the subjects dataset.  
    * Reads the test and training feature reading data into separate data tables which are then merged.  
    * The subjects data set is merged with the feature reading data set and the generic column names of the 
      feature reading data set are then replaced with the matching feature names of the feature data set.  
    * This data table is renamed to complete_dataset and is ready for manipulation.   

###Extract the mean and standard deviation measurements.  
    * The mean and standard deviaton measurements are extracted from complete_dataset as well as Activity and Subject_id and merged         into extracted_dataset.  
    
###Create descriptive activity names in the data set.  
    * The activity names are updated to more meaningful names.  
  
###Appropriately label the data set with descriptive variable names.   
    * The variable names are cleaned up by removing brackets and hyphens.  
  
###Create the final summarised dataset.  
    * The data set is summarised by mean and glouped by Subject_id and Activity.  
    * It is then reordered by Subject_id.  

At this point the final data table extracted_dataset looks like this:  
> head(extracted_dataset)
  Subjects_id           Activity tBodyAcc mean X tBodyAcc mean Y tBodyAcc mean Z tBodyAcc std X
1           1           Standing       0.2789176    -0.016137590      -0.1106018    -0.99575990
2           1            Sitting       0.2612376    -0.001308288      -0.1045442    -0.97722901
3           1        Laying down       0.2215982    -0.040513953      -0.1132036    -0.92805647
4           1            Walking       0.2773308    -0.017383819      -0.1111481    -0.28374026
5           1 Walking Downstairs       0.2891883    -0.009918505      -0.1075662     0.03003534
6           1   Walking Upstairs       0.2554617    -0.023953149      -0.0973020    -0.35470803


###Writing final data to CSV  
  * The data table is then written to the ouputfile Clean_Dataset.csv.  

