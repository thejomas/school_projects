from flask import render_template, url_for, flash, redirect, request, Blueprint
from app.models import select_questionnaires, select_questionnaire, select_answers, select_appointments
from flask_login import current_user

Patient = Blueprint('Patient', __name__)


@Patient.route("/questionnaires", methods=['GET'])
def questionnaires():
    if not current_user.is_authenticated:
        flash('Please Login.', 'danger')
        return redirect(url_for('Login.login'))
    cpr_nr = current_user.get_id()
    questionnaires = select_questionnaires(cpr_nr)

    return render_template('questionnaires.html', title='Questionnaires', questionnaires=questionnaires)


@Patient.route("/questionnaires/<int:q_id>", methods=['GET'])
def questionnaire(q_id):
    if not current_user.is_authenticated:
        flash('Please Login.', 'danger')
        return redirect(url_for('Login.login'))
    cpr_nr = current_user.get_id()
    questionnaire = select_questionnaire(q_id, cpr_nr)
    if questionnaire is None:
        return redirect(url_for('Patient.questionnaires'))
    answers = select_answers(q_id)

    return render_template('questionnaire.html', title='Questionnaire', questionnaire=questionnaire, answers=answers)


@Patient.route("/appointments", methods=['GET'])
def appointments():
    if not current_user.is_authenticated:
        flash('Please Login.', 'danger')
        return redirect(url_for('Login.login'))

    cpr_nr = current_user.get_id()
    appointments = select_appointments(cpr_nr)

    return render_template('appointments.html', title='Appointments', appointments=appointments)
