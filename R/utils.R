#Functions
calc_rmse <- function(actual, predicted) {

  stopifnot(length(actual) == length(predicted))

  mse <- mean((actual - predicted)^2)

  sqrt(mse)
}

save_model <- function(rmse, model) {
  if(rmse < global_best$rmse){
    global_best$rmse <<- mean_cv_rmse
    global_best$model <<- model
    global_best$preprocessing <<- preprocessing
    save(global_best, file = "../Submission/global_best.RData")
  }
}

my_source <- function(file, ...) {
  preprocessing <<- c(preprocessing, file)
  base::source(file, ...)
}


#Initialisiere global_best
if (!exists("global_best")) {
  global_best <- list(
    rmse  = Inf,    # initialisieren mit "unendlich" als Platzhalter
    model = NULL,    # oder ein bereits existierendes (z.B. lm-Objekt)
    preprocessing = character()
  )
}

if (!exists("preprocessing")) {
    preprocessing = character()
}

num_features <- c("Episode_Length_minutes", "Host_Popularity_percentage", "Guest_Popularity_percentage", "Number_of_Ads")

factor_features <- c("Podcast_Name", "Episode_Title", "Genre", "Publication_Day", "Publication_Time", "Episode_Sentiment")



