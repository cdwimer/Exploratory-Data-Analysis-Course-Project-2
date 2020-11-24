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

# sum of emissions/year/type
baltimore <- subset(NEI, fips == "24510")
totalEmissions <- aggregate(Emissions ~ year + type, baltimore, sum)

# plot data
library(ggplot2)


graph <- ggplot(totalEmissions, aes(year, Emissions, color = type))
graph + geom_line(linetype = "dashed") + 
    geom_point() + 
    scale_x_continuous(breaks=c(1999, 2002, 2005, 2008)) +
    labs(title = "Type of Total PM2.5 Emissions per Year in Baltimore, MD", x = "Year", y = "Total Emissions (tons)", color = "Type of Source") + 
    theme_bw() + 
    theme(legend.position = "bottom")

ggsave("plot3.png", width = 6, height = 4)