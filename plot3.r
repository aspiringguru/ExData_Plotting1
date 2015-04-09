## load required libraries
library(lubridate)
library(downloader)

## download file & unzip. 
download("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", dest="dataset.zip", mode="wb") 
unzip ("dataset.zip") ## creates 'household_power_consumption.txt' in current directory.
## use first 1000 rows to estimate size of data as nominated in the assignment
top.size <- object.size(read.csv("household_power_consumption.txt", sep=";", nrow=1000))
lines <- as.numeric(gsub("[^0-9]", "", system("wc -l household_power_consumption.txt", intern=T)))
size.estimate <- lines / 1000 * top.size
size.estimate
## 270945945.6 bytes
data <- read.csv("household_power_consumption.txt", sep=";", stringsAsFactors=FALSE)

## clean up data for analysis

## convert the Date column from character to Date format.
data$Date <- as.Date(data$Date,  "%d/%m/%Y")
## combine Date & Time into one field 
## because conversion from character to POSIX format requires full date & time in one field.
data$dateTime <- paste(data$Date, data$Time)
## now convert from character class to POSIX format
data$dateTime <- strptime(data$dateTime, "%Y-%m-%d %H:%M:%S")
## NB: assignment instructs to only use data from the dates 2007-02-01 and 2007-02-02. 
## subset based on date
data <- subset(data, Date == as.Date("2007-02-01",  "%Y-%m-%d") | Date == as.Date("2007-02-02",  "%Y-%m-%d"))
## convert columns from character class to numeric
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)

## plot3 
png("plot3.png",width=480,height=480,unit="px",pointsize=12,bg="transparent")

plot(data$dateTime , data$Sub_metering_1, type="l", xlab = "", ylab="Energy sub metering")
lines(data$dateTime , data$Sub_metering_2, col="red")
lines(data$dateTime , data$Sub_metering_3, col = "blue")
legend("topright", 
    c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), ## assign labels to legend
    lty=c(1,1,1),                 ## assign line type
	lwd = c(3, 3, 3),            ## assign line width
	col=c("black","red", "blue"), ## gives the legend colours
    )

dev.off()
