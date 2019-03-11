library(tidyverse)

pat <- read.delim("patient-data.txt", stringsAsFactors=FALSE)

states <- c("Californa", "California", "Colorado ", "Colorado", "Georgia", "Georgia",
            "Indiana", "indiana", "New York", "New York", "North Carolina", "North Caroline")

pat$State <- sample(states, nrow(pat), replace = TRUE)


patcl <- read.delim("patient-data-cleaned.txt", stringsAsFactors=FALSE)
all(pat$ID==patcl$ID)
# [1] TRUE

patcl$State <- pat$State %>%
    str_replace("Californa", "California") %>%  
    str_replace("Colorado ", "Colorado") %>%  
    str_replace("indiana", "Indiana") %>%  
    str_replace("North Caroline", "North Carolina")

write.table(pat, "patient-data.txt", row.names=FALSE, quote=FALSE, sep="\t")
write.table(patcl, "patient-data-cleaned.txt", row.names=FALSE, quote=FALSE, sep="\t")
