import zips
from get_forecast import get_forecast
import psycopg2
from psycopg2.extras import Json

#establish a connection to the database of interest where table is present
conn = psycopg2.connect("host=localhost dbname=weather_app user=mishralab password=rainbow")
cur = conn.cursor()

zips = zips.selected_zips
for zip in zips:
    zip_forecast = get_forecast(zip)
    zip_code = zip

    #insert data into table
    cur.execute("INSERT INTO zip_forecast_app (zip_code, forecast) VALUES (%s, %s)", [str(zip_code), Json(zip_forecast)])

#commit any changes made to database
conn.commit()

#close the cursor
cur.close()

#close the connection
conn.close()
