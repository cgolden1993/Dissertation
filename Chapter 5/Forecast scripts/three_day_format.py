import pandas as pd
import numpy as np

def three_day_format(df1, df2, df3, df4, df5):
    df2 = df2.rename(columns={"max_wind_speed": "max_wind_speed_one_ago",
                                "avg_wind_speed": "avg_wind_speed_one_ago",
                                "max_gust_speed": "max_gust_speed_one_ago",
                                "min_humidity": "min_humidity_one_ago",
                                "max_humidity": "max_humidity_one_ago",
                                "avg_humidity": "avg_humidity_one_ago",
                                "min_temp": "min_temp_one_ago",
                                "max_temp": "max_temp_one_ago",
                                "avg_temp": "avg_temp_one_ago",
                                "precip_total": "precip_total_one_ago"
                                })

    df3 = df3.rename(columns={"max_wind_speed": "max_wind_speed_two_ago",
                                "avg_wind_speed": "avg_wind_speed_two_ago",
                                "max_gust_speed": "max_gust_speed_two_ago",
                                "min_humidity": "min_humidity_two_ago",
                                "max_humidity": "max_humidity_two_ago",
                                "avg_humidity": "avg_humidity_two_ago",
                                "min_temp": "min_temp_two_ago",
                                "max_temp": "max_temp_two_ago",
                                "avg_temp": "avg_temp_two_ago",
                                "precip_total": "precip_total_two_ago"
                                })
    
    df4 = df4.rename(columns={"max_wind_speed": "max_wind_speed_three_ago",
                                "avg_wind_speed": "avg_wind_speed_three_ago",
                                "max_gust_speed": "max_gust_speed_three_ago",
                                "min_humidity": "min_humidity_three_ago",
                                "max_humidity": "max_humidity_three_ago",
                                "avg_humidity": "avg_humidity_three_ago",
                                "min_temp": "min_temp_three_ago",
                                "max_temp": "max_temp_three_ago",
                                "avg_temp": "avg_temp_three_ago",
                                "precip_total": "precip_total_three_ago"
                                })
    
    df5 = df5.rename(columns={"max_wind_speed": "max_wind_speed_four_ago",
                                "avg_wind_speed": "avg_wind_speed_four_ago",
                                "max_gust_speed": "max_gust_speed_four_ago",
                                "min_humidity": "min_humidity_four_ago",
                                "max_humidity": "max_humidity_four_ago",
                                "avg_humidity": "avg_humidity_four_ago",
                                "min_temp": "min_temp_four_ago",
                                "max_temp": "max_temp_four_ago",
                                "avg_temp": "avg_temp_four_ago",
                                "precip_total": "precip_total_four_ago"
                                })

    result = pd.concat([df1, df2, df3, df4, df5], axis = 1)
    
    result = result.drop(result.columns[[0,1,2,3,7,8,9,10,11,12,13,14,15,16,20,21,22,23,24,25,
                                         26,27,28,29,33,34,35,36,37,38,39,40,41,42,46,47,
                                         48,49,50,51,52,53,54,55,59,60,61,62,63,64,65,66,67,68,
                                         72,73,74,75,76,77,78,79,80,81,85,86,87,88,89,
                                         90,91,92,93,94,98,99,100,101,102,103,104,105,106,107,
                                         111,112,113,114,115,116,117,118,119,120,124,125,
                                         126,127,128,129]], axis=1)

    result = result[[
                     'max_wind_speed_five',
                     'max_wind_speed_six',
                     'max_wind_speed_seven',
                     'max_wind_speed_one_ago',
                     'max_wind_speed_two_ago',
                     'max_wind_speed_three_ago',
                     'max_wind_speed_four_ago',
                     'avg_wind_speed_five',
                     'avg_wind_speed_six',
                     'avg_wind_speed_seven',
                     'avg_wind_speed_one_ago',
                     'avg_wind_speed_two_ago',
                     'avg_wind_speed_three_ago',
                     'avg_wind_speed_four_ago',
                     'max_gust_speed_five',
                     'max_gust_speed_six',
                     'max_gust_speed_seven',
                     'max_gust_speed_one_ago',
                     'max_gust_speed_two_ago',
                     'max_gust_speed_three_ago',
                     'max_gust_speed_four_ago',
                     'min_humidity_five',
                     'min_humidity_six',
                     'min_humidity_seven',
                     'min_humidity_one_ago',
                     'min_humidity_two_ago',
                     'min_humidity_three_ago',
                     'min_humidity_four_ago',
                     'max_humidity_five',
                     'max_humidity_six',
                     'max_humidity_seven',
                     'max_humidity_one_ago',
                     'max_humidity_two_ago',
                     'max_humidity_three_ago',
                     'max_humidity_four_ago',
                     'avg_humidity_five',
                     'avg_humidity_six',
                     'avg_humidity_seven',
                     'avg_humidity_one_ago',
                     'avg_humidity_two_ago',
                     'avg_humidity_three_ago',
                     'avg_humidity_four_ago',
                     'min_temp_five',
                     'min_temp_six',
                     'min_temp_seven',
                     'min_temp_one_ago',
                     'min_temp_two_ago',
                     'min_temp_three_ago',
                     'min_temp_four_ago',
                     'max_temp_five',
                     'max_temp_six',
                     'max_temp_seven',
                     'max_temp_one_ago',
                     'max_temp_two_ago',
                     'max_temp_three_ago',
                     'max_temp_four_ago',
                     'avg_temp_five',
                     'avg_temp_six',
                     'avg_temp_seven',
                     'avg_temp_one_ago',
                     'avg_temp_two_ago',
                     'avg_temp_three_ago',
                     'avg_temp_four_ago',
                     'precip_five',
                     'precip_six',
                     'precip_seven',
                     'precip_total_one_ago',
                     'precip_total_two_ago',
                     'precip_total_three_ago',
                     'precip_total_four_ago']]

    result = result.values
    result = np.asarray(result).reshape(7,10, order = 'F')
    
    columns = ['max_wind_speed', 'avg_wind_speed', 'max_gust_speed', 'min_humidity',
               'max_humidity', 'avg_humidity', 'min_temp', 'max_temp', 'avg_temp',
               'precip_total']

    all_data = pd.DataFrame(result, columns=columns)
    
    ordered_columns = ['max_wind_speed_one', 'max_wind_speed_two',
                       'avg_max_wind_speed.2',
                     'avg_max_wind_speed.3', 'avg_max_wind_speed.4', 'avg_max_wind_speed.5',
                     'avg_max_wind_speed.6', 'avg_max_wind_speed.7',
                     'avg_wind_speed_one', 'avg_wind_speed_two', 
                     'avg_avg_wind_speed.2',
                     'avg_avg_wind_speed.3', 'avg_avg_wind_speed.4', 'avg_avg_wind_speed.5',
                     'avg_avg_wind_speed.6', 'avg_avg_wind_speed.7',
                     'max_gust_speed_one', 'max_gust_speed_two', 
                     'avg_max_gust_speed.2',
                     'avg_max_gust_speed.3', 'avg_max_gust_speed.4', 'avg_max_gust_speed.5',
                     'avg_max_gust_speed.6', 'avg_max_gust_speed.7',
                     'min_humidity_one', 'min_humidity_two', 
                     'avg_min_humidity.2',
                     'avg_min_humidity.3', 'avg_min_humidity.4', 'avg_min_humidity.5',
                     'avg_min_humidity.6', 'avg_min_humidity.7',
                     'max_humidity_one', 'max_humidity_two', 
                     'avg_max_humidity.2',
                     'avg_max_humidity.3', 'avg_max_humidity.4', 'avg_max_humidity.5',
                     'avg_max_humidity.6', 'avg_max_humidity.7',
                     'avg_humidity_one', 'avg_humidity_two', 'avg_avg_humidity.2',
                     'avg_avg_humidity.3', 'avg_avg_humidity.4', 'avg_avg_humidity.5',
                     'avg_avg_humidity.6', 'avg_avg_humidity.7',
                     'min_temp_one', 'min_temp_two', 
                     'avg_min_temp.2', 'avg_min_temp.3',
                     'avg_min_temp.4', 'avg_min_temp.5', 'avg_min_temp.6', 'avg_min_temp.7',
                     'max_temp_one', 'max_temp_two', 
                     'avg_max_temp.2', 'avg_max_temp.3',
                     'avg_max_temp.4', 'avg_max_temp.5', 'avg_max_temp.6', 'avg_max_temp.7',
                     'avg_temp_one', 'avg_temp_two',
                     'avg_avg_temp.2', 'avg_avg_temp.3',
                     'avg_avg_temp.4', 'avg_avg_temp.5', 'avg_avg_temp.6', 'avg_avg_temp.7',
                     'precip_one', 'precip_two',
                    'avg_precip.2', 'avg_precip.3',
                     'avg_precip.4', 'avg_precip.5', 'avg_precip.6', 'avg_precip.7']
 
 
 
    ordered_data = []

    #for loop to get resepctive values for one and two days before prediction day,
    #as well as averages from one to 7 days before
    for i in columns:
        ordered_data.append(all_data[i][0])
        ordered_data.append(all_data[i][1])
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
    
    return ordered_df
                     
       