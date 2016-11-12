require(ggplot2)
centers <- read.table('center.csv',sep=",",stringsAsFactors=FALSE)
dframe <- read.table('result.csv',sep=",",stringsAsFactors=FALSE)
dframe<-data.frame(dframe$V1,dframe$V2,dframe$V3,as.character(dframe$V4))
names(dframe)<-c('V1','V2','V3','V4')
ggplot(dframe,aes(x=V1,y=V2,col=V4))+geom_point()+geom_point(data=centers,aes(x=V1,y=V2,col=V3))



message("Press Return To Continue")
invisible(readLines("stdin", n=1))
