#BOHENG LIN
#EMPIRICAL PROJECT, DATA 200
#TUFTS UNIV, Dec 3, 2019
#-------------------------------------------

#PARTS OF THE SCRIPT HAS BEEN MODIFIED FOR PRIVACY AND SECURITY REASONS


#INSTALL PACKAGES
install.packages('readxl')
install.packages('janitor')
install.packages('dplyr')
install.packages('factoextra')
install.packages('clusteval')
install.packages('devtools')
install.packages('rgdal')
install.packages('sf')
install.packages('geosphere')
library(readxl)
library(janitor)
library(dplyr)
library(factoextra)
library(clusteval)
library(wkb)
library(sp)
library(rgdal)
library(rgeoda)
library(sf)
library(geosphere)

#IMPORTING DEMOGRAPHIC DATA
raw10 <- read_excel('2010.xlsx',col_names=TRUE,skip=1)
raw10 <- remove_empty(raw10,which=c("cols"))

raw11 <- read_excel('2011.xlsx',col_names=TRUE,skip=1)
raw11 <- remove_empty(raw11,which=c("cols"))

raw12 <- read_excel('2012.xlsx',col_names=TRUE,skip=1)
raw12 <- remove_empty(raw12,which=c("cols"))

raw13 <- read_excel('2013.xlsx',col_names=TRUE,skip=1)
raw13 <- remove_empty(raw13,which=c("cols"))

raw14 <- read_excel('2014.xlsx',col_names=TRUE,skip=1)
raw14 <- remove_empty(raw14,which=c("cols"))

raw15 <- read_excel('2015.xlsx',col_names=TRUE,skip=1)
raw15 <- remove_empty(raw15,which=c("cols"))

raw16 <- read_excel('2016.xlsx',col_names=TRUE,skip=1)
raw16 <- remove_empty(raw16,which=c("cols"))

raw17 <- read_excel('2017.xlsx',col_names=TRUE,skip=1)
raw17 <- remove_empty(raw17,which=c("cols"))

raw18 <- read_excel('2018.xlsx',col_names=TRUE,skip=1)
raw18 <- remove_empty(raw18,which=c("cols"))

#IMPORTING 911 DATA
raw_911<-read.csv('911 Ecometrics CT Longitudinal, Yearly, External.csv',header=TRUE)

#SYNCHRONIZE THE TRACT ID
raw10$Tract_ID <- raw10$`State Code`*1000000000 + raw10$`County Code`*1000000 + raw10$`Tract Code`*100
raw10 <- select(raw10, -c(1,2,3))

raw11$Tract_ID <- raw11$`State Code`*1000000000 + raw11$`County Code`*1000000 + raw11$`Tract Code`*100
raw11 <- select(raw11, -c(1,2,3))

raw12$Tract_ID <- raw12$`State Code`*1000000000 + raw12$`County Code`*1000000 + raw12$`Tract Code`*100
raw12 <- select(raw12, -c(1,2,3))

raw13$Tract_ID <- raw13$`State Code`*1000000000 + raw13$`County Code`*1000000 + raw13$`Tract Code`*100
raw13 <- select(raw13, -c(1,2,3))

raw14$Tract_ID <- raw14$`State Code`*1000000000 + raw14$`County Code`*1000000 + raw14$`Tract Code`*100
raw14 <- select(raw14, -c(1,2,3))

raw15$Tract_ID <- raw15$`State Code`*1000000000 + raw15$`County Code`*1000000 + raw15$`Tract Code`*100
raw15 <- select(raw15, -c(1,2,3))

raw16$Tract_ID <- raw16$`State Code`*1000000000 + raw16$`County Code`*1000000 + raw16$`Tract Code`*100
raw16 <- select(raw16, -c(1,2,3))

raw17$Tract_ID <- raw17$`State Code`*1000000000 + raw17$`County Code`*1000000 + raw17$`Tract Code`*100
raw17 <- select(raw17, -c(1,2,3))

raw18$Tract_ID <- raw18$`State Code`*1000000000 + raw18$`County Code`*1000000 + raw18$`Tract Code`*100
raw18 <- select(raw18, -c(1,2,3))

