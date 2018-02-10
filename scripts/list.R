# Lists in Rr

# Deliverable - a list with the following components:
# Chracter:   Machine name
# Vector:     (min, mean, max) Utilization for month (exclude unkown hours)
# Logical:    Has utilization ever fallen below 90%? (TRUE/FALSE)
# Vector:     All hours where utilization in unknown (NA's)
# Dataframe: For this machine
# Plot:       For all machines

getwd()
setwd("C:/Users/calle/Documents/R-Analytics/datasets/section3/")

util <- read.csv("Machine-Utilization.csv")
head(util, 12)
str(util)
summary(util)
# Derive utilization column:
util$Utilization <- 1 - util$Percent.Idle
head(util, 12)

# Handling Date-Times in R:
# Q: Is the date forrmat dd/mm/yyyy or mm/dd/yyyy?
tail(util)
# A: dd/mm/yyyy
?POSIXct
# Let's convert to a standard time-date format using POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format="%d/%m/%Y %H:%M")
head(util,12)
summary(util)

# TIP: How to rearrange columns in a df:
util$Timestamp <- NULL
head(util,12)
util <- util[,c(4,1,2,3)]
head(util,12)

# What is a list?
summary(util)
RL1 <- util[util$Machine=="RL1",]
summary(RL1)
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

# Consrtuct List
# Chracter:   Machine name
# Vector:     (min, mean, max) Utilization for month (exclude unkown hours)
# Logical:    Has utilization ever fallen below 90%? (TRUE/FALSE)
util_stats_rl1 <- c(min(RL1$Utilization, na.rm = TRUE),
                    mean(RL1$Utilization, na.rm = TRUE),
                    max(RL1$Utilization, na.rm = TRUE))
util_stats_rl1

util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0
util_under_90_flag


list_rl1 <- list("RL1", util_stats_rl1, util_under_90_flag)
list_rl1

# Naming components of a list:
list_rl1
names(list_rl1)
names(list_rl1) <- c("Machine","Stats","LowThreshold")
list_rl1
# Another way. Like with dataframes:
rm(list_rl1)
list_rl1
list_rl1 <- list(Machine = "RL1", Stats = util_stats_rl1, LowThreshold = util_under_90_flag)
list_rl1

# Extracting components from a list:
# Three ways:
# 1. [] - always return a list
# 2. [[]] - will always return the actual object
# 3. $ - same as [[]], but prettier
list_rl1
list_rl1[1]
list_rl1[[1]]
list_rl1$Machine

list_rl1[2]
typeof(list_rl1[2])
list_rl1[[2]]
typeof(list_rl1[[2]])
list_rl1$Stats
typeof(list_rl1$Stats)

#  Challenge: How would you access the 3rd element of the vector (max utilization)?
list_rl1
list_rl1[[2]][3]
# or
list_rl1$Stats[3]

# Adding and deleting components to a list:
list_rl1
# Add
list_rl1[4] <- "New Information"
list_rl1

# Another way to add a component - via the $
# We will add:
# Vector:     All hours where utilization in unknown (NA's)
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_rl1

# Remove a component. Use the NULL method:
list_rl1[4] <- NULL
list_rl1
# NOTICE : numeration has shifted
list_rl1[4]

# Add another component:
# Dataframe: For this machine
list_rl1$Data <- RL1
list_rl1
summary(list_rl1)
str(list_rl1)

# Subsetting a list
list_rl1
list_rl1$UnknownHours[1]
list_rl1[[4]][1]

list_rl1[1:3]
list_rl1[c(1,4)]
sublist_rl1 <- list_rl1[c("Machine","Stats")]
sublist_rl1
sublist_rl1[[2]][2]
sublist_rl1$Stats[2]

# Double square brackets are NOT for Subsetting!
# list_rl1[[1:3]] # will throw an error!
# [[]] are for accessing elements
# [] are for subsetting

# Creating a time series plot!
# install.package("ggplot2")
library(ggplot2)

p <- ggplot(data = util)
p + geom_line(aes(x = PosixTime, y = Utilization, 
                  color = Machine), size = 1.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,
             color = "Gray", size = 1.2,
             linetype = 3)

myplot <- p + geom_line(aes(x = PosixTime, y = Utilization, 
                            color = Machine), size = 1.2) +
  facet_grid(Machine~.) +
  geom_hline(yintercept = 0.90,
             color = "Gray", size = 1.2,
             linetype = 3)

list_rl1$Plot <- myplot # Because yes, even a plot can be in a list!
list_rl1
summary(list_rl1)
str(list_rl1)

list_rl1











