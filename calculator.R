# Fixed variables (all in mm)
px_size <- 0.1
detector_size <- 400


# FOV Calculator [mm]
fov.calc <- function(voxel_size) {
  detector_size/(px_size*1000/voxel_size)
}
# Specify voxel_size in µm
fov.calc(86)


# Voxel size calculator [µm]
voxel.calc <- function(obj_size) {
  px_size*1000/(detector_size/obj_size)
}
# Specify obj_size in mm
voxel.calc(370)


# Pixel count calculator
pixel.calc <- function(voxel_size, obj_size){
  (obj_size*(px_size*1000/voxel_size))/px_size
}
# Specify voxel_size in µm and obj_size in mm
pixel.calc(voxel_size = 45, obj_size = 180)
