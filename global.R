library(data.table)
library(ggplot2)
library(dplyr)
library(leaflet)

runTimes <- fread('runTimes.csv')
trainView <- fread('trainView.csv')
performance <- fread('otp.csv')
