# 
# train <- train %>%
#   mutate(
#     Episode_Length_minutes = if_else(
#       is.na(Episode_Length_minutes),
#       median(train$Episode_Length_minutes, na.rm = TRUE),
#       Episode_Length_minutes
#     ),
#     Guest_Popularity_percentage = if_else(
#       is.na(Guest_Popularity_percentage),
#       median(train$Guest_Popularity_percentage, na.rm = TRUE),
#       Guest_Popularity_percentage
#     ),
#     Number_of_Ads = if_else(
#       is.na(Number_of_Ads),
#       median(train$Number_of_Ads, na.rm = TRUE),
#       Number_of_Ads
#     )
#   )
# 
# 
# test <- test %>%
#   mutate(
#     Episode_Length_minutes = if_else(
#       is.na(Episode_Length_minutes),
#       median(test$Episode_Length_minutes, na.rm = TRUE),
#       Episode_Length_minutes
#     ),
#     Guest_Popularity_percentage = if_else(
#       is.na(Guest_Popularity_percentage),
#       median(test$Guest_Popularity_percentage, na.rm = TRUE),
#       Guest_Popularity_percentage
#     )
#   )



train <- train %>%
  mutate(
    Guest_Popularity_percentage = if_else(
      is.na(Guest_Popularity_percentage),
      median(train$Guest_Popularity_percentage, na.rm = TRUE),
      Guest_Popularity_percentage
    ),
    Number_of_Ads = if_else(
      is.na(Number_of_Ads),
      median(train$Number_of_Ads, na.rm = TRUE),
      Number_of_Ads
    )
  )


train <- train %>%
  group_by(Podcast_Name) %>%
  mutate(Episode_Length_minutes = if_else(
    is.na(Episode_Length_minutes),
    mean(Episode_Length_minutes, na.rm = TRUE),
    Episode_Length_minutes
  )) %>%
  ungroup()

group_means <- train %>%
  group_by(Podcast_Name) %>%
  summarize(mean_episode_length = mean(Episode_Length_minutes, na.rm = TRUE))

test <- test %>%
  left_join(group_means, by = "Podcast_Name") %>%
  mutate(Episode_Length_minutes = if_else(
    is.na(Episode_Length_minutes),
    mean_episode_length,
    Episode_Length_minutes
  )) %>%
  select(-mean_episode_length)

test <- test %>%
  mutate(
    Guest_Popularity_percentage = if_else(
      is.na(Guest_Popularity_percentage),
      median(test$Guest_Popularity_percentage, na.rm = TRUE),
      Guest_Popularity_percentage
    )
  )


