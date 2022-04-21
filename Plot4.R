#Across the United States, how have emissions from coal combustion-related 
#sources changed from 1999–2008?

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
PM25 <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))

# Extract data specific to coal
combustion_related <- grepl("combustion", SCC[, SCC.Level.One], ignore.case=TRUE)
coal_related <- grepl("coal", SCC[, SCC.Level.Four], ignore.case=TRUE) 
combustion_SCC <- SCC[combustion_related & coal_related, SCC]
combustion_PM25 <- PM25[PM25[,SCC] %in% combustion_SCC]

#Generate the base plot
ggplot(combustion_PM25,aes(x = factor(year),y = Emissions/100000), fill = factor(year)) +
  geom_bar(stat="identity", fill ="blue") + 
  #scale_fill_manual(values = c("red", "grey", "green", "blue")) +
  labs(x="Year", y=expression("Total PM Emissions (Kilo Tonnes)")) + 
  labs(title=expression("Coal Combustion-Related Sources Emissions Across the US"))

#Export the png file
dev.copy(png, file = "Plot4.png")

#Close the device after every generation of the graphs
dev.off()
