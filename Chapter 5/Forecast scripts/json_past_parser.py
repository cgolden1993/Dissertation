import numpy as np
import pandas as pd

def json_past(json):
    
    weather = json['data']

    #create empty lists
    temp = []
    humidity = []
    wind_speed = []
    gust_speed =[]
    precip = []
    
    #fill each list with observed weather on date of interest
    for hour in weather:
        temp.append(hour['temperature'])
        humidity.append(hour['humidity'])
        wind_speed.append(hour['windSpeed'])
        gust_speed.append(hour['windGust'])
        precip.append(hour['precipIntensity'])

    temp = np.asarray(temp).reshape(1,len(weather))
    humidity = np.asarray(humidity).reshape(1,len(weather))
    humidity = humidity * 100
    wind_speed = np.asarray(wind_speed).reshape(1, len(weather))
    gust_speed = np.asarray(gust_speed).reshape(1, len(weather))
    precip = np.asarray(precip).reshape(1, len(weather))
    
    #get avg, min, and max of each variable of interest
    #in each array the first value represents the first day of forecasted weather
    max_wind_speed = np.amax(wind_speed, axis = 1)
    avg_wind_speed = np.mean(wind_speed, axis = 1)
    max_gust_speed = np.amax(gust_speed, axis = 1)
    min_humidity = np.amin(humidity, axis = 1)
    max_humidity = np.amax(humidity, axis = 1)
    avg_humidity = np.mean(humidity, axis = 1)
    min_temp = np.amin(temp, axis = 1)
    max_temp = np.amax(temp, axis = 1)
    avg_temp = np.mean(temp, axis = 1)
    precip_total = np.sum(precip, axis = 1)
    all_data = np.vstack((max_wind_speed, avg_wind_speed, max_gust_speed, min_humidity,
               max_humidity, avg_humidity, min_temp, max_temp, avg_temp, precip_total)).reshape(1, 10)

    columns = ['max_wind_speed', 'avg_wind_speed', 'max_gust_speed', 'min_humidity',
               'max_humidity', 'avg_humidity', 'min_temp', 'max_temp', 'avg_temp',
               'precip_total']

    all_data = pd.DataFrame(all_data, columns=columns)
    
    return(all_data)
