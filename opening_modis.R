# opening the modis data files

library(rhdf5)
hdf_files <- list.files('~/Downloads/', pattern = '.h5')
setwd("~")
file <- file.path("Downloads", hdf_files)

h5ls(file)
##### with Jeff 

library(sp)
library(rgdal)
library(raster)

setwd("~/Desktop/modis_data")
BAP <- raster("./original/2000/MCD45monthly.A2000336.Win03.051.burndate.tif")
plot(BAP)
# read in the EPA eco region shapefile
allER <- readOGR(dsn="./working/shapefiles/us_eco_l3.shp",layer="us_eco_l3")
# subset/select only the southern rockies; QGIS to identify the region
srock <-allER[allER$US_L3CODE=="21",]


############# getting a folder of files into R and stacking them
###################################################################

BAP_list <- list.files("./original/2000")





sr_ext<-extent(srock)
#t.proj<-BAP$coord.ref.

#burn_sr<-crop(allER,srock,snap="in")
#burn_sr<-crop(BAP,sr_ext,snap="in")
# get CRS for the raster
t_proj<-crs(BAP)

#just below is wrong
#srock_rp <-spTransform(srock,CRS(t_proj))
srock_rp <-spTransform(srock,t_proj)
burn_sr<-crop(BAP,srock_rp)

#extract raster values for polygon
BAP_ext <- extract(burn_sr, srock_rp, cellnumbers=TRUE, df=TRUE) 
colnames(BAP_ext)<-c("cells","values")
BAP_ext_i <-BAP_ext$cell

BAP_xy <- rasterToPoints(burn_sr)
BAP_x <-BAP_xy[BAP_ext_i,c("x")]
BAP_y <-BAP_xy[BAP_ext_i,c("y")]
BAP_val <- BAP_xy[BAP_ext_i,c("MCD45monthly.A2000336.Win03.051.burndate")]

plot(allER)
plot(srock_rp)
plot(burn_sr)
list(srock)
list(allER)
