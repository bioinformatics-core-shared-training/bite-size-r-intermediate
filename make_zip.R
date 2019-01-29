files <- c(
	"2.dplyr-intro-exercises.Rmd",
	"3.workflows-exercises.Rmd",
	"4.summarise-and-combine-exercises.Rmd",
	"ggplot2-exercises.Rmd",
	"ggplot2-exercises-with-images.html",
	"ggplot2-live-coding-script.html",
	"patient-data.txt",
	"patient-data-cleaned.txt",
	"clinicalData.txt",
	"tidyr-example.txt",
	"diabetes.txt"
)
zip(files, zipfile = "Course_Data.zip")
