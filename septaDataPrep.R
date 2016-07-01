library(dplyr)
library(timeDate)
library(lubridate)



trainView <- read.csv('trainView.csv', stringsAsFactors = FALSE, na.strings = '')

trainView$status <- as.numeric(trainView$status)

##Clean up train names. See my other script for the logic behidn this
indexLetters <- grepl('[A-Za-z/. /-]+',trainView$train_id)
trainView <- trainView[!indexLetters,]

##Replace Market East with Jefferson 
trainView$source <- gsub("Market East", "Jefferson", trainView$source)
trainView$dest <- gsub("Market East", "Jefferson", trainView$dest)


getDeltas <- function(timeStamp0, timeStamp1) {
    
    # Get the first and last timeStamp for the train
    first_stamp <- min(timeDate(timeStamp0))
    last_stamp <- max(timeDate(timeStamp1))
    
    # Calculate the time delta for the train
    delta <- difftime(last_stamp, first_stamp, units="mins")
    
    
    # If train runs through midnight (aka first time_stamp is early am), 
    #set to NA, since time deltas would be wrong in this case
    if (between(hour(first_stamp), 0, 4)) {
      return(NA)
    }
    
    # Otherwise return time delta
    return(as.numeric(delta))
    
}

getOnTimePerformance <- function(status) {
    return(mean(status < 6))
}


getTerminal <- function(terminal) {
    return(names(which.max(table(terminal))))
}



runTimes <- trainView %>%
  group_by(date, train_id) %>%
  summarize(delta = getDeltas(timeStamp0, timeStamp1),
            avglate=mean(status),
            service=getTerminal(service),
            source=getTerminal(source),
            dest=getTerminal(dest)) %>%
    filter(!is.na(delta))
  
otp <- trainView %>%
    group_by(train_id) %>%
    summarize(otp=getOnTimePerformance(status))

write.csv(runTimes, file='runTimes.csv')
write.csv(trainView, file='trainView.csv', row.names=FALSE)
write.csv(otp, file='otp.csv', row.names=FALSE)