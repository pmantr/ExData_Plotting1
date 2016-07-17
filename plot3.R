###clear screen
cat("\014")  

###track the timer
ptm <- proc.time()       

###read header
header <- read.table("household_power_consumption.txt", 
                     nrows = 1, header = 
                             FALSE, sep =';', 
                     stringsAsFactors = FALSE)               
###:)
warning("Keep Calm and Enjoy Data Science...")          

###find the position of the first exact date occurance, and substract 2..
###(one for header and one in order not to miss the first line of the set that 
###we are interested in)
rows2skip<-grep("\\b1/2/2007\\b", 
                readLines("household_power_consumption.txt"))[1]-2 

###find the number of records we need for the two days.
date1length<-length(grep("\\b1/2/2007\\b", 
                         readLines("household_power_consumption.txt")))
date2length<-length(grep("\\b2/2/2007\\b", 
                         readLines("household_power_consumption.txt")))
rowsNeeded <- date1length + date2length

###read like the wind.. only the rows we need, excluding all others
data<-read.table("household_power_consumption.txt",skip=rows2skip,
                 nrows=rowsNeeded, sep=";", 
                 header = TRUE, 
                 comment.char = "",
                 na.strings = "?")

###The previous read, has no header.. add it.
colnames(data)<-unlist(header)

###check time. It should be about 3 times faster than loading the whole file 
###and then subsetting
proc.time() - ptm

###create the timestamp column and add it to our dataset...
timestamp<-paste(strptime(data$Date,format = "%d/%m/%Y"), data$Time)
data$timestamp<-timestamp

###prepare the parameters and plot for metering 1...
par(mar=c(4,4,4,2))
plot(as.POSIXlt(temp$timestamp),
     temp$Sub_metering_1, 
     type = "l",
     xlab = "",
     ylab="Global Active Power (kilowatts)")

### Add elements (lines) for 2 and 3
lines(as.POSIXlt(temp$timestamp),
      temp$Sub_metering_2, 
      type = "l",
      xlab = "",
      ylab="Global Active Power (kilowatts)",
      col="red")
lines(as.POSIXlt(temp$timestamp),
      temp$Sub_metering_3, 
      type = "l",
      xlab = "",
      ylab="Global Active Power (kilowatts)",
      col="blue")

###create the legend
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       lwd=c(3,3,3), 
       col=c("black","red","blue"))

###create png file on disk
dev.copy(png,filename="plot3.png")
###close device
dev.off ()
