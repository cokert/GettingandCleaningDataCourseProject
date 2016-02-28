 ReadMe
 ========
 
 This repo contains my class project submission for week 4 of Getting and Cleaning Data.  The assignment is to read the average and stanard deviation data in [this dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) into a tidy dataset and then calculate the average for each column.  The code to accomplish this is in "run_analysis.R" in this repository.
 
 Notes
 ---
 1. The script is expected to be run from a folder into which the provided zip file has been extracted.  I.E., there should be a sub-folder called "UCI HAR Dataset" in the folder from which the script is run.  The script will quit and report an error if this folder does not exist.  
 1. library() statements are included for both used packages, which are noted below.
 

##### External packages used:
* **readr** - much faster than the built in function for reading fixed width files
* **dplyr** - makes working with data.frames easier
 
 



