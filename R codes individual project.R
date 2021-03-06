#Report part 2 
#One-way or single factor ANOVA

installed.packages(c("ggplot2","ggpubr","tidyverse","broom"))
install.packages("ggpubr")

#load the packages into R
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)

#Step 0: define your hypothesis
#Ho: u1 = u2 = u3 (all population means are equal)
#Ha: not all population means are equal

#Step 1: import data into RStudio
triple_df = read.csv("Documents/BUS2_194A_Statistical_Analysis/Chapter_13/Triple-A-edited.csv", header = TRUE, colClasses = c("factor","factor", "numeric"))
summary(triple_df) #summary statistic 
#interpretation: the categorical variable (Team Name's Division North, South, and West) has 6, 4, and 4 observations, respectively. The quantitative
#variable Attendance has a numeric summary with mean = 7300 and median = 7471. The average attendance for the 3 divisions is 7300. 

#Step 2: data visualization using boxplot (Note: you can explore dotplots, histogram, etc)
boxplot(Attendance ~ Division, data = triple_df, main = "Attenance among 14 teams for the 3 divisions analysis", xlab = "Divisions", ylab = "Attendance")
#interpretation: the boxplot gives us a visual summary of the data. It shows the median, outliers, quartiles, maximum
#and minumum values. It is observed from the plot that the median values of all three divisions (7800, 5400, 8400) are 
#different. We can visually see the variation in the data from the boxplot, which shows high-within group variance and high among group-variance. 

#additional interpretation: we see that not all the notches in the boxplots overlap and we can conclude that with 95% confidence, that the true medians 
#do differ. 

#Step 3: ANOVA test 
triple_anova = aov(Attendance ~ Division, data = triple_df) 
summary(triple_anova)
#interpretation: 
#(1)the variance (MSE) is 1301393 
#(2)the p-value is less than 0.05, so we reject the null hypothesis 

#Step 4: conclusion 
#we can conclude that there are significant differences between the mean attendance among the 3 divisions 

#Step 5: assumption test

#the first assumption is to check for the homogeneity of variance (i.e., are the pop.variance the same)
#graphical analysis to check for variance using the Residuals vs Fitted plot 
plot(triple_anova, 1)
#interpretation: points 8, 3, and 6 are detected as outliers, which can severely affect the normality and variance assumptions. 
#it can be useful to remove outliers from the data to meet the test assumptions.

#we can use a test called the Levene's test to check for variance 
library(car)
test = leveneTest(Attendance ~ Division, data = triple_df)  #test for variance 
test
#interpretation: from the output we can see that the p-value is not less than the significant level of 0.05 
#this means that there is no evidence to suggest that the variance across methods is significantly different 
#therefore, we can assume the homogeneity of variances in the different division groups 

#the second assumption is to check for normality (i.e. is our dataset normally distributed)
#the normal probability plot of residuals (Normal Quantile plot) is used to check for normality
#the points on the plot should approximately follow a straight line 
plot(triple_anova, 2)
#interpretation: the points on the plot do not really follow a straight line, so we cannot assume normality 
#we may have to perform another test to confirm normality 

#the Shapiro-Wilk test on the ANOVA residuals is used to confirm normality
#extract the residuals 
triple_residuals = residuals(object = triple_anova)
#run Shapiro-Wilk test 
shapiro.test(x = triple_residuals)
#interpretation: W = 0.95, p-value = 0.5 which indicates that the normality assumption is not violated because p-value is greater than 0.05 

#Report part 3 
#multiple comparison procedure using t test 
pairwise.t.test(triple_df$Attendance, triple_df$Division, p.adj = "bonf") #bonf means bonferroni

#another method for multiple comparison is Tukey's Honest Significant Differences (HSD)
TukeyHSD(triple_anova, p.adj = "bonf")

#interpretation North: with an alpha value of 0.05 (p-value = 0.6 > 0.05), we FTR Ho
#the population mean attendance for division North is equal to the population mean attendance for division West 

#interpretation B: with an alpha value of 0.05 (p-value = 0.012 < 0.05), we can reject Ho
#the population mean attendance for division South is not equal to division West 

#overall interpretation: in effect, our conclusion is that the population mean attendance for division South differs from West but it is the same among North and West 


