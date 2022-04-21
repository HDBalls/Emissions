#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland fips == "24510" from 1999 to 2008? 

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

# Convert and sum the Emissions column with the Baltimore filter
sum_PM25 <- PM25[fips=='24510', lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

#Check the values
View(sum_PM25)

#Generate the base plot
plot(sum_PM25,"o",col="blue",xlab = "Years", ylab = "Emissions", main = "Baltimore Emissions: Selected Years")

#Export the png file
dev.copy(png, file = "Plot2.png")

#Close the device after every generation of the graphs
dev.off()
