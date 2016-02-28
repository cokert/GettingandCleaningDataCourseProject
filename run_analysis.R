library(readr)
library(dplyr)

if(!file.exists("UCI HAR Dataset"))
  stop("folder UCI HAR Dataset not found")

## since the files in each directory (test and train) are identical, one function to read either with the
## name/folder passed as an argument eliminates code duplication
## activitylabels as well as features are referenced in here, and they're accessible inside of the function
## because they exist in the calling frame
readfiles<- function(name) {
  #use read_fwf from readr package.  WAY faster than read.fwf
  x<-read_fwf(file.path("UCI HAR Dataset", name, paste0("X_", name, ".txt")), fwf_widths(rep(16,561), col_names=features))
  y<-read.csv(file.path("UCI HAR Dataset", name, paste0("y_", name, ".txt")), sep=" ", header = F)
  subject<-read.csv(file.path("UCI HAR Dataset", name, paste0("subject_", name, ".txt")), sep=" ", header = F)
  
  #extract only the columns we care about (those containing "mean" and "std")
  x<-x[,grepl("mean|std", names(x))]
  
  #rename columns in supporting tables
  y<-rename(y, activity = V1)
  subject<-rename(subject, subject = V1)
  
  #substitue labels from activitylabels into y
  y$activity<-activitylabels[y$activity]
  
  #join the sets and assign the name as the "set" column
  set<-cbind("set"=name, subject, y, x)
}


#load and fix feature names
features<-read.delim(file.path("UCI HAR Dataset", "features.txt"), sep=" ", header=F)
features<-as.character(features[['V2']])
#fix features
features <- tolower(features)         #lowercase everything
features <- gsub("-", "", features)   #remove -
features <- gsub("\\(", "", features) #remove (
features <- gsub("\\)", "", features) #remove )
#these next two lines pad single indexes with double zeros, so
#  fbodyaccbandsenergy1,8
#     becomes
#  fbodyaccbandsenergy01,08
# this way the indices are still known when the comma is removed
#  (note, this isn't necessary as the columns this affects are thrown out,
#   but i cleaned all columns provided before realizing we only care about
#   stdev and mean for this assignment.)
features <- gsub("([a-z])([1-9]),", "\\10\\2,", features) 
features <-gsub("([0-9]),([0-9])$", "\\1,0\\2",features)
features <- gsub(",", "", features)   #remove ,

#load activity_labels
activitylabels<-read.delim(file.path("UCI HAR Dataset", "activity_labels.txt"), sep=" ", header=F)
activitylabels<-as.character(activitylabels[['V2']])
activitylabels<-tolower(activitylabels)         #to lowercase
activitylabels<-gsub("_", "", activitylabels)   #remove _

#read files in each foler, then join them together with rbind
trainset <- readfiles("train")
testset <- readfiles("test")
set<-rbind(trainset, testset)

#generate the required summary
#  calling this using funs=mean generates this error: 
#       no applicable method for 'as.lazy_dots' applied to an object of class "function"
#  i have no idea why this is, but a google search brought me to this link which 
#  mentioned ~mean, and that works.
#  http://stackoverflow.com/questions/29401907/use-list-of-functions-with-dplyrsummarize-each#comment46989094_29401907
summarised<-set%>%group_by(activity, subject)%>%summarise_each(funs=~mean, -(set:activity))

#clean up temporary lists/functions to not pollute the global environment
rm("activitylabels")
rm("readfiles")
rm("features")
rm("trainset")
rm("testset")
