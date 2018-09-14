library(xkcd)
library(gridExtra)
   volunteers <- data.frame(year=c(2007:2011), 
                            number=c(56470, 56998, 59686, 61783, 64251))
   data <- volunteers
   data$xmin <- data$year - 0.1
   data$xmax <- data$year + 0.1
   data$ymin <- 50000
   data$ymax <- data$number
   xrange <- range(min(data$xmin)-0.1, max(data$xmax) + 0.1)
   yrange <- range(min(data$ymin)+500, max(data$ymax) + 1000)
   
   mapping <- aes(xmin=xmin,ymin=ymin,xmax=xmax,ymax=ymax)
   p1 <- ggplot() + xkcdrect(mapping,data) + 
     xkcdaxis(xrange,yrange) +
     xlab("") + ylab("")
   
   
   p2 <- ggplot(volunteers,aes(x=year,y=number)) + geom_bar(stat="identity") + ylim()
   png("images/xkcd-example.png",width=800,height=400)
   grid.arrange(p1,p2,ncol=2) 
   dev.off()
