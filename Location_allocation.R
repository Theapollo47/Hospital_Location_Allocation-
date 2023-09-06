libs <- c('viridis', 'sf','stars','tidyverse','ggthemes','rvest','ggrepel','plotly','raster','terra','ggplot2')
invisible(
  lapply(libs,library,character.only = T)
)



#load raster and shapefiles
ras_pop <- read_stars("/Users/User/Documents/GIS/Healthcare Allocation Analysis/raster/mubi.tif")
mubi_wards <- read_sf ("/Users/User/Documents/GIS/Healthcare Allocation Analysis/nigeria_health_facilities/Wards_mubi.shp")
health_f <- read_sf ("/Users/User/Documents/GIS/Healthcare Allocation Analysis/nigeria_health_facilities/Nigeria_-_Health_Care_Facilities_.shp") 

#set uniform coordinate reference system for both datasets
mubi_wards <- st_transform(mubi_wards,crs = st_crs(ras_pop))

# Extract zonal statistics to get population sum for each ward
zonal_stats <- zonal(ras_pop, mubi_wards, sum)

#get a subset of health facilites in mubi wards 
mubi_health <- st_intersection(health_f,mubi_wards)

#calculate euclidean distances between health facilities in mubi and convert to raster
mubi_euclidist <- st_distance(mubi_health)
mubi_euclidist <- raster::raster(mubi_euclidist)



ggplot() +
  geom_stars(data = ras_pop,na.rm=TRUE) + 
  geom_sf(data = mubi_health,aes(color=wardname))+
  geom_sf(data = mubi_wards,alpha =0.5) +
  scale_fill_viridis_c(na.value = "white") +
  theme_void()
  
