Google Data Analytics Professional Certificate Capstone Project

[Notes 2.docx](https://github.com/Gbemiclassic/Portfolio-Projects/files/9002547/Notes.2.docx)
#Installing and loading of needed R packages#

install.packages("tidyverse")
library(tidyverse)
install.packages("lubridate")
library(lubridate)
install.packages("janitor")
library(janitor)
install.packages("skimr")
library(skimr)

#Importing the Data#

May21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202105-divvy-tripdata.csv")
June21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202106-divvy-tripdata.csv")
July21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202107-divvy-tripdata.csv")
August21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202108-divvy-tripdata.csv")
September21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202109-divvy-tripdata.csv")
October21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202110-divvy-tripdata.csv")
November21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202111-divvy-tripdata.csv")
December21 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202112-divvy-tripdata.csv")
January22 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202201-divvy-tripdata.csv")
February22 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202202-divvy-tripdata.csv")
March22 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202203-divvy-tripdata.csv")
April22 <- read.csv("C:/Users/DELL LATITUDE 7390/Documents/R/202204-divvy-tripdata.csv")


# Uniting all the data for the individual months into a single dataset#

All_trips <- rbind(May21, June21, July21, August21, September21, October21, 
                   December21, January22, February22, March22, April22)

glimpse(All_trips)

##Renaming the column "member_casual" to "membership_type"# 

All_trips <- All_trips %>%
  rename(membership_type = member_casual)

#Removal of leading and trailing white spaces#

All_trips <- All_trips %>% 
  mutate(ride_id = str_trim(ride_id, side = 'both'), 
         rideable_type = str_trim(rideable_type, side = 'both'), 
         start_station_name = str_trim(start_station_name, side = 'both'),	
         end_station_name = str_trim(end_station_name, side = 'both'), 
         membership_type = str_trim(membership_type, side = 'both'))

'''Expunging records with blank cells from the start_station_name 
and end_station_name columns'''

All_trips_clean <- All_trips %>%
  filter(!(start_station_name == ''| end_station_name == ''))

View(All_trips_clean)
glimpse(All_trips_clean)

Data Transformation

1.	A new column name trip_route is formed from the start and end station name
All_trips_cleaned$trip_route <- paste(All_trips_cleaned$start_station_name, 
                                      All_trips_cleaned$end_station_name, sep= ' - ')

2.	Creating new columns that show the months, days of the week, hour of the day, ride_length in hours and in minutes.
All_trips_transformed <- All_trips_cleaned %>%
  mutate(month = month(started_at, label = TRUE), 
          day =wday(started_at, label = TRUE), 
         hour_of_the_day = hour(started_at), 
         ride_length_hours = difftime(ended_at, started_at, units = 'hours'), 
         ride_length_mins = difftime(ended_at, started_at, units = 'mins')) 


3.	Some of the ride_lengths are less than a minute while other are more than 24 hours.
This will be all be removed for consistency and integrity of the data.
 

All_trips_processed <- All_trips_transformed %>%
	filter (ride_length_hours <24)%>%
	filter(ride_length_mins >1)


This ends the Data Processing steps in R. Next, I’ll export the data into single CSV file for Analysis and Visualization in Power BI.

write.csv(All_trips_transformed, 'C:/Users/DELL LATITUDE 7390/Desktop/Google Data Analytics/Capstone/Bike_trips.csv')

Analyse Phase

Now we have 19 columns and 4,359,844 rows.
To commence the analysis phase, I took the following steps to further breakdown our data
•	I categorized the days of the week as either Weekend or Weekday using DAX in power BI

Weekend_Weekday = IF(Bike_trips[day] = "Sat" || Bike_trips[day] = "Sun", "Weekend", "Weekday")

•	I also categorized the months of the year into seasons to understand each season’s peculiarity

Seasons = IF(Bike_trips[month] = "Mar" || Bike_trips[month] = "Apr" || Bike_trips[month] = "May", "Spring",
IF(Bike_trips[month] = "Jun" || Bike_trips[month] = "Jul" || Bike_trips[month] = "Aug", "Summer",
IF(Bike_trips[month] = "Sep" || Bike_trips[month] = "Oct" || Bike_trips[month] = "Nov", "Autumn", "Winter")))





