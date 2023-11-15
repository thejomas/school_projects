from flask import Flask
import psycopg2
from flask_bcrypt import Bcrypt
from flask_login import LoginManager

app = Flask(__name__)
app.config['SECRET_KEY'] = 'fc089b9218301ad987914c53481bff04'
# set your own database
db = "dbname='uis' user='postgres' host='localhost' password = 'postgres'"
conn = psycopg2.connect(db)


bcrypt = Bcrypt()
login_manager = LoginManager()

login_manager.login_view = 'login'
login_manager.login_message_category = 'info'

bcrypt.init_app(app)
login_manager.init_app(app)

from app.Login.routes import Login
from app.Patient.routes import Patient

app.register_blueprint(Login)
app.register_blueprint(Patient)