#SETTING UP SET X, AND SET V FOR CLUSTERING ANALYSIS
#X CONTAINS DEMOGRAPHIC VARIABLES
X10 <- select(raw10, c(3,7,8,10,11,12)) #10 and 11 will be devided by 7 to make it %
X11 <- select(raw11, c(3,7,8,10,11,12))
X12 <- select(raw12, c(3,7,8,10,11,12))
X13 <- select(raw13, c(3,7,8,10,11,12))
X14 <- select(raw14, c(3,7,8,10,11,12))
X15 <- select(raw15, c(3,7,8,10,11,12))
X16 <- select(raw16, c(3,7,8,10,11,12))
X17 <- select(raw17, c(3,7,8,10,11,12))
X18 <- select(raw18, c(3,7,8,10,11,12))

#REPLACING 'OWNER OCCUPIED' AND '1- TO 4- FAMILY UNITS' TO PERCENTAGE OF TOTAL POPULATION
X10$`Owner Occupied Units`<- X10$`Owner Occupied Units`*100/X10$`Tract Population`
X10$`1- to 4- Family Units` <- X10$`1- to 4- Family Units`*100/X10$`Tract Population`

X11$`Owner Occupied Units`<- X11$`Owner Occupied Units`*100/X11$`Tract Population`
X11$`1- to 4- Family Units` <- X11$`1- to 4- Family Units`*100/X11$`Tract Population`

X12$`Owner Occupied Units`<- X12$`Owner Occupied Units`*100/X12$`Tract Population`
X12$`1- to 4- Family Units` <- X12$`1- to 4- Family Units`*100/X12$`Tract Population`

X13$`Owner Occupied Units`<- X13$`Owner Occupied Units`*100/X13$`Tract Population`
X13$`1- to 4- Family Units` <- X13$`1- to 4- Family Units`*100/X13$`Tract Population`

X14$`Owner Occupied Units`<- X14$`Owner Occupied Units`*100/X14$`Tract Population`
X14$`1- to 4- Family Units` <- X14$`1- to 4- Family Units`*100/X14$`Tract Population`

X15$`Owner Occupied Units`<- X15$`Owner Occupied Units`*100/X15$`Tract Population`
X15$`1- to 4- Family Units` <- X15$`1- to 4- Family Units`*100/X15$`Tract Population`

X16$`Owner Occupied Units`<- X16$`Owner Occupied Units`*100/X16$`Tract Population`
X16$`1- to 4- Family Units` <- X16$`1- to 4- Family Units`*100/X16$`Tract Population`

X17$`Owner Occupied Units`<- X17$`Owner Occupied Units`*100/X17$`Tract Population`
X17$`1- to 4- Family Units` <- X17$`1- to 4- Family Units`*100/X17$`Tract Population`

X18$`Owner Occupied Units`<- X18$`Owner Occupied Units`*100/X18$`Tract Population`
X18$`1- to 4- Family Units` <- X18$`1- to 4- Family Units`*100/X18$`Tract Population`

#G CONTAINS GUN VIOLENCE VARIABLES
G10 <- na.omit(select(raw_911, c(2,11,29,1)))
G11 <- na.omit(select(raw_911, c(3,12,30,1)))
G12 <- na.omit(select(raw_911, c(4,13,31,1)))
G13 <- na.omit(select(raw_911, c(5,14,32,1)))
G14 <- na.omit(select(raw_911, c(6,15,33,1)))
G15 <- na.omit(select(raw_911, c(7,16,34,1)))
G16 <- na.omit(select(raw_911, c(8,17,35,1)))
G17 <- na.omit(select(raw_911, c(9,18,36,1)))
G18 <- na.omit(select(raw_911, c(10,19,37,1)))

#COMBING THE TWO
FULL10 <- inner_join(G10, X10, by = c("CT_ID_10" = "Tract_ID"))
FULL11 <- inner_join(G11, X11, by = c("CT_ID_10" = "Tract_ID"))
FULL12 <- inner_join(G12, X12, by = c("CT_ID_10" = "Tract_ID"))
FULL13 <- inner_join(G13, X13, by = c("CT_ID_10" = "Tract_ID"))
FULL14 <- inner_join(G14, X14, by = c("CT_ID_10" = "Tract_ID"))
FULL15 <- inner_join(G15, X15, by = c("CT_ID_10" = "Tract_ID"))
FULL16 <- inner_join(G16, X16, by = c("CT_ID_10" = "Tract_ID"))
FULL17 <- inner_join(G17, X17, by = c("CT_ID_10" = "Tract_ID"))
FULL18 <- inner_join(G18, X18, by = c("CT_ID_10" = "Tract_ID"))

