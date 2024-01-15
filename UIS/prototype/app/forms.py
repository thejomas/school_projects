from flask_wtf import FlaskForm
from wtforms import PasswordField, SubmitField, BooleanField, IntegerField
from wtforms.validators import DataRequired


class PatientLoginForm(FlaskForm):
    id = IntegerField('cpr_nr', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')
