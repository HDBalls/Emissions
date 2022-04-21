#Question: Have total emissions from PM2.5 decreased in the United States from 
#1999 to 2008?

#Install the packages
destination <- getwd()
install.packages("data.table")

#Load the libraries
library("data.table")

#Download the file and ensure it is put in your selected working directory
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = paste(destination, "Emissions.zip", sep = "/"))
unzip(zipfile = "Emissions.zip")

#Read the files
PM25 <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Convert and sum the Emissions column
sum_PM25 <- PM25[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

#Check the values
View(sum_PM25)

#Generate the base plot
barplot(sum_PM25[, Emissions]
        , names = sum_PM25[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "US Emissions: Selected Years")

#Export the png file
dev.copy(png, file = "Plot1.png")

#Close the device after every generation of the graphs
dev.off()
