# CodeBook

The source data is distributed in a .zip archive.  The script `run_analysis.R` exects the provided zip file's contents to be extracted into its directory and left untouched.  The file extracts as follows:
```
. UCI HAR Dataset
+-- test
|   +-- Inertial Signals
|   |   +-- <files not used>
|   +-- subject_test.txt
|   +-- X_test.txt
|   +-- y_test.txt
+-- train
|   +-- Inertial Signals
|   |   +-- <files not used>
|   +-- subject_train.txt
|   +-- X_train.txt
|   +-- y_train.txt
+-- activity_labels.txt
+-- features_info.txt
+-- features.txt
+-- README.txt
```
###### _Note that contents of the `test` and `train` folders are very similar, differing only by a portion of their files' names that correspond to the folder name.  The folder name corresponds to what I refer to below as the "setname"_
* **activity_labels.txt** provides the friendly name for each activity performed and is used to replace the integer values contained in `y_<setname>.txt`
* **features_info.txt** - description of how the variables in each `X_<setname>.txt` were derived
* **features.txt** - list of names that correspond to the columns in each `X_<setname>.txt` file
* **README.txt** - describes the experimental process by which the data was derived.
    ##### Test/Train files

* **subject_<setname>.txt** - contains the subjectid of each row in `X_<setname>.txt` file.  This and `X_<setname>.txt` are merged with `cbind()` to get the subjectid attached to each row.
* **X_<setname>.txt** - The main source of data.  The data is all fixed with values of 16 characters each.  Each row is an observation, but doesn't have any identifying information itself.  The column names come from `features_info.txt` and the row identifying information comes from `subject_<setname>.txt` and `y_<setname>.txt`.
* **y_<setname>txt** - contains an activityid for each row of data in `X_<setname>.txt`.  The name of the activity is retrieved from `activity_labels.txt`

---
#### Processing steps
1. The first thing I do is load and clean the column headers from `features.txt` and load and clean the activity labels from `activity_labels.txt`.
2. Since the folder structure is identical for each set of data (`train` and `test`), the data is processed by a calling a function with the set we'd like to load.  The steps in this function are as follows:
    1. Load the X file (`X_<setname>.txt`) passing the cleaned features list to the  col_names parameter
    2. Load the y file (`Y_<setname>.txt`)
    3. Load the subject file (`subject_<setname>.txt`)
    4. Remove all columns from the X data except for columns containing mean or std
    5. Rename the columns in the y and subject data frames to something meaningful
    6. Look up the activity names for the y dataset from the contents of `activity_labels.txt`
    7. Bind three datasets (`x`, `y`, `subject`) together into one representing that set's data using `cbind()` and return it
3. Merge the two sets of data (`train` and `test`) into one using `rbind()`
4. Calculate the mean for each column using `summarize_each()` from the `dplyr` package (don't calculate the average for the categorical variables `set`, `subject`, and `activity`)
5. Remove the temporary variables and functions to keep clutter in the user's global environment to a minimum