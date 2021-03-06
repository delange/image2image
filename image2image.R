## This code is based the code of Roald Bradley Severtson : 
## https://github.com/Microsoft/microsoft-r/tree/master/microsoft-ml/Samples/PreTrainedModels/ImageAnalytics/ImageFeaturizer

library(MicrosoftML)

## Change NA to the actual location of the script. Use the absolute path.
 workingDir <- "C:/Users/Public/Code_local/Projects/image2image"

if (is.na(workingDir)) {
    stop("The working directory needs to be set to the location of the script.")
}

# Check if the working directory exists
if (dir.exists(workingDir)) {
    setwd(workingDir)
} else {
    stop(paste(workingDir, "does not exist. Please make sure the working directory is correct."))
}


## Set the location of the images
imageLocation = "images/"

images <- list.files(paste0(imageLocation, "collection"), recursive = TRUE, pattern = "\\.jpg", full.names = TRUE)

# Setup a dataframe with the path to the image
# MUST set the stringAsFactors to FALSE
imageDF <- data.frame(Image = images, stringsAsFactors = FALSE)

# Get the feature vectors of the images
# This requires a 4 step process:
# 1. Load the image(s) via the loadImage() transform
# 2. Resize the image(s) to the size required by the image model 
#    (224x224 for resnet models, 227x227 for the alexnet model)
# 3. Extract the pixels from the resized image(s) using the extractPixel() transform
# 4. Finally, featurize the image(s) via the featurizeImage() transform
imageFeatureVectorDF <- rxFeaturize(
  data = imageDF,
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 227, height = 227),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "alexnet")
  ))


# Now, given an image, the task is to find the best matching image 
# from the list of images we'd featurized above
# First featurize the image that we want to find matches for
# We start with creating a dataframe with the location of the image
imageToMatch <- data.frame(Image = c(file.path(imageLocation, "sample/chair56.jpg")),
                           stringsAsFactors = FALSE)

# Now let's featurize this image we want to match
# We'll use the Alexnet model
imageToMatchDF <- rxFeaturize(
  data = imageToMatch,
  mlTransforms = list(
    loadImage(vars = list(Features = "Image")),
    resizeImage(vars = "Features", width = 227, height = 227),
    extractPixels(vars = "Features"),
    featurizeImage(var = "Features", dnnModel = "alexnet")
  ))


# Next we'll calculate the Euclidean distance between the image and all the other images
# We ignore the 1st column which is the image path
# Then, the best matched image will be determined
distVals <- dist(rbind(imageFeatureVectorDF, imageToMatchDF)[, -1], "euclidean")

matchedImage <- images[which.min(head(as.matrix(distVals)[nrow(as.matrix(distVals)),], -1))]

matchedImage
