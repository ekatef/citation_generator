
paste_non_null <- function(head_char = "", meaningful_part, 
	tail_char = ""){
	ifelse(!is.null(meaningful_part), 
		paste0(head_char, meaningful_part, tail_char), "") 
}

# extract first letters of the authors' first names
ExtractFNLetters <- function(fn_vct) {
	fn_delim <- str_extract(fn_vct, pattern = "\\h+|\\.(\\h+)|\\.")

	fn_names <- ifelse(!(is.na(fn_delim)), 
		str_split(fn_vct, pattern = paste0("\\", fn_delim)),
		fn_vct)

	res <- lapply(fn_names, function(s) substring(s, 1, 1))
	return(unlist(res))
}

# LateX format
# @lang_accuracy is optionally to put "V" or "T" for a volume
ConstructRecord <- function(xml_item, lang_accuracy = FALSE) {

	if (lang_accuracy) {
		require(franc)
	}

	authors_string_list <- sapply(
	function(i) {
		test <- paste0(xml_item$Author$Author$NameList[i]$Person$Last, ", ",
			substr(xml_item$Author$Author$NameList[i]$Person$First, 1, 1), ".")
	}, X = seq(along.with = xml_item$Author$Author$NameList))
	authors_string <- paste(authors_string_list, collapse = ", ")


	publ_id <- paste(
		substr(xml_item$Author$Author$NameList[1]$Person$Last, 1, 5),
		xml_item$Year, sep = "_")
	res <- paste0(
		"\\bibitem {", publ_id,"}", "\r\n", #"***",
		authors_string, ":", "\r\n",
		xml_item$Title, ". ",
		xml_item$JournalName, " ",
		" (", xml_item$Year, "). ",
		xml_item$StandardNumber, "\r\n"
		)
	# write.table("test_list.txt", append = TRUE,
	# 	row.names = FALSE, col.names = FALSE)
	return(res)
}

# ThermalEngineering format (RU version)
# @lang_accuracy is optionally to put "V" or "T" for a volume
ConstructRecordThermEng <- function(xml_item, lang_accuracy = FALSE) {

	if (lang_accuracy) {require(franc)}

	authors_string_list <- sapply(
	function(i) {
		names_list <- xml_item$Author$Author$NameList[i]
		test <- paste0(
			names_list$Person$Last, ", ",
			paste0(ExtractFNLetters(names_list$Person$First), collapse 
				 = "."), "."
		)	
			# substr(xml_item$Author$Author$NameList[i]$Person$First, 1, 1), ".")
	}, X = seq(along.with = xml_item$Author$Author$NameList))
	authors_string <- paste(authors_string_list, collapse = ", ")

	if (lang_accuracy) {
		char_for_vol <- ifelse(franc(xml_item$Title) == "rus", "T.", "V.")
	} else {
		char_for_vol <- "V."
	}

	publ_id <- paste(
		substr(xml_item$Author$Author$NameList[1]$Person$Last, 1, 5),
		xml_item$Year, sep = "_")
	res <- paste0(
		authors_string, " ", 
		xml_item$Title, " // ",
		paste_non_null("", xml_item$JournalName, ". "),
		paste_non_null("", xml_item$Year, ". "),
		paste_non_null(char_for_vol, xml_item$Volume, ". "),
		paste_non_null("№", xml_item$Issue, ". "),
		paste_non_null("C.", xml_item$Pages, ". "),
		paste_non_null("doi:", xml_item$StandardNumber, ""),
		"\r\n", "\r\n"
		)
	return(res)
}