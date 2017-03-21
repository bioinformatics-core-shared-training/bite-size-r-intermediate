files <- list.files(pattern="*.Rmd")
files <- c(files, "patient-data.txt","patient-data-cleaned.txt","clinicalData.txt","tidyr-example.txt","diabetes.txt")
files <- c(files, "images/")
files <- files[-grep("solutions",files)]
zip(files, zipfile = "Course_Data.zip")
