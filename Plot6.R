#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. 
#Which city has seen greater changes over time in motor vehicle emissions?

#Install the packages
destination <- getwd()
install.packages("data.table")
install.packages("ggplot2")


#Load the libraries
library("data.table")
library("ggplot2")


#Download the file and ensure it is put in your selected working directory
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = paste(destination, "Emissions.zip", sep = "/"))
unzip(zipfile = "Emissions.zip")

#Read the files
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))

PM25 <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Extract data specific to vehicles
cond_veh <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
SCC_vehicles <- SCC[cond_veh, SCC]
PM25_vehicles <- PM25[PM25[, SCC] %in% SCC_vehicles,]

# Extract data specific to cities
#Baltimore
vehicles_Baltimore_PM25 <- PM25_vehicles[fips == "24510",]
vehicles_Baltimore_PM25[, city := c("Baltimore City")]
#Los Angeles
vehicles_LA_PM25 <- PM25_vehicles[fips == "06037",]
vehicles_LA_PM25[, city := c("Los Angeles")]

# Merge the datasets
all_vehicles <- rbind(vehicles_LA_PM25,vehicles_Baltimore_PM25)

#Generate the base plot
ggplot(all_vehicles, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="Year", y="Total Emissions (Kilo Tonnes)") + 
  labs(title=("Motor Vehicle Source Emissions in Baltimore & LA for Various Years"))

#Export the png file
dev.copy(png, file = "Plot6.png")

#Close the device after every generation of the graphs
dev.off()
