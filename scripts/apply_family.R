getwd()
setwd("C:/Users/calle/Documents/R-Analytics/datasets/section4")
setwd("./Weather Data/") # ./ - relative dir

# Read data:
Chicago <- read.csv("Chicago-F.csv", row.names = 1)
NewYork <- read.csv("NewYork-F.csv", row.names = 1)
Houston <- read.csv("Houston-F.csv", row.names = 1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names = 1)

# Check:
# Chicago:
Chicago
NewYork
Houston
SanFrancisco
# These are dataframes:
is.data.frame(Chicago)
is.data.frame(NewYork)
is.data.frame(Houston)
is.data.frame(SanFrancisco)

# Since all elements are numeric and we want to do some matirx stuff,
# let's change these to matrices:
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco  <- as.matrix(SanFrancisco)

# Check:
is.matrix(Chicago)

# Let's put them all in to a list:
Weather <- list(Chicago = Chicago,NewYork = NewYork,
                Houston = Houston,SanFrancisco = SanFrancisco)
Weather
# Let's try it out:
Weather[3]
Weather[[3]]
Weather$Houston

# Using apply()
?apply()
apply(Chicago, 1, mean)
# Check:
mean(Chicago["DaysWithPrecip",])
# Analyze one city:
Chicago
apply(Chicago, 1, max)
apply(Chicago, 1, min)
# For practice:
apply(Chicago, 2, max) # doesn't make much sense, but good for practice!
apply(Chicago, 2, min)

# Compare:
apply(Chicago, 1, mean)
apply(NewYork, 1, mean)
apply(Houston, 1, mean)
apply(SanFrancisco, 1, mean)
### NEARLY DELIVERABLE 1, BUT THERE IS A FASTER WAY!

# Recreating the apply function using loops (advanced)
Chicago
# find the mean of every row:

# 1. via loops
output <- NULL #preparing an empty vector
for(i in 1:5){ #run cycle
  output[i] <- mean(Chicago[i,])
}
output # see what we got
names(output) <- rownames(Chicago)
output

# 2. via apply function
apply(Chicago, 1, mean)

# Using lapply()
?lapply
Chicago
t(Chicago)
Weather
Weather
lapply(Weather, t) # list(t(Chicago), t(NewYork), etc)

mynewlist <- lapply(Weather, t)
mynewlist

# example 2
Chicago
rbind(Chicago, NewRow=1:12)
lapply(Weather, rbind, NewRow=1:12)

# example 3
?rowMeans
rowMeans(Chicago) # identical to: apply(Chicago, 1, mean)
lapply(Weather, rowMeans)
### NEARLY DELIVERABLE 1: EVEN BETTER, BUT WE'LL IMPROVE!

# rowMeans
# colMeans
# rowSums
# colSums

# Combining lapply() with the [ ] operator
Weather
Weather$Chicago[1,1] # Weather$Chicago[1,1], Weather$NewYork[1,1], etc.
Weather[[1]][1,1] # Weather[[1]][1,1], Weather[[2]][1,1], etc.

lapply(Weather, "[", 1, 1)
Weather
lapply(Weather, "[", 1, )
Weather

# For just March (mini challenge)
lapply(Weather, "[", , 3) # gives all March data for the cities

# Adding your own functions in the apply family of functions
# One of the most powerful things in R.
lapply(Weather, rowMeans)
lapply(Weather, function(x) x[1,]) # first row of the matrices
lapply(Weather, function(x) x[5,])
lapply(Weather, function(x) x[,12])
Weather
lapply(Weather, function(z) z[1,]-z[2,]) # difference b/t av. hi and low temp
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], digits = 2))
### DELIVERABLE 2, BUT WE'LL IMPORVE!!!

# Using sapply()
?sapply
Weather
# AvgHigh_F for July:
lapply(Weather, "[", 1, 7) # always returns a list
sapply(Weather, "[", 1, 7) # may return a vector or a matrix

# AvgHigh_F for 4th quarter
lapply(Weather, "[", 1, 10:12)
sapply(Weather, "[", 1, 10:12)

# Another example
lapply(Weather, rowMeans)
sapply(Weather, rowMeans)
round(sapply(Weather, rowMeans), 2) # DELIVERABLE 1 -- AWESOME!!!

# Another example
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], digits = 2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,], digits = 2)) # DELIVERABLE 2 -- AWESOME!!!

# By the way:
sapply(Weather, rowMeans, simplify = FALSE, USE.NAMES = FALSE) # same as lapply()

# Nesting apply functions:
Weather
lapply(Weather, rowMeans)
?rowMeans
Chicago
apply(Chicago, 1, max)

# apply across whole list:
lapply(Weather, apply, 1, max) # preferred approach

# Another way:
lapply(Weather, function(x) apply(x, 1, max)) # same as above!

# Tidy up:
sapply(Weather, apply, 1, max) # DELIVERABLE 3!!!
sapply(Weather, apply, 1, min) # DELIVERABLE 4!!!

# Very advanced tutorial!!!
# which.max
?which.max

Chicago[1,]
which.max(Chicago[1,])
names(which.max(Chicago[1,]))

# By the sounds of it:
# We will have: apply - to iterate over the rows of the matrix
# and we will have: lapply or sapply - to iterate over components of the list
apply(Chicago, 1, function(x) names(which.max(x)))
lapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))
sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))
