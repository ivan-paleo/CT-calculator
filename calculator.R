# Fixed variables (all in [mm])
px_size <- 0.1
detector_size <- 400


# FOV Calculator [mm]
# Calculate FOV for a given voxel size
fov.calc <- function(voxel_size) {
  detector_size/(px_size*1000/voxel_size)
}
# Specify voxel_size in µm
fov.calc(75)


# Voxel size calculator [µm]
# Calculate voxel size for a given FOV
voxel.calc <- function(fov) {
  px_size*1000/(detector_size/fov)
}
# Specify FOV in mm
voxel.calc(300)


# Pixel count calculator
# Calculate the required number of detector pixels for a give voxel size and FOV
pixel.calc <- function(voxel_size, fov){
  (fov*(px_size*1000/voxel_size))/px_size
}
# Specify voxel_size in µm and fov in mm
pixel.calc(voxel_size = 75, fov = 300)
