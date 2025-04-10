
#implementing the function to calculate the root mean square error
import numpy as np
import pickle
import os

def calc_mse(actual, predicted):
    assert len(actual) == len(predicted), "Lengths of actual and predicted must match"

    mse = np.mean((np.array(actual) - np.array(predicted)) ** 2)

    return np.sqrt(mse)

def save_model(rmse, model, global_best):
    if rmse < global_best['rmse']:
        global_best['rmse'] = rmse
        global_best['model'] = model
        # Save the global_best dictionary to a file
        with open("../Submission/global_best.pkl", "wb") as f:
            pickle.dump(global_best, f)

global_best = {
    'rmse': float('inf'),  # Start with infinity to ensure any RMSE is lower
    'model': None
}

num_features = ["Episode_Length_minutes", "Host_Popularity_percentage", "Guest_Popularity_percentage", "Number_of_Ads"]

factor_features = ["Podcast_Name", "Episode_Title", "Genre", "Publication_Day", "Publication_Time", "Episode_Sentiment"]