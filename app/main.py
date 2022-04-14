from flask import Flask
from pymongo import MongoClient
from bson import json_util
import json 
import random

server_id = random.randint(1000, 9999)
while True:
    try:
        client = MongoClient("mongodb://db.osama.devops106:27017")
        break
    except Exception as e:
        print("Trying to create a connection to the database") 
        time.sleep(2)
    

db = client.spartans

flask_app = Flask(__name__)


@flask_app.route('/')
def home_page():
    return f"This is the Home Page of Flask + MongoDB from Server: {server_id}"
    
@flask_app.route('/add/<username>')
def add_user(username):
    data = {'username': username, 'active': True}
    record = db.clients_data.insert_one(data)
    print(record)
    return f"The username that will be added is {username}"

def parse_json(data):
    return json.loads(json_util.dumps(data))
    
@flask_app.route('/isActive/<username>')
def check_if_active(username):
    records = db.clients_data.find({'username': username})
    print(db.clients_data.count_documents({'username': username}))
    return parse_json(records[0])

if __name__ == "__main__":
    flask_app.run(debug= True, port = 8080, host="0.0.0.0")