# This script was created by running targets::tar_script() into the console.
# _targets.R pipeline is defined in the list() function at the end of this script, to test:

# - geotargets, tar_terra_rast()

# - saving intermediate target output to aws s3

# EDIT: I do not have a personal AWS s3 account, so am saving this pipeline to 
# get the structure only - it will not run as no aws credentials are loaded.


# Load packages required to define the pipeline:

# Set target options:

targets::tar_option_set(
    packages = c("readxl", "dplyr", "terra"),
    # the repository and resources lines are for saving meta and objects on s3.
    repository = "aws",
    resources = targets::tar_resources(
        aws =  targets::tar_resources_aws(bucket = "...",
                                          prefix = "..."))
)



# Source in the R scripts in the R/ folder that contain the custom functions:

targets::tar_source()

# Now, list all of the targets that make up the pipeline:

list(
    # First target generates a list that includes the s3uri, last modified date and size.
    targets::tar_target(
        name = data,
        command = import_data_metadata("s3://path/to/file.xlsx"),
        repository = "aws",
        cue = targets::tar_cue(mode = "always")
    ),
    # Now, save the file as a target.
    # It is saved in the _target/objects folder (in s3).
    # 'data' is added as a dependency explicitly. If the contents change, this reruns.
    targets::tar_target(
        name = read_data,
        command = import_data_test(data[[1]], data),
        format = "file",
        repository = "aws"
    ),
    # Now, run models (just head() here as proof of concept) on the target once it is read in.
    targets::tar_target(
        name = model,
        command = head(read_data, 10)
    ),

    # If adding any non raster objects e.g. tables that maybe aren't saved
    # locally, best is to use two targets, one to read in the file and use format
    # = "file". Second for data manipulation, starting with the output of the
    # first target as the input. That way, if the file changes, the manipulation 
    # target is rerun.

    #### Now, add in a raster and crop it to see how it saves on s3: ####
    
    # First target creates a list of s3_uris that are to be mapped over.
    targets::tar_target(
        name = s3_uris,
        command = s3fs::s3_dir_ls("s3://add/path"),
        repository = "aws",
        cue = tar_cue(mode = "always")
    ),
    # Next target generates a list of raster targets that includes the s3 URI and the file size.
    targets::tar_target(
        name = raster_metadata,
        command = import_data_metadata(s3_uris),
        pattern = map(s3_uris),
        repository = "aws",
        iteration = "list",
        cue = tar_cue(mode = "always")
    ),
    # Now, geotargets is used to read in the rasters as target objects.
    geotargets::tar_terra_rast(
        name = raster_targets,
        command = raster_import(raster_metadata[[1]][[1]]),
        pattern = map(s3_uris),
        repository = "aws"
    ),
    # Next, save each of the rasters together into one sprc object (each layer is a raster).
    geotargets::tar_terra_sprc(
        name = sprc,
        command = rasters_into_sprc(s3_uris, raster_metadata),
        repository = "aws"
    ),
    # Get just the first entry in the sprc.
    geotargets::tar_terra_rast(
        name = raster_extract,
        command = sprc[1],
        repository = "aws"
    )
)