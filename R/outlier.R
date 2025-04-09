train <- train %>% filter(Episode_Length_minutes < 200 | is.na(Episode_Length_minutes))

train <- train %>% filter(Host_Popularity_percentage < 100 | is.na(Host_Popularity_percentage))

train <- train %>% filter(Guest_Popularity_percentage < 100 | is.na(Guest_Popularity_percentage))

train <- train %>% filter(Number_of_Ads < 10 | is.na(Number_of_Ads))
