
setwd("2020-12-19 P12-FakeNames/2. Prepared Data/")

getwd()

d <- read.csv("FakeNamesUK.csv",
              stringsAsFactors = FALSE)
dim(d)
tail(d)
# there was and error during loading the original file

# Warning message:
# In scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  :
#          EOF within quoted string

#that happend because of the unclosed quoted string
# to fix that I opened the csv in Notepad++, found the unclosed quotas with regex (^|\.)[^"]*\K"(?=[^"]*(\.|$)) and closed the string


dim(d)
tail(d)

#There was several errors with nrows not matching
# using that I found the row number to look into

lookup <- (1:96705 - as.numeric(d$Number)) * as.numeric(d$Number)
head(which(lookup!=0))

d[c(80588),"Number"]

# There was a row with too many commas
# not opened quotas
# Quota in a password


#looking for n/as
nrow(d[is.na(d$BloodType),])
nrow(d[is.na(d$Kilograms),])
nrow(d[is.na(d$Centimeters),])
d[is.na(d$Centimeters),c("Number")]

#removing rows with nas
d <- d[complete.cases(d[ , c("BloodType","Kilograms","Centimeters")]),]

dim(d)


#looking for empty strings
nrow(d[d$BloodType == "",])
nrow(d[d$Kilograms == "",])
nrow(d[d$Centimeters == "",])

# removing records with empty Kilograms
d <- d[d$Kilograms != "",]

dim(d)


#checking if numbers are numbers
nrow(d[is.numeric(d$Kilograms),])
nrow(d[is.numeric(d$Centimeters),])

d[is.na(as.numeric(d$Kilograms)),"Number"]
d[d$Number == 9346 ,]
nrow(d[d$Kilograms == "#REF!",])

#removing wrong values
dim(d)
d <- d[d$Kilograms != "#REF!",]

#switching Kilos to number
d$Kilograms <- as.numeric(d$Kilograms)
dim(d)


write.csv(d,"FakeNamesUK_prepared.csv")

#showing values
hist(d$Kilograms)
hist(d$Centimeters)
#too much data
#plot(d$Kilograms, d$Centimeters)

cor(d$Kilograms,d$Centimeters)

#showing top weight data
t <- head(d[order(d$Kilograms, decreasing=TRUE),c("BloodType","Kilograms","Centimeters")], n=100)

plot(t$Kilograms,t$Centimeters)
points(t$Kilograms,t$Centimeters)
