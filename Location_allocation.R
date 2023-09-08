libs <- c(
  'viridis', 'sf',
  'tidyverse', 'terra'
  )

invisible(
  lapply(libs,library,character.only = T)
)

#load raster and shapefiles
ras_pop <- terra::rast("mubi.tif") # use terra
mubi_wards <- sf::st_read("Wards_mubi.shp") # use sf
health_f <- sf::st_read(
  "Nigeria_-_Health_Care_Facilities_.shp" #use sf
) 

#set uniform coordinate reference system for both datasets
mubi_wards <- sf::st_transform(
  mubi_wards,
  crs = st_crs(ras_pop)
)

# Extract zonal statistics to get population sum for each ward
zonal_stats <- terra::zonal(
  ras_pop, 
  terra::vect(mubi_wards), # your sf object needs to be converted into a terra Spatvector
  sum,
  na.rm = T # you should also ignore NAs
)

#get a subset of health facilites in mubi wards 
mubi_health <- sf::st_join( # this is much faster that st_intersection
  health_f,
  mubi_wards,
  sf::st_within # using this to determine where every point falls
)

#calculate euclidean distances between health facilities in mubi
mubi_euclidist <- sf::st_distance(mubi_health) # to calcualte distance you need two points
mubi_euclidist <- raster::raster(mubi_euclidist)

ggplot() +
  geom_stars(data = ras_pop,na.rm=TRUE) + 
  geom_sf(data = mubi_health,aes(color=wardname))+
  geom_sf(data = mubi_wards,alpha =0.5) +
  scale_fill_viridis_c(na.value = "white") +
  theme_void()
