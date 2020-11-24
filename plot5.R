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

# subset vehicle and sum emissions
baltimore <- subset(NEI, fips == "24510")
vehicles <- grepl("vehicle", SCC$Short.Name, ignore.case=TRUE)
subsetSCC <- SCC[vehicles, ]
NEISCC <- merge(baltimore, subsetSCC, by="SCC")
totalEmissions <- tapply(NEISCC$Emissions, NEISCC$year, sum)

# plotting
png("plot5.png")

barplot(totalEmissions, xlab = "Year", ylab = "Total Emissions (tons)", main = "Total Motor-Vehicle PM2.5 Emmissions \nper Year in Baltimore, MD")

dev.off()