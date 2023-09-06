libs <- c('viridis', 'sf','stars','tidyverse','ggthemes','rvest','ggrepel','plotly','raster','terra')
invisible(
  lapply(libs,library,character.only = T)
)

library(ggplot2)




ras_pop <- read_stars("/Users/User/Documents/GIS/Healthcare Allocation Analysis/raster/mubi.tif")
mubi_wards <- read_sf ("/Users/User/Documents/GIS/Healthcare Allocation Analysis/nigeria_health_facilities/Wards_mubi.shp")

mubi_wards <- st_transform(mubi_wards,crs = st_crs(ras_pop))

# Extract zonal statistics 
zonal_stats <- zonal(ras_pop, mubi_wards, sum)

ras_pop <- st_as_stars(ras_pop)

ggplot() +
  geom_stars(data = ras_pop,na.rm=TRUE,alpha=1) + 
  scale_fill_viridis_c(na.value = "white") +
  theme_void()
  
  