#DATA CLEANNING, REMOVING TRACT WITHOUT INCOME
clean10 <- FULL10[!(FULL10$`Tract Median Family Income %`==0 & FULL10$`Tract Population`==0),]
clean11 <- FULL11[!(FULL11$`Tract Median Family Income %`==0& FULL11$`Tract Population`==0),]
clean12 <- FULL12[!(FULL12$`Tract Median Family Income %`==0& FULL12$`Tract Population`==0),]
clean13 <- FULL13[!(FULL13$`Tract Median Family Income %`==0& FULL13$`Tract Population`==0),]
clean14 <- FULL14[!(FULL14$`Tract Median Family Income %`==0& FULL14$`Tract Population`==0),]
clean15 <- FULL15[!(FULL15$`Tract Median Family Income %`==0& FULL15$`Tract Population`==0),]
clean16 <- FULL16[!(FULL16$`Tract Median Family Income %`==0& FULL16$`Tract Population`==0),]
clean17 <- FULL17[!(FULL17$`Tract Median Family Income %`==0& FULL17$`Tract Population`==0),]
clean18 <- FULL18[!(FULL18$`Tract Median Family Income %`==0& FULL18$`Tract Population`==0),]

#ADD A YEAR VARIABLE TO THE DATA FRAME
clean10$year <- 2010
clean11$year <- 2011
clean12$year <- 2012
clean13$year <- 2013
clean14$year <- 2014
clean15$year <- 2015
clean16$year <- 2016
clean17$year <- 2017
clean18$year <- 2018

#SYNCHRONIZE THE COLUMN NAMES
colnames(clean10) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean11) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean12) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean13) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean14) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean15) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean16) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean17) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")
colnames(clean18) <- c("Guns", "PrivateConflict","Violence","CT_ID","MedianIncome%","Population","Minority%","OwnerOccupied%","1- to 4- Family Units%","Year")

#SUMMARY STATISTICS OF THE ENTIRE DATA SET
CleanFull <-rbind(clean10,rbind(clean11,rbind(clean12,rbind(clean13,rbind(clean14,rbind(clean15,rbind(clean16,rbind(clean17,clean18,by=c("CT_ID")),
                                                                                                      by=c("CT_ID")),
                                                                                        by=c("CT_ID")),
                                                                          by=c("CT_ID")),
                                                            by=c("CT_ID")),
                                              by=c("CT_ID")),
                                by=c("CT_ID")),
                  by=c("CT_ID"))

#WHILE MERGING THE DATA, R TREATS EACH VALUE AS CHARACTER, NOW CONVERTING TO NUMERIC
CleanFull <- mutate_all(CleanFull, function(x) as.numeric(as.character(x)))
CleanFull <- CleanFull[!(CleanFull$Year==0),]
#WHILE SOME VALUES ARE TRUE 0, CONVERSION WILL COERCE THEM TO NAS, NOW CHANGING THEM BACK TO 0

CleanFull$`MedianIncome%`[CleanFull$`MedianIncome%` == 0 ]<- NA
CleanFull$`MedianIncome%` <- ifelse(is.na(CleanFull$`MedianIncome%`),
                                    mean(CleanFull$`MedianIncome%`, na.rm=TRUE),
                                    CleanFull$`MedianIncome%`)
#CleanFull[is.na(CleanFull)] <- 0
#CleanFull[CleanFull$`MedianIncome%`==0] <- mean(CleanFull$`MedianIncome%`)
summary(CleanFull)


#   USING KMEANS TO CLUSTER THE DATA
#LOOK FOR OPTIMAL NUMBER OF CLUSTERS BASED ON DEMOGRAPHIC FEATURES
fviz_nbclust(select(clean10,c(5,6,7,8,9,10)),kmeans,method='wss') +geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean11,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean12,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean13,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean14,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean15,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean16,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean17,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3
fviz_nbclust(select(clean18,c(5,6,7,8,9,10)),kmeans,method='wss')+geom_vline(xintercept=3,linetype=2)
  #optimal = 3



#NOW CLUSTER THE DEMOGRAPHICS AND GUNS INTO 3 CLUSTERS AND FIND THE SIMILARITY FOR YEAR 10
XL10 <- kmeans(select(clean10,c(5,6,7,8,9,10)),3,algorithm = 'Lloyd')
clean10 <- cbind(clean10,cluster=XL10$cluster)
colnames(clean10)[11] <- 'XL'
GL10 <- kmeans(select(clean10,c(1,2,3)),3,algorithm='Lloyd')
clean10 <- cbind(clean10,cluster=GL10$cluster)
colnames(clean10)[12] <- 'GL'
SIM10 <- cluster_similarity(clean10$XL,clean10$GL,similarity = 'rand', method = 'independence')

