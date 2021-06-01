# This code is for references purposes - running this linearly is not advised.
# Be sure to replace USERNAME/URLs as appropriate, and run package.install() for required libraries.
# the getDataNC4 method handles filtering logic, some of the graphic code is shown below.
# Usage patterns can be seen under code.Rhistory. Relevant plots are exported to the plots/ folder.

# Code below this line --------------------------------------------------------------------------------

# ref: https://rpubs.com/boyerag/297592
library(ncdf4) # package for netcdf manipulation
library(raster) # package for raster manipulation
library(rgdal) # package for geospatial analysis
library(ggplot2) # package for plotting
library(leaflet)

nc_data <- nc_open('/Users/USERNAME/URL/oco3_LtCO2_200728_B10205Xr_200824052025s.nc4')

# aa <- which(ncvar_get(nc_data, "latitude") < 42)
# ab <- which(ncvar_get(nc_data, "latitude") > 39)
# la <- intersect(aa, ab)

# oa <- which(ncvar_get(nc_data, "longitude") < -79)
# ob <- which(ncvar_get(nc_data, "longitude") > -82)
# lo <- intersect(oa, ob)

# ind <- intersect(la, lo)

# xco2 <- ncvar_get(nc_data, "xco2")[ind]
# dates <- as.POSIXct(ncvar_get(nc_data, "time")[ind], origin="1970-01-01")

# dats <- data.frame(xco2, ncvar_get(nc_data, "longitude")[ind], ncvar_get(nc_data, "latitude")[ind], dates)
# dats <- data.frame()

# Method to extract, filter, and aggregate data
getDataNC4 <- function(folder="/Users/USERNAME/URL", file=NULL) {
  if (!missing(file)) {
    files = list(file)
  } else {
    files = list.files(path = folder)
  }
  dats2 <- data.frame();
  for (file in files) {
    addr <- paste(c(folder, file), collapse="")
    print(addr)
    nc_data <- nc_open(addr)
    # print(length(ncvar_get(nc_data, "xco2")))
    
    aa <- which(ncvar_get(nc_data, "latitude") < 42)
    ab <- which(ncvar_get(nc_data, "latitude") > 39)
    la <- intersect(aa, ab)
    # print(length(la))
    
    oa <- which(ncvar_get(nc_data, "longitude") < -79)
    ob <- which(ncvar_get(nc_data, "longitude") > -82)
    lo <- intersect(oa, ob)
    # print(length(lo))
    
    ind <- intersect(la, lo)
    print(length(ind))
    # print(ind)
    
    xco2 <- ncvar_get(nc_data, "xco2")[ind]
    dates <- as.POSIXct(ncvar_get(nc_data, "time")[ind], origin="1970-01-01")
    # print(dates)
    
    newdata <- data.frame(xco2, ncvar_get(nc_data, "longitude")[ind], ncvar_get(nc_data, "latitude")[ind], dates)
    # print(newdata)
    colnames(newdata)[2:3] <- c("longitude", "latitude")
    dats2 <- rbind(dats2, newdata)
  }
  return(dats2); 
}



# Graphing Code 
library(leaflet)
mapPlotme <- function(dats2) {
    pal = colorNumeric(palette="YlOrRd", domain = quantile(dats2$xco2, 
                                                           probs = c(0, 0.99)
                                                           ))
    factory_icon <- makeIcon(
      iconUrl = "https://cdn4.iconfinder.com/data/icons/eldorado-finance/40/factory_2-512.png",
      iconWidth = 35, iconHeight = 35
    )
    m <- leaflet(width = "100%") %>% 
          setView(lng = -80.5, lat = 40.5, zoom=7) %>% 
          addProviderTiles(providers$Esri.NatGeoWorldMap) %>% 
          addCircleMarkers(data=dats2, group="obs", stroke=FALSE, fillOpacity = 0.5, color = pal(dats2$xco2), popup = dats2$dates) %>%
          addLegend("bottomright", pal = pal, values = dats2$xco2) %>% 
          addMarkers(-80.631731,40.531322, icon = factory_icon)
    m
}

pal <- colorNumeric(palette = "Blues", domain = dats2$xco2)


prelim_plot <- ggplot(dats, aes(x = longitude, y = latitude, colour = xco2)) + geom_point()

# dats4 is the full dataset. 
years <- data.frame(format(as_datetime(dats4$dates), format = "%d"))


# Plots - see code.Rhistory
ggplot(ddata, aes(x="", y=format(as_datetime(dats4$dates), format = "%Y"), fill=group)) + geom_bar(width = 1, stat = "identity")

gdist(lon.1 = dates4$longitude[i], lat.1 = dates4$latitude[i], lon.2 = -80.5, lat.2 = 40.5, units="km")

a <- lm(dats4$xco2 ~ as.double(format(as_datetime(dats4$dates), format = "%Y")) + format(as_datetime(dats4$dates), format = "%m")))
names(a$coefficients) <- c("Intercept", "Year", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

# Plant Distance
distlist <- c()
for (i in 1:nrow(dats4)) { distlist <- append(distlist, gdist(lon.1 = dats4$longitude[i], lat.1 = dats4$latitude[i], lon.2 = -80.631731, lat.2 = 40.531322, units="km")) }
dats4$dist <- distlist

# Pittsburgh Distance
distlist <- c()
for (i in 1:nrow(dats4)) { distlist <- append(distlist, gdist(lon.1 = dats4$longitude[i], lat.1 = dats4$latitude[i], lon.2 = -79.9959, lat.2 = 40.4406, units="km")) }
dats4$dist_pitts <- distlist

# Cleveland Distance
distlist <- c()
for (i in 1:nrow(dats4)) { distlist <- append(distlist, gdist(lon.1 = dats4$longitude[i], lat.1 = dats4$latitude[i], lon.2 = -81.6944, lat.2 = 41.4993, units="km")) }
dats4$dist_cleve <- distlist




