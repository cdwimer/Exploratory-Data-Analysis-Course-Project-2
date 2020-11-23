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

# 
coal <- grepl("coal", SCC$Short.Name, ignore.case=TRUE)
subsetSCC <- SCC[coal, ]
NEISCC <- merge(NEI, subsetSCC, by="SCC")
totalEmissions <- tapply(NEISCC$Emissions, NEISCC$year, sum)

# plotting
png("plot4.png")

barplot(totalEmissions, xlab = "Year", ylab = "Total Emissions (tons)", main = "Total Coal-Combustion Related PM2.5 Emmissions per Year")

dev.off()

