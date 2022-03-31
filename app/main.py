from flask import Flask
from pymongo import MongoClient

with open("database.config") as config_file:
    database_url = config_file.read().strip()
    
print(f"DB URL: {database_url}")
client = MongoClient(database_url)

db = client.spartans

flask_app = Flask(__name__)


@flask_app.route('/')
def home_page():
    return "This is the Home Page of Flask + MongoDB"
    
@flask_app.route('/add/<username>')
def add_user(username):
    data = {'username': username, 'active': True}
    record = db.clients_data.insert_one(data)
    print(record)
    return f"The username that will be added is {username}"

@flask_app.route('/isActive/<username>')
def check_if_active(username):
    record = db.clients_data.find({'username': username})

if __name__ == "__main__":
    flask_app.run(debug= True, port = 8080, host="0.0.0.0")