# read data
filename <- "exdata_data_NEI_data.zip"

if(!file.exists(filename)){
    fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileurl, "exdata_data_NEI_data.zip")
}

if(!file.exists("Source_Classification_Code.rds") | !file.exists("Source_Classification_Code.rds")){
    unzip(filename)
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

baltimore <- subset(NEI, fips == "24510")

# sum of emissions/year
totalEmissions <- tapply(baltimore$Emissions, baltimore$year, sum)

# plot data
png("plot2.png")

barplot(totalEmissions, xlab = "Year", ylab = "Total Emissions (tons)", main = "Total PM2.5 Emissions Per Year in Baltimore, MD")

dev.off()