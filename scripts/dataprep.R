

getwd()
setwd("C:/Users/calle/Documents/R-Analytics/datasets/section2/")

fin <- read.csv("Future-500.csv")
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
fin$ID <- factor(fin$ID)
str(fin)

fin$Inception <- factor(fin$Inception)
str(fin)



