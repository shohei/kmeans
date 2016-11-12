require(ggplot2)
iris=iris(data)
centers=data.frame(x=c(5.87413793103448,5.0078431372549,6.8390243902439),y=c(4.39310344827586,1.4921568627451,5.6780487804878))
ggplot(iris,aes(x=Sepal.Length,y=Petal.Length,col=Species))+geom_point()+geom_point(data=centers,aes(x=x,y=y,col='red'))

