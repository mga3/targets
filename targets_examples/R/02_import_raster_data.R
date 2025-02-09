# Define custom functions here, that are sourced into the _targets.R script.
raster_import <- function(s3_uri) {
    terra::rast(s3_uri)
}
# Metadata below is an unused argument to ensure the target has a dependency on 
# the metadata, so the files are checked for changes before running.
rasters_into_sprc <- function(raster_list, metadata) {
    terra::sprc(raster_list)
}