#REPEAT FOR YEARS 11 THROUGH 18
XL11 <- kmeans(select(clean11,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean11 <- cbind(clean11,cluster=XL11$cluster)
colnames(clean11)[11] <- 'XL'
GL11 <- kmeans(select(clean11,c(1,2,3)),3,algorithm='Lloyd')
clean11 <- cbind(clean11,cluster=GL11$cluster)
colnames(clean11)[12] <- 'GL'
SIM11 <- cluster_similarity(clean11$XL,clean11$GL,similarity = 'rand', method = 'independence')

XL12 <- kmeans(select(clean12,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean12 <- cbind(clean12,cluster=XL12$cluster)
colnames(clean12)[11] <- 'XL'
GL12 <- kmeans(select(clean12,c(1,2,3)),3,algorithm='Lloyd')
clean12 <- cbind(clean12,cluster=GL12$cluster)
colnames(clean12)[12] <- 'GL'
SIM12 <- cluster_similarity(clean12$XL,clean12$GL,similarity = 'rand', method = 'independence')

XL13 <- kmeans(select(clean13,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean13 <- cbind(clean13,cluster=XL13$cluster)
colnames(clean13)[11] <- 'XL'
GL13 <- kmeans(select(clean13,c(1,2,3)),3,algorithm='Lloyd')
clean13 <- cbind(clean13,cluster=GL13$cluster)
colnames(clean13)[12] <- 'GL'
SIM13 <- cluster_similarity(clean13$XL,clean13$GL,similarity = 'rand', method = 'independence')

XL14 <- kmeans(select(clean14,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean14 <- cbind(clean14,cluster=XL14$cluster)
colnames(clean14)[11] <- 'XL'
GL14 <- kmeans(select(clean14,c(1,2,3)),3,algorithm='Lloyd')
clean14 <- cbind(clean14,cluster=GL14$cluster)
colnames(clean14)[12] <- 'GL'
SIM14 <- cluster_similarity(clean14$XL,clean14$GL,similarity = 'rand', method = 'independence')

XL15 <- kmeans(select(clean15,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean15 <- cbind(clean15,cluster=XL15$cluster)
colnames(clean15)[11] <- 'XL'
GL15 <- kmeans(select(clean15,c(1,2,3)),3,algorithm='Lloyd')
clean15 <- cbind(clean15,cluster=GL15$cluster)
colnames(clean15)[12] <- 'GL'
SIM15 <- cluster_similarity(clean15$XL,clean15$GL,similarity = 'rand', method = 'independence')

XL16 <- kmeans(select(clean16,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean16 <- cbind(clean16,cluster=XL16$cluster)
colnames(clean16)[11] <- 'XL'
GL16 <- kmeans(select(clean16,c(1,2,3)),3,algorithm='Lloyd')
clean16 <- cbind(clean16,cluster=GL16$cluster)
colnames(clean16)[12] <- 'GL'
SIM16 <- cluster_similarity(clean16$XL,clean16$GL,similarity = 'rand', method = 'independence')

XL17 <- kmeans(select(clean17,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean17 <- cbind(clean17,cluster=XL17$cluster)
colnames(clean17)[11] <- 'XL'
GL17 <- kmeans(select(clean17,c(1,2,3)),3,algorithm='Lloyd')
clean17 <- cbind(clean17,cluster=GL17$cluster)
colnames(clean17)[12] <- 'GL'
SIM17 <- cluster_similarity(clean17$XL,clean17$GL,similarity = 'rand', method = 'independence')

XL18 <- kmeans(select(clean18,c(5,6,7,8,9,10)),3,algorithm='Lloyd')
clean18 <- cbind(clean18,cluster=XL18$cluster)
colnames(clean18)[11] <- 'XL'
GL18 <- kmeans(select(clean18,c(1,2,3)),3,algorithm='Lloyd')
clean18 <- cbind(clean18,cluster=GL18$cluster)
colnames(clean18)[12] <- 'GL'
SIM18 <- cluster_similarity(clean18$XL,clean18$GL,similarity = 'rand', method = 'independence')

#TEST OUT IF SIM IS SIGNIFICANTLY GREATER THAN 0.5
SIM <- c(SIM10, SIM11, SIM12, SIM13, SIM14, SIM15, SIM16, SIM17, SIM18)
mean(SIM)
#MOST OF THE CLUSTERING HAVE MORE THAN 50% OF SIMILARITY. 


#REGRESSION ANALYSIS
#USING YEAR 2010, 2012, 2014, 2016, 2018 AS SAMPLE DATA TO BUILD REGRESSION MODEL - TRAINING DATA
#USING YEAR 2011, 2013, 2015, 2017 AS TESTING/VALIDATION SET

#SET UP A VARIABLE CALLED FIREVIO,WHICH IS THE CASES LABELLED GUN AND VIOLENCE, OR GUN AND PRIVATE CONFLICT

clean10$FireVio <- clean10$Guns * clean10$Violence * clean10$PrivateConflict/100


clean11$FireVio <- clean11$Guns * clean11$Violence * clean11$PrivateConflict/100

clean12$FireVio <- clean12$Guns * clean12$Violence * clean12$PrivateConflict/100

clean13$FireVio <- clean13$Guns * clean13$Violence * clean13$PrivateConflict/100

clean14$FireVio <- clean14$Guns * clean14$Violence * clean14$PrivateConflict/100

clean15$FireVio <- clean15$Guns * clean15$Violence * clean15$PrivateConflict/100

clean16$FireVio <- clean16$Guns * clean16$Violence * clean16$PrivateConflict/100

clean17$FireVio <- clean17$Guns * clean17$Violence * clean17$PrivateConflict/100

clean18$FireVio <- clean18$Guns * clean18$Violence * clean18$PrivateConflict/100

#UPDATE THE CLEANFULL DATA SET FOR REGRESSION ANALYSIS
CleanFullFireVio <-rbind(clean10,rbind(clean11,rbind(clean12,rbind(clean13,rbind(clean14,rbind(clean15,rbind(clean16,rbind(clean17,clean18,by=c("CT_ID")),
                                                                                                      by=c("CT_ID")),
                                                                                        by=c("CT_ID")),
                                                                          by=c("CT_ID")),
                                                            by=c("CT_ID")),
                                              by=c("CT_ID")),
                                by=c("CT_ID")),
                  by=c("CT_ID"))

#RUN THE REGRESSION
#AS IT IS EXPECTED THAT SOME USEFUL DEMOGRAPHIC VARIABLES ARE OMITTED FROM THE DATA SET, RIDGE REGRESSION IS USED
#SO THAT LARGE VALUES WILL NOT BE PENALIZED. 
CleanFullFireVio <- mutate_all(CleanFullFireVio,function(x) as.numeric(x))
CleanFullFireVio$`MedianIncome%`[CleanFullFireVio$`MedianIncome%` == 0 ]<- NA
CleanFullFireVio$`MedianIncome%` <- ifelse(is.na(CleanFullFireVio$`MedianIncome%`),
                                    mean(CleanFullFireVio$`MedianIncome%`, na.rm=TRUE),
                                    CleanFullFireVio$`MedianIncome%`)
CleanFullFireVio$Population<-CleanFullFireVio$Population/1000

lmod <- lm(FireVio ~ `Minority%` + `MedianIncome%` + Population
           +`OwnerOccupied%`+`1- to 4- Family Units%`+ Year
           +I(`Minority%`**2) +I(`OwnerOccupied%`**2) + I(Population**2)
           +I(`Minority%`*`MedianIncome%`), data=CleanFullFireVio)
summary(lmod)
plot(lmod)
#=====================================
#plot each variables distribution

plot(CleanFullFireVio$Guns,CleanFullFireVio$PrivateConflict,main="How firearm reports reveal safety",xlab="Gun reports",ylab="Number of cases")
points(CleanFullFireVio$Guns,CleanFullFireVio$Violence,col='red')


#NEED A PLOT FOR DEMOGRAPHIC DATA
plot(CleanFullFireVio$`MedianIncome%`,CleanFullFireVio$`OwnerOccupied%`,main="Profile of different labels",xlab="Median Income",ylab="%")
plot(CleanFullFireVio$`MedianIncome%`,CleanFullFireVio$`Minority%`,main="Profile of different labels",xlab="Median Income",ylab="%",col='red')
points(CleanFullFireVio$`MedianIncome%`,CleanFullFireVio$`OwnerOccupied%`)

#Export
library(readr)
readr::write_csv(CleanFullFireVio,"CleanFullFireVio.csv")
