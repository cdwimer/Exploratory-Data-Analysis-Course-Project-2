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

# subset city and vehicles and aggregate
baltimore <- subset(NEI, fips == "24510")
losAngeles <- subset(NEI, fips == "06037")
vehicles <- grepl("vehicle", SCC$Short.Name, ignore.case=TRUE)
subsetSCC <- SCC[vehicles, ]

NEISCCbaltimore <- merge(baltimore, subsetSCC, by="SCC")
NEISCCbaltimore$city <- "Baltimore City, MD"
NEISCClosAngeles <- merge(losAngeles, subsetSCC, by="SCC")
NEISCClosAngeles$city <- "Los Angeles County, CA"
NEISCC <- rbind(NEISCCbaltimore, NEISCClosAngeles)
totalEmissions <- aggregate(Emissions ~ year + city, NEISCC, sum)

# plotting
library(ggplot2)

graph <- ggplot(totalEmissions, aes(year, Emissions, color = city))
graph + geom_line(linetype = "dashed") + 
    geom_point() +
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
    labs(title = "Total Motor-Vehicle PM2.5 Emmissions per Year", subtitle = "Baltimore City, MD Versus Los Angeles County, CA", x = "Year", y = "Total Emissions (tons)", color = "Type of Source") + 
    theme_bw() + 
    theme(legend.position = "bottom")

ggsave("plot6.png", width = 6, height = 4)