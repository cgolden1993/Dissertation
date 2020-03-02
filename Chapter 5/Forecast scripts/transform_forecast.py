import psycopg2

import sys
sys.path.append('/Users/cegolden/Projects/Weather/Forecast_Upload')

from json_parser_weather import json_parser
from get_past_weather import get_past_weather
from json_past_parser import json_past

from seven_day_format import seven_day_format
from six_day_format import six_day_format
from five_day_format import five_day_format
from four_day_format import four_day_format
from three_day_format import three_day_format
from two_day_format import two_day_format
from one_day_format import one_day_format

import time
import zips
import joblib


#establish a connection to the database of interest where table is present
conn = psycopg2.connect("host=localhost dbname=weather_app user=mishralab password=rainbow")
cur = conn.cursor()

cur.execute("SELECT DISTINCT ON (zip_code) id, zip_code, forecast, date FROM zip_forecast_app ORDER BY zip_code, id DESC;")
forecasts = cur.fetchall()

#close the cursor
cur.close()

#close the connection
conn.close()

#convert 7 day forecasts into climate data to plug into model for 7 day predictions
seven_day_forecasts=[]
for row in forecasts:
    zip = row[1]
    zip_fore = json_parser(row[2])
    seven_day_forecasts.append([zip, zip_fore])

#get current time and days before time to extract historical weather data
current_time = int(round(time.time()))
one_day_ago = current_time - 43200
two_day_ago = one_day_ago - 86400
three_day_ago = two_day_ago - 86400
four_day_ago = three_day_ago - 86400
five_day_ago = four_day_ago - 86400
six_day_ago = five_day_ago - 86400
time_ago = [one_day_ago, two_day_ago, three_day_ago, four_day_ago, five_day_ago, six_day_ago]

#get past data for up to 6 days ago
zips = zips.selected_zips
past_weather_all = []
for zip in zips:
    for days in time_ago:
        past_weather_all.append(get_past_weather(zip, days))

#this results in a list with 54 elements from 9 zip codes and 6 days from past
#zip order: 28167, 30577, 30621, 30622, 30641, 30656, 30666, 30677, 30683

past_weather_formatted = []     
for weather in past_weather_all:
    past_weather_formatted.append(json_past(weather))

one_day_ago_pre = past_weather_formatted[0:9]
two_day_ago_pre = past_weather_formatted[9:18]
three_day_ago_pre = past_weather_formatted[18:27]
four_day_ago_pre = past_weather_formatted[27:36]
five_day_ago_pre = past_weather_formatted[36:45]
six_day_ago_pre = past_weather_formatted[45:54]

zip_codes = [28167, 30577, 30621, 30622, 30641, 30656, 30666, 30677, 30683]

#for 7 days ahead predictions
final_seven_day = []
for i in range(0,9):
    final_seven_day.append(seven_day_format(seven_day_forecasts[i][1]))
    final_seven_day[i].insert(0, "Zip code", zip_codes[i])
    final_seven_day[i].insert(1, "Prediction day", 7)

#for 6 days ahead predictions
final_six_day = []
for i in range(0,9):
    final_six_day.append(six_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i]))
    final_six_day[i].insert(0, "Zip code", zip_codes[i])
    final_six_day[i].insert(1, "Prediction day", 6)

#for 5 days ahead predictions, etc.
final_five_day = []
for i in range(0,9):
    final_five_day.append(five_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i], 
                                          two_day_ago_pre[i]))
    final_five_day[i].insert(0, "Zip code", zip_codes[i])
    final_five_day[i].insert(1, "Prediction day", 5)

final_four_day = []
for i in range(0,9):
    final_four_day.append(four_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i], 
                                          two_day_ago_pre[i], three_day_ago_pre[i]))
    final_four_day[i].insert(0, "Zip code", zip_codes[i])
    final_four_day[i].insert(1, "Prediction day", 4)

final_three_day = []
for i in range(0,9):
    final_three_day.append(three_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i], 
                                          two_day_ago_pre[i], three_day_ago_pre[i],
                                          four_day_ago_pre[i]))
    final_three_day[i].insert(0, "Zip code", zip_codes[i])
    final_three_day[i].insert(1, "Prediction day", 3)

final_two_day = []
for i in range(0,9):
    final_two_day.append(two_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i], 
                                          two_day_ago_pre[i], three_day_ago_pre[i],
                                          four_day_ago_pre[i], five_day_ago_pre[i]))
    final_two_day[i].insert(0, "Zip code", zip_codes[i])
    final_two_day[i].insert(1, "Prediction day", 2)

final_one_day = []
for i in range(0,9):
    final_one_day.append(one_day_format(seven_day_forecasts[i][1], one_day_ago_pre[i], 
                                          two_day_ago_pre[i], three_day_ago_pre[i],
                                          four_day_ago_pre[i], five_day_ago_pre[i],
                                          six_day_ago_pre[i]))
    final_one_day[i].insert(0, "Zip code", zip_codes[i])
    final_one_day[i].insert(1, "Prediction day", 1)

final_all_days = final_one_day + final_two_day + final_three_day + final_four_day + final_five_day + final_six_day + final_seven_day

#make predictions
campy_feces = joblib.load('/Users/cegolden/Projects/Weather/Model_Development/campy_rf_feces.pkl')
campy_soil = joblib.load('/Users/cegolden/Projects/Weather/Model_Development/campy_rf_soil.pkl')

#establish a connection to the database of interest where table is present
conn = psycopg2.connect("host=localhost dbname=weather_app user=mishralab password=rainbow")
cur = conn.cursor()

for i in range(0, len(final_all_days)):
    weather = final_all_days[i]
    zip = int(weather.iloc[0][0])
    day = int(weather.iloc[0][1])
    time_utc = int(time.time())
    weather_only = weather.drop(weather.columns[[0,1]], axis = 1)
    feces_predic = campy_feces.predict_proba(weather_only)[0]
    feces_predic_pos = feces_predic[1]
    
    #insert data into table
    cur.execute("INSERT INTO feces_predictions (zip_code, days, feces_prob, date) VALUES (%s, %s, %s, %s)", [zip, day, feces_predic_pos, time_utc])

for i in range(0, len(final_all_days)):
    weather = final_all_days[i]
    zip = int(weather.iloc[0][0])
    day = int(weather.iloc[0][1])
    time_utc = int(time.time())
    weather_only = weather.drop(weather.columns[[0,1]], axis = 1)
    soil_predic = campy_soil.predict_proba(weather_only)[0]
    soil_predic_pos = soil_predic[1]
    
    #insert data into table
    cur.execute("INSERT INTO soil_predictions (zip_code, days, soil_prob, date) VALUES (%s, %s, %s, %s)", [zip, day, soil_predic_pos, time_utc])

 
#commit any changes made to database
conn.commit()

#close the cursor
cur.close()

#close the connection
conn.close()

