train <- readr::read_csv("../Data/train.csv", show_col_types = FALSE)
train <- train %>% mutate(Podcast_Name = as.factor(train$Podcast_Name),
                          Episode_Title = as.factor(train$Episode_Title),
                          Genre = as.factor(train$Genre),
                          Publication_Day	 = as.factor(train$Publication_Day),
                          Publication_Time = as.factor(train$Publication_Time),
                          Episode_Sentiment = as.factor(train$Episode_Sentiment)) 

test <- readr::read_csv("../Data/test.csv", show_col_types = FALSE)
test <- test %>% mutate(Podcast_Name = as.factor(test$Podcast_Name),
                        Episode_Title = as.factor(test$Episode_Title),
                        Genre = as.factor(test$Genre),
                        Publication_Day	 = as.factor(test$Publication_Day),
                        Publication_Time = as.factor(test$Publication_Time),
                        Episode_Sentiment = as.factor(test$Episode_Sentiment)) 

analysis_train <- train %>% mutate(Podcast_Name = as.factor(train$Podcast_Name),
                                   Episode_Title = as.factor(train$Episode_Title),
                                   Genre = as.factor(train$Genre),
                                   Publication_Day	 = as.factor(train$Publication_Day),
                                   Publication_Time = as.factor(train$Publication_Time),
                                   Episode_Sentiment = as.factor(train$Episode_Sentiment),
                                   Length = Episode_Length_minutes,
                                   Host = Host_Popularity_percentage,
                                   Guest = Guest_Popularity_percentage,
                                   Response = Listening_Time_minutes,
                                   Ads = Number_of_Ads) %>% select(-Episode_Length_minutes, -Host_Popularity_percentage, -Guest_Popularity_percentage, -Listening_Time_minutes)

