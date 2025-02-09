# Define custom functions here, that are sourced into the _targets.R script.
import_data_metadata <- function(s3_list) {
    uri <- s3_list
    bytes <- s3fs::s3_file_info(s3_list)$size
    return(list(uri, bytes))
}
import_data_test <- function(s3_list, dependency) {
    s3fs::s3_file_download(s3_list, "data.xlsx")
}