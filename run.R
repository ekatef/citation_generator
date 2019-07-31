rm(list = ls())
library(XML)
library(stringr)

source("funs.R")
source("0_local_config.R")

if (!exists("citation_dir")) {
	citation_dir <- "./"
}

# calculations -----------------------------------------------------------------
bibl_data <- list.files(cit_dir_name, pattern = ".xml$", 
	full.names = TRUE)
print(bibl_data)

# deliberately taken the first file only
list_xml <- xmlToList(bibl_data[1])
# print(list_xml)

bibl_list_item <- list_xml[[1]]

res_set <- lapply(
	function(i) ConstructRecordThermEng(list_xml[[i]]),
	X = seq(along.with =list_xml)
)
print(res_set)

res_end <- lapply(FUN = rbind, X = res_set)
write.table(res_end, file = file.path(cit_dir_name, "test_25.txt"),
	row.names = FALSE, col.names = FALSE,
	quote = FALSE)