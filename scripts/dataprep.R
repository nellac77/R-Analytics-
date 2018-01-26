

getwd()

setwd("C:/Users/calle/Documents/R-Analytics/datasets/section2/")

#Basic Import: fin <- read.csv("Future-500.csv")
fin <- read.csv("Future-500.csv", na.strings = c(""))  # import and replace all empty strings with NA
head(fin)
tail(fin)
str(fin)
summary(fin)

# What are factors?
# Facotrs are a categorical (can be segmented) variable in R.
# Note that R deals with the variables (factors) by assigned them numbers.
#Also note that in the current dataset, ID and Inception are not factors;
# rather, they are int's by R's take. We don't want to run stats on these
# like R is in summary(fin), so it will be good if we tell R to make 
# these factors. Alos, Revune has an issue has well, and Growth! What do
# you think we should do?

# Changing from non-factor to factor
fin$ID <- factor(fin$ID) # ID is obviously a record ID #, so easier to consider as a factor.
summary(fin)
str(fin) # check it out

fin$Inception <- factor(fin$Inception) # The year the company started, so easier as a factor.
summary(fin)
str(fin) # Check it out

# Factor-Variable Trap (FVT)
# When try to convert a column/variable from a factor to a non-factor...

# For characters into numerics
a <- c("12", "13", "14", "12", "12")
a
typeof(a)
b <- as.numeric(a)
b
typeof(b)

# Converting into Numerics For Factors
z <- factor(c("12", "13", "14", "12", "12"))
z
typeof(z)
y <- as.numeric(z)
y #Picked up the actual factorization of "z" in above line...
typeof(y) 
#------- Correct way:
x <- as.numeric(as.character(z)) # first convert into character, then convert to numeric. Voila.
x
typeof(x)

# FVT Example
head(fin)
str(fin)
# Need to convert Revenue and Profit into non-factors


### NOTE THE FOLLOWING IS AN EXAMPLE TO ILLUSTRATE 
### THE DANGERS BEHIND THE FVT. UNDERTSNAD THAT
### THE LINES LABELED "#DANGEROUS!!!" OVERWRITE THE
### ORIGINAL DATA IN CONVERTING IT AND IT IS LOST.
### THIS IS NOT COOL!

# Profit...
# fin$Profit <- factor(fin$Profit)  #DANGEROUS!!!

head(fin)
str(fin)

summary(fin)

# fin$Profit <- as.numeric(fin$Profit)  #DANGEROUS!!!
str(fin)

head(fin)

# sub() and gsub()
?sub
fin$Expenses <- gsub(" Dollars", "", fin$Expenses) # converting to character for us here
fin$Expenses <- gsub(",", "", fin$Expenses)
head(fin)
str(fin)

fin$Revenue <- gsub("\\$","", fin$Revenue) # S is a special char in R, so use \\ (escape sequence).
fin$Revenue <- gsub(",","", fin$Revenue)
head(fin)

fin$Growth <- gsub("%","", fin$Growth)
head(fin)
str(fin)

# Now factor to numeric
fin$Expenses <- as.numeric(fin$Expenses)
fin$Revenue <- as.numeric(fin$Revenue)
fin$Growth <- as.numeric(fin$Growth)
str(fin)
summary(fin)


# Missing Data...
# 1. Predict with 100% accuracy
# 2. Leave record as is
# 3. Remove record enitirely (drawback: sample loses significance)
# 4. Replace with mean or median
# 5. Fill in by exploring correlations and similarities
# 6. Intorduce dummy variable for "Missingness"

# What is an NA?
TRUE  #1
FALSE  #0
NA #Can't assign T nor F, missing value, THIRD TYPE OF LOGICAL VARIABLE

TRUE == TRUE
TRUE == FALSE
TRUE == 1
TRUE == 15
FALSE == FALSE
FALSE == TRUE
FALSE == 2
FALSE == 0
NA == TRUE
NA == FALSE
NA == 15
NA == NA

# Locating missing data
# Upopdated import to: fin <- read.csv("Future 500.csv", na.strings = c(""))
head(fin, 24)
fin[!complete.cases(fin),]  # Show all the incomplete records

str(fin)

# Filtering: using which() for non-missing data
head(fin)
fin[fin$Revenue == 9746272,]
which(fin$Revenue == 9746272)
?which
fin[which(fin$Revenue == 9746272),]

head(fin)
fin[which(fin$Employees == 45), ]

# Filtering: using the is.na() for issing data
head(fin,24)

# use this because you cannot compare anything to NA, because
# it will always result in NA (see example up there somewhere).
fin[is.na(fin$Expenses),] 

# a basic example
is.na()
a <- c(1, 24, 543, NA, 76, 45, NA)
is.na(a)

fin[!is.na(fin$Expenses),]
fin[is.na(fin$State),] # Rows that have missing state values in the State column

