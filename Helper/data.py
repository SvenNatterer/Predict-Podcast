import pandas as pd


def load_data(descriptive = False):

    # Load CSVs
    train = pd.read_csv("../Data/train.csv")
    test = pd.read_csv("../Data/test.csv")

    # Convert columns to categorical
    categorical_cols = ["Podcast_Name", "Episode_Title", "Genre", "Publication_Day", "Publication_Time", "Episode_Sentiment"]

    train[categorical_cols] = train[categorical_cols].astype("category")
    test[categorical_cols] = test[categorical_cols].astype("category")

    if descriptive:

        # Prepare analysis_train
        analysis_train = train.copy()
        analysis_train[categorical_cols] = analysis_train[categorical_cols].astype("category")

        # Add renamed columns
        analysis_train["Length"] = analysis_train["Episode_Length_minutes"]
        analysis_train["Host"] = analysis_train["Host_Popularity_percentage"]
        analysis_train["Guest"] = analysis_train["Guest_Popularity_percentage"]
        analysis_train["Response"] = analysis_train["Listening_Time_minutes"]
        analysis_train["Ads"] = analysis_train["Number_of_Ads"]

        # Drop original columns
        analysis_train.drop(columns=[
            "Episode_Length_minutes", 
            "Host_Popularity_percentage", 
            "Guest_Popularity_percentage", 
            "Listening_Time_minutes"
        ], inplace=True)

        return analysis_train, test

    return train, test
