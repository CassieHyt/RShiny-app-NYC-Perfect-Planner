Deli<-na.omit(read.csv("../data/Deli.csv",header=T))
Market<-na.omit(read.csv("../data/Market.csv",header=T))
Gallery<-na.omit(read.csv("../data/Gallery.csv",header=T))
Library<-na.omit(read.csv("../data/Library.csv",header=T))
Museum<-na.omit(read.csv("../data/Museum.csv",header=T))
Resterant<-na.omit(read.csv("../data/NCY resterant.csv",header=T))
Theater<-na.omit(read.csv("../data/Theater.csv",header=T))
data<-list(Deli=Deli,Market=Market,Gallery=Gallery,Library=Library,Museum=Museum,Resterant=Resterant,Theater=Theater)