# Removing records with missing data
fin_backup <- fin # create backup of data, just in case
# fin <- fin_backup  # Restore from backup


fin[!complete.cases(fin),]
fin[is.na(fin$Industry),]
fin[!is.na(fin$Industry),] #opposite
# So first create the subset (line above), then override the data (line below)
fin <- fin[!is.na(fin$Industry),] # remove those NA rows
fin

# Resetting the data frame index:
fin
rownames(fin) <- 1:nrow(fin)
fin

rownames(fin) <- NULL
fin

# Replacing Missing Data: Factual Analysis
fin[!complete.cases(fin),]

# single out rows with NA states
fin[is.na(fin$State),]

fin[is.na(fin$State) & fin$City=="New York",]
fin[is.na(fin$State) & fin$City=="New York","State"] <- "NY"
#check
fin[c(11,377),]

fin[!complete.cases(fin),]
fin[is.na(fin$State),]
fin[is.na(fin$State) & fin$City=="San Francisco",]
fin[is.na(fin$State) & fin$City=="San Francisco","State"] <- "CA"
#check
fin[c(82,265),]

fin[!complete.cases(fin),]

# Replacing Missing Data: Median Imputation Method (Part 1)
fin[is.na(fin$Employees),] #which rows have NA in Employees column (note Retail Industry and Financial Services Industry)

#start with Retail
fin[is.na(fin$Employees) & fin$Industry=="Retail",]
# lets replace the missing number of employees with the industry's median value for employees...
median(fin[fin$Industry=="Retail","Employees"], na.rm = TRUE)  #check median value
retail_employee_median <- median(fin[fin$Industry=="Retail","Employees"], na.rm = TRUE)  #assign to variable
#replace missing value...
fin[is.na(fin$Employees) & fin$Industry=="Retail","Employees"] <- retail_employee_median
#check
fin[3,]

#next is Financial Services
fin[is.na(fin$Employees) & fin$Industry=="Financial Services",]
# lets replace the missing number of employees with the industry's median value for employees...
median(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE)  #check median value
financialservices_employee_median <- median(fin[fin$Industry=="Financial Services","Employees"], na.rm = TRUE)  #assign to variable
#replace missing value...
fin[is.na(fin$Employees) & fin$Industry=="Financial Services","Employees"] <- financialservices_employee_median
#check
fin[330,]

# Replacing Missing Data: Median Imputation Method (Part 2)
fin[!complete.cases(fin),]

med_growth_construct <- median(fin[fin$Industry=="Construction","Growth"], na.rm = TRUE)
med_growth_construct
fin[is.na(fin$Growth) & fin$Industry=="Construction",]
fin[is.na(fin$Growth) & fin$Industry=="Construction","Growth"] <- med_growth_construct
fin[8,]

# Replacing Missing Data: Median Imputation Method (Part 3)
fin[!complete.cases(fin),]

#tackle Revenue first
med_revenue_construct <- median(fin[fin$Industry=="Construction","Revenue"], na.rm = TRUE)
med_revenue_construct
fin[is.na(fin$Revenue) & fin$Industry=="Construction",]
fin[is.na(fin$Revenue) & fin$Industry=="Construction","Revenue"] <- med_revenue_construct
fin[c(8,42),]

#next, tackle profit
fin[!complete.cases(fin),]
med_profit_construct <- median(fin[fin$Industry=="Construction","Profit"], na.rm = TRUE)
med_profit_construct
fin[is.na(fin$Profit) & fin$Industry=="Construction",]
fin[is.na(fin$Profit) & fin$Industry=="Construction","Profit"] <- med_profit_construct
fin[c(8,42),]


# Rreplacing Missing Data: Deriving Values Method
fin[!complete.cases(fin),]

# Revenue - Expenses = Profit
# => Expenses = Revenue - Profit
fin[is.na(fin$Expenses),]
fin[is.na(fin$Expenses),"Expenses"] <- fin[is.na(fin$Expenses),"Revenue"] - fin[is.na(fin$Expenses),"Profit"]
fin[c(8,15,42),]

# Visualization
# install.packages("ggplot2")
library(ggplot2)

# Scatter plot classified by industry showing revenue, expenses, profit
p <- ggplot(data = fin)
p
p + geom_point(aes(x = Revenue, y = Expenses,
                  color = Industry, size = Profit))

# Scatter plot that includes industry trends for the expenses~revenue relationship
q <- ggplot(data = fin, aes(x = Revenue, y = Expenses,
                            color = Industry))
q + geom_point() +
  geom_smooth(fill = NA, size = 1.2) 

# Box plot showing growth by industry
r <- ggplot(data = fin, aes(x = Industry, y = Growth,
                            color = Industry))
r + geom_boxplot(size = 1)

#extra
r + geom_jitter() +
  geom_boxplot(size = 1, alpha = 0.5, outlier.color = NA)


