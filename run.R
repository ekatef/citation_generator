rm(list = ls())
library(XML)
library(stringr)

citation_dir <- "./"

source("funs.R")

# calculations -----------------------------------------------------------------
bibl_data <- list.files(pattern = ".xml$")
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
write.table(res_end, file = "test_25.txt",
	row.names = FALSE, col.names = FALSE,
	quote = FALSE)