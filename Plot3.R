#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 

#Install the packages
destination <- getwd()
install.packages("data.table")
install.packages("ggplot2")
install.packages("dplyr")

#Load the libraries
library("data.table")
library("ggplot2")
library("dplyr")

#Download the file and ensure it is put in your selected working directory
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = paste(destination, "Emissions.zip", sep = "/"))
unzip(zipfile = "Emissions.zip")

#Read the files while filtering with Baltimore
PM25_Baltimore <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))%>%
  filter(fips=="24510")

#Generate the base plot
ggplot(PM25_Baltimore,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="Year", y=expression("Total Emissions (Tonnes)")) + 
  labs(title=expression("Emissions in Baltimore for 1999,2002,2005 & 2008 by Source"))

#Export the png file
dev.copy(png, file = "Plot3.png")

#Close the device after every generation of the graphs
dev.off()
