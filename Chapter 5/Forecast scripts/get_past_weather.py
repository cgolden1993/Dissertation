import requests
import config

def get_past_weather(zip, time):
    #get latitude and longitude of zip code
    zip_api = 'https://public.opendatasoft.com/api/records/1.0/search/?dataset=us-zip-code-latitude-and-longitude&facet=state&facet=timezone&facet=dst&q='
    zip_code = zip
    zip_url = zip_api + str(zip_code)

    #extract data from api
    zip_coord_json = requests.get(zip_url).json()
    geopoint = zip_coord_json['records'][0]['fields']['geopoint']

    #darksky api address
    #replace config.api_key with personal darksky api key
    forecast_api = 'https://api.darksky.net/forecast/'
    forecast_url = forecast_api + config.api_key + '/' + str(geopoint[0]) + ',' + str(geopoint[1]) + ',' + str(time) + '?units=si&exclude=currently,minutely,daily,alerts,flags&extend=hourly'

    #extract info from json and grab the hourly forecast
    forecast_json = requests.get(forecast_url).json()
    hourly_past = forecast_json['hourly']
    return hourly_past
    


