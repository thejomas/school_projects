from flask import render_template, url_for, flash, redirect, request, Blueprint
from app import bcrypt
from app.forms import PatientLoginForm
from app.models import select_patients
from flask_login import login_user, current_user, logout_user

Login = Blueprint('Login', __name__)


@Login.route("/")
@Login.route("/home")
def home():
    return render_template('home.html')


@Login.route("/login", methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('Login.home'))
    form = PatientLoginForm()
    if form.validate_on_submit():
        user = select_patients(form.id.data)
        if user is not None and bcrypt.check_password_hash(user[1], form.password.data):
            login_user(user, remember=form.remember.data)
            flash('Login successful.', 'success')
            next_page = request.args.get('next')
            return redirect(next_page) if next_page else redirect(url_for('Login.home'))
        else:
            flash('Login Unsuccessful. Please check identifier and password', 'danger')
    return render_template('login.html', title='Login', form=form)


@Login.route("/logout")
def logout():
    logout_user()
    return redirect(url_for('Login.home'))
