import zips
from get_forecast import get_forecast
import psycopg2
from psycopg2.extras import Json
import datetime

zips = zips.all_zips
for zip in zips:
    zip_forecast = get_forecast(zip)
    zip_code = zip

    #establish a connection to the database of interest where table is present
    conn = psycopg2.connect("host=localhost dbname=<your_db_name> user=<your_user_name> password=<your_password>")
    cur = conn.cursor()

    #insert data into table
    cur.execute("INSERT INTO hourly_forecast (zip_code, forecast) VALUES (%s, %s)", [str(zip_code), Json(zip_forecast)])

    #commit any changes made to database
    conn.commit()

    #close the cursor
    cur.close()

    #close the connection
    conn.close()

print("Upload completed on: " + str(datetime.datetime.now()))
