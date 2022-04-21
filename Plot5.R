#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#Install the packages
destination <- getwd()
install.packages("data.table")
install.packages("ggplot2")
install.packages("dplyr")


#Load the libraries
library("data.table")
library("ggplot2")
library(dplyr)


#Download the file and ensure it is put in your selected working directory
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = paste(destination, "Emissions.zip", sep = "/"))
unzip(zipfile = "Emissions.zip")

#Read the files
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))

PM25_Baltimore <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))%>%
  filter(fips=="24510")


# Extract data specific to vehicles
# Gather the subset of the NEI data which corresponds to vehicles
SCC_vehicles <- SCC[grepl("vehicle", SCC.Level.Two, ignore.case=TRUE), SCC]
PM25_vehicles <- PM25_Baltimore[PM25_Baltimore[, SCC] %in% SCC_vehicles,]


#Generate the base plot
ggplot(PM25_Baltimore,aes(x = factor(year),y = Emissions/100000), fill = factor(year)) +
  geom_bar(stat="identity", fill = "blue") +
  labs(x="Year", y=expression("Emissions (Kilo Tonnes)")) + 
  labs(title=expression("Motor Vehicle Source Emissions in Baltimore for various years"))

#Export the png file
dev.copy(png, file = "Plot5.png")

#Close the device after every generation of the graphs
dev.off()
