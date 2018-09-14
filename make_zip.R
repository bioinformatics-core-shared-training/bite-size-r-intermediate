files <- c(
	"1.introduction.html",
	"2.dplyr-intro.nb.html",
	"3.workflows.nb.html",
	"4.summarise-and-combine.nb.html",
	"ggplot2.html",
	"2.dplyr-intro-exercises.Rmd",
	"3.workflows-exercises.Rmd",
	"4.summarise-and-combine-exercises.Rmd",
	"ggplot2-exercises1-images.html",
	"ggplot2-exercises1.Rmd",
	"ggplot2-exercises2-images.html",
	"ggplot2-exercises2.Rmd",
	"patient-data.txt",
	"patient-data-cleaned.txt",
	"clinicalData.txt",
	"tidyr-example.txt",
	"diabetes.txt"
)
zip(files, zipfile = "Course_Data.zip")
