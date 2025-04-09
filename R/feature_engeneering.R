target <- c("Listening_Time_minutes")

#CAT Target Encoding
cols_to_encode <- factor_features

mappings <- list()

for (col in cols_to_encode) {

  mapping <- train %>%
    group_by_at(col) %>%
    summarise(mean_target = mean(!!sym(target), na.rm = TRUE)) %>%
    ungroup()

  mapping_vec <- setNames(mapping$mean_target, mapping[[col]])
  mappings[[col]] <- mapping_vec

  new_col_name <- paste0(col, "_target_encoded")

  train[[new_col_name]] <- unname(mapping_vec[as.character(train[[col]])])
}

global_mean <- mean(train[[target]], na.rm = TRUE)

for (col in cols_to_encode) {
  mapping_vec <- mappings[[col]]
  new_col_name <- paste0(col, "_target_encoded")

  test[[new_col_name]] <- unname(mapping_vec[ as.character(test[[col]]) ])

  test[[new_col_name]] <- ifelse(is.na(test[[new_col_name]]), global_mean, test[[new_col_name]])
}


# #NUM Target Encoding
breaks_list <- list()
num_encodings <- list()

for (col in num_features) {
  

  range_min <- min(train[[col]], na.rm = TRUE)
  range_max <- max(train[[col]], na.rm = TRUE)

  my_breaks <- seq(range_min, range_max, length.out = 50)
  breaks_list[[col]] <- my_breaks
  
  new_bin_col <- paste0(col, "_binned")
  train[[new_bin_col]] <- cut(train[[col]], breaks = my_breaks, include.lowest = TRUE)
  
  # Mapping: 
  mapping <- train %>%
    group_by_at(new_bin_col) %>%
    summarise(mean_target = mean(!!sym(target), na.rm = TRUE), .groups = "drop")
  
  mapping_vec <- setNames(mapping$mean_target, mapping[[new_bin_col]])
  num_encodings[[col]] <- mapping_vec
  
  new_encoded_col <- paste0(col, "_2")
  train[[new_encoded_col]] <- unname(mapping_vec[ as.character(train[[new_bin_col]]) ])

  global_mean <- mean(train[[target]], na.rm = TRUE)
  train[[new_encoded_col]] <- ifelse(is.na(train[[new_encoded_col]]), global_mean, train[[new_encoded_col]])
}

for (col in num_features) {

  my_breaks <- breaks_list[[col]]
  
  new_bin_col <- paste0(col, "_binned")
  test[[new_bin_col]] <- cut(test[[col]], breaks = my_breaks, include.lowest = TRUE)

  mapping_vec <- num_encodings[[col]]
  
  new_encoded_col <- paste0(col, "_2")
  test[[new_encoded_col]] <- unname(mapping_vec[ as.character(test[[new_bin_col]]) ])
  
  global_mean <- mean(train[[target]], na.rm = TRUE)
  test[[new_encoded_col]] <- ifelse(is.na(test[[new_encoded_col]]), global_mean, test[[new_encoded_col]])
}

#Remove uneccery features
train <- train %>% select(-id, -Podcast_Name, -Episode_Title, -Genre, -Publication_Day, -Publication_Time, -Episode_Sentiment,
                          -Episode_Length_minutes_binned, -Host_Popularity_percentage_binned, -Guest_Popularity_percentage_binned,
                          -Number_of_Ads_binned)
test <- test %>% select(-id, -Podcast_Name, -Episode_Title, -Genre, -Publication_Day, -Publication_Time, -Episode_Sentiment,
                          -Episode_Length_minutes_binned, -Host_Popularity_percentage_binned, -Guest_Popularity_percentage_binned,
                          -Number_of_Ads_binned)

#Interaktion Feature Engeneering
num_cols <- c(
  "Episode_Length_minutes",
  "Host_Popularity_percentage",
  "Guest_Popularity_percentage",
  "Number_of_Ads",
  "Podcast_Name_target_encoded",
  "Episode_Title_target_encoded",
  "Genre_target_encoded",
  "Publication_Day_target_encoded",
  "Publication_Time_target_encoded",
  "Episode_Sentiment_target_encoded"
)

train[num_cols] <- lapply(train[num_cols], as.numeric)
combos <- combn(num_cols, 2)
for(i in seq_len(ncol(combos))) {
  pair <- combos[, i]   # c("SpalteA", "SpalteB")
  colA <- pair[1]
  colB <- pair[2]

  new_col_name <- paste0(colA, "_x_", colB)

  train[[new_col_name]] <- train[[colA]] * train[[colB]]
}


test[num_cols] <- lapply(test[num_cols], as.numeric)
combos <- combn(num_cols, 2)
for(i in seq_len(ncol(combos))) {
  pair <- combos[, i]   # c("SpalteA", "SpalteB")
  colA <- pair[1]
  colB <- pair[2]
  
  new_col_name <- paste0(colA, "_x_", colB)
  
  test[[new_col_name]] <- test[[colA]] * test[[colB]]
}

interaction_features <- test[, grep("_x_", names(test))]
all_features <-  c("Episode_Length_minutes", "Host_Popularity_percentage", "Guest_Popularity_percentage", "Number_of_Ads","Podcast_Name_target_encoded", "Episode_Title_target_encoded", "Genre_target_encoded", "Publication_Day_target_encoded", "Publication_Time_target_encoded", "Episode_Sentiment_target_encoded",
                   "Episode_Length_minutes_2", "Host_Popularity_percentage_2", "Guest_Popularity_percentage_2", "Number_of_Ads_2")
all_features <- c(all_features, names(interaction_features))

eng_features <- c("Episode_Length_minutes", "Host_Popularity_percentage", "Guest_Popularity_percentage", "Number_of_Ads", "Episode_Length_minutes_2", "Episode_Length_minutes_x_Host_Popularity_percentage", "Episode_Length_minutes_x_Episode_Sentiment_target_encoded")


