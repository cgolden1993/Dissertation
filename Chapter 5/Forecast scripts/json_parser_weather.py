
import numpy as np
import pandas as pd

def json_parser(json):
    
    forecast = json['data']
    #remove last item of list because data will not be used
    del forecast[168]

    #create empty lists
    temp = []
    humidity = []
    wind_speed = []
    gust_speed =[]
    precip = []
    #populate each list with 7 day forecast of given variable
    for hour in forecast:
        temp.append(hour['temperature'])
        humidity.append(hour['humidity'])
        wind_speed.append(hour['windSpeed'])
        gust_speed.append(hour['windGust'])
        precip.append(hour['precipIntensity'])

    #reshape each list to be a 24x7 array (daily forecast structure)
    #humidity multiplied by 100 to match training data
    #other units: temp (C), wind and gust speed (m/s), precip (mm)
    temp = np.asarray(temp).reshape(24, 7, order = 'F')
    humidity = np.asarray(humidity).reshape(24, 7, order = 'F')
    humidity = humidity * 100
    wind_speed = np.asarray(wind_speed).reshape(24, 7, order = 'F')
    gust_speed = np.asarray(gust_speed).reshape(24, 7, order = 'F')
    precip = np.asarray(precip).reshape(24, 7, order = 'F')

    #get avg, min, and max of each variable of interest
    #in each array the first value represents the first day of forecasted weather
    max_wind_speed = np.amax(wind_speed, axis = 0)
    avg_wind_speed = np.mean(wind_speed, axis = 0)
    max_gust_speed = np.amax(gust_speed, axis = 0)
    min_humidity = np.amin(humidity, axis = 0)
    max_humidity = np.amax(humidity, axis = 0)
    avg_humidity = np.mean(humidity, axis = 0)
    min_temp = np.amin(temp, axis = 0)
    max_temp = np.amax(temp, axis = 0)
    avg_temp = np.mean(temp, axis = 0)
    precip_total = np.sum(precip, axis = 0)
    all_data = np.vstack((max_wind_speed, avg_wind_speed, max_gust_speed, min_humidity,
               max_humidity, avg_humidity, min_temp, max_temp, avg_temp, precip_total))

    #flip data horizontally and transpose so that first row represents one day before the day of
    #predictions (7 days after forecast is made) and the 7th row represents 7 days before
    all_data = np.flip(all_data, axis = 1)
    all_data = np.transpose(all_data)

    columns = ['max_wind_speed', 'avg_wind_speed', 'max_gust_speed', 'min_humidity',
               'max_humidity', 'avg_humidity', 'min_temp', 'max_temp', 'avg_temp',
               'precip_total']

    #create data frame containing results, index = 0 = 1 day before the day we are predicting
    all_data = pd.DataFrame(all_data, columns=columns)

    #name columns to match up with training data order
    ordered_columns = ['max_wind_speed_one', 'max_wind_speed_two',
                       'max_wind_speed_three','max_wind_speed_four',
                       'max_wind_speed_five','max_wind_speed_six','max_wind_speed_seven','avg_max_wind_speed.2',
                     'avg_max_wind_speed.3', 'avg_max_wind_speed.4', 'avg_max_wind_speed.5',
                     'avg_max_wind_speed.6', 'avg_max_wind_speed.7',
                     'avg_wind_speed_one', 'avg_wind_speed_two',
                     'avg_wind_speed_three', 'avg_wind_speed_four',
                     'avg_wind_speed_five', 'avg_wind_speed_six',
                     'avg_wind_speed_seven', 
                     'avg_avg_wind_speed.2',
                     'avg_avg_wind_speed.3', 'avg_avg_wind_speed.4', 'avg_avg_wind_speed.5',
                     'avg_avg_wind_speed.6', 'avg_avg_wind_speed.7',
                     'max_gust_speed_one', 'max_gust_speed_two', 
                     'max_gust_speed_three', 'max_gust_speed_four',
                     'max_gust_speed_five', 'max_gust_speed_six',
                     'max_gust_speed_seven', 
                     'avg_max_gust_speed.2',
                     'avg_max_gust_speed.3', 'avg_max_gust_speed.4', 'avg_max_gust_speed.5',
                     'avg_max_gust_speed.6', 'avg_max_gust_speed.7',
                     'min_humidity_one', 'min_humidity_two', 
                     'min_humidity_three', 'min_humidity_four',
                     'min_humidity_five', 'min_humidity_six',
                     'min_humidity_seven', 
                     'avg_min_humidity.2',
                     'avg_min_humidity.3', 'avg_min_humidity.4', 'avg_min_humidity.5',
                     'avg_min_humidity.6', 'avg_min_humidity.7',
                     'max_humidity_one', 'max_humidity_two', 
                     'max_humidity_three', 'max_humidity_four',
                     'max_humidity_five', 'max_humidity_six',
                     'max_humidity_seven',
                     'avg_max_humidity.2',
                     'avg_max_humidity.3', 'avg_max_humidity.4', 'avg_max_humidity.5',
                     'avg_max_humidity.6', 'avg_max_humidity.7',
                     'avg_humidity_one', 'avg_humidity_two',
                     'avg_humidity_three', 'avg_humidity_four',
                     'avg_humidity_five', 'avg_humidity_six',
                     'avg_humidity_seven', 'avg_avg_humidity.2',
                     'avg_avg_humidity.3', 'avg_avg_humidity.4', 'avg_avg_humidity.5',
                     'avg_avg_humidity.6', 'avg_avg_humidity.7',
                     'min_temp_one', 'min_temp_two', 
                     'min_temp_three', 'min_temp_four',
                     'min_temp_five', 'min_temp_six',
                     'min_temp_seven', 'avg_min_temp.2', 'avg_min_temp.3',
                     'avg_min_temp.4', 'avg_min_temp.5', 'avg_min_temp.6', 'avg_min_temp.7',
                     'max_temp_one', 'max_temp_two', 
                     'max_temp_three', 'max_temp_four',
                     'max_temp_five', 'max_temp_six',
                     'max_temp_seven', 'avg_max_temp.2', 'avg_max_temp.3',
                     'avg_max_temp.4', 'avg_max_temp.5', 'avg_max_temp.6', 'avg_max_temp.7',
                     'avg_temp_one', 'avg_temp_two',
                     'avg_temp_three', 'avg_temp_four',
                     'avg_temp_five', 'avg_temp_six',
                     'avg_temp_seven', 'avg_avg_temp.2', 'avg_avg_temp.3',
                     'avg_avg_temp.4', 'avg_avg_temp.5', 'avg_avg_temp.6', 'avg_avg_temp.7',
                     'precip_one', 'precip_two',
                     'precip_three', 'precip_four',
                     'precip_five', 'precip_six',
                     'precip_seven', 'avg_precip.2', 'avg_precip.3',
                     'avg_precip.4', 'avg_precip.5', 'avg_precip.6', 'avg_precip.7']

    #create empty list to store the ordered data so that it matches training weather data
    ordered_data = []

    #for loop to get resepctive values for one and two days before prediction day,
    #as well as averages from one to 7 days before
    for i in columns:
        ordered_data.append(all_data[i][0])
        ordered_data.append(all_data[i][1])
        ordered_data.append(all_data[i][2])
        ordered_data.append(all_data[i][3])
        ordered_data.append(all_data[i][4])
        ordered_data.append(all_data[i][5])
        ordered_data.append(all_data[i][6])
        ordered_data.append((all_data[i][0] + all_data[i][1]) / 2)
        ordered_data.append((all_data[i][0] + all_data[i][1] + all_data[i][2])/ 3)
        ordered_data.append((all_data[i][0] + all_data[i][1] + all_data[i][2] + all_data[i][3])/ 4)
        ordered_data.append((all_data[i][0] + all_data[i][1] + all_data[i][2] + all_data[i][3] +
               all_data[i][4])/ 5)
        ordered_data.append((all_data[i][0] + all_data[i][1] + all_data[i][2] + all_data[i][3] +
               all_data[i][4] + all_data[i][5])/ 6)
        ordered_data.append((all_data[i][0] + all_data[i][1] + all_data[i][2] + all_data[i][3] +
               all_data[i][4] + all_data[i][5] + all_data[i][6])/ 7)

    #make collected data into dataframe with stored column headings
    ordered_df = pd.DataFrame(columns = ordered_columns)
    ordered_df.loc[0] = ordered_data

    #return the ordered data after running this function
    return ordered_df

