"""Weather App"""

import json
from flask import Flask, request, render_template, session
import requests
import reverse_geocoder
import country_converter

#Flask application object
app = Flask(__name__)
app.secret_key = 'secret_key'

@app.route('/', methods = ["GET", "POST"])
def index():

    """index function routes to index.html"""

    if request.method == "POST":

        location = request.form.get("q")
        
        try:
            data = get_api_data(location)
            days = data['days']
            session['location'] = f"{location}, {get_country(data)}"
            session['data'] = data

            return render_template("index.html", days=days, location=f"Report for: {session['location']}")

        except json.decoder.JSONDecodeError:
            if location == "world_stats":
                return render_template("index.html", location="You should be more specific")

            return render_template("index.html", location=f"An exception occured")

    return render_template("index.html", location="Welcome to Flask Weather!")

def get_api_data(location):

    """connects to API and returns json with data"""

    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
    prm = "next7days?unitGroup=metric&elements=datetime%2Ctempmax%2Ctempmin%2Chumidity&include=days"
    response_type = "&contentType=json"
    key = "&key=WHFH3BH7G5K5KAKVDRCCTAKMT"
    response = requests.request("GET", f"{url}/{location}/{prm}{key}{response_type}")

    return response.json()

def get_country(data):

    """translates coordinates to country name"""

    coordinates = (data['latitude'], data['longitude'])
    country_data = reverse_geocoder.search(coordinates)
    country = country_converter.convert(names=country_data[0]['cc'], to='name_short')

    return country

if __name__ == '__main__':
    app.run(host='0.0.0.0')
