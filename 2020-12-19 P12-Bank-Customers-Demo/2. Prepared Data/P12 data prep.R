getwd()



d <- read.csv("P12-Bank-Customers-Demo.csv")
d

#prep
#Reformat Date
d$Date.Joined <- as.Date(d$Date.Joined, "%B %d, %Y")

d

#fix Balance format
d$Balance <- sub("$","",d$Balance,fixed=TRUE)
d$Balance <- sub(",","",d$Balance,fixed=TRUE)
d$Balance <- as.numeric(d$Balance)
#check Customer ID
is.numeric(d$Customer.ID)

#rename columns
colnames(d) <- sub(".","_",colnames(d), fixed=TRUE)

summary(d)
str(d)

write.csv(d,"P12-Bank-Customers-Demo_prepared.csv")

#loading to db
library(RMySQL)

db = dbConnect(MySQL(), user='my_db_user', password='my_password', dbname='my_db_name', host='localhost')

dbWriteTable(db, "p12_data_prep", d)

dbReadTable(db, "p12_data_prep")

sql <- "ALTER TABLE p12_data_prep CHANGE COLUMN Date_Joined Date_Joined DATE NULL DEFAULT NULL"
rs1 <- dbSendQuery(db, sql)
dbClearResult(rs1)

#checking load
fromdb <- dbReadTable(db, "p12_data_prep")
if (nrow(fromdb) != nrow(d)) {
  print("Row number is not Matching !!")
}
if (sum(d$Balance) != sum(fromdb$Balance)) {
  print("Balance is not matching")
}


dbDisconnect(db)

















