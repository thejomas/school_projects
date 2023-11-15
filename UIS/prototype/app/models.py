from app import conn, login_manager
from flask_login import UserMixin
from psycopg2 import sql


@login_manager.user_loader
def load_user(user_id):
    cur = conn.cursor()

    schema = 'patient'
    id = 'cpr_nr'

    user_sql = sql.SQL("""
    SELECT * FROM {}
    WHERE {} = %s
    """).format(sql.Identifier(schema),  sql.Identifier(id))

    cur.execute(user_sql, (int(user_id),))
    if cur.rowcount > 0:
        return Patient(cur.fetchone())
    else:
        return None


class Patient(tuple, UserMixin):
    def __init__(self, user_data):
        self.cpr_nr = user_data[0]
        self.password = user_data[1]
        self.name = user_data[2]

    def get_id(self):
        return (self.cpr_nr)


def select_patients(cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT * FROM patient
    WHERE cpr_nr = %s
    """
    cur.execute(sql, (cpr_nr,))
    user = Patient(cur.fetchone()) if cur.rowcount > 0 else None
    cur.close()
    return user


def select_questionnaires(cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT * FROM questionnaire
    WHERE patient_cpr_nr = %s
    """
    cur.execute(sql, (cpr_nr,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset


def select_questionnaire(q_id, cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT * FROM questionnaire
    WHERE id = %s AND patient_cpr_nr = %s
    """
    cur.execute(sql, (q_id, cpr_nr))
    tuple_resultset = cur.fetchone()
    cur.close()
    return tuple_resultset


def select_answers(q_id):
    cur = conn.cursor()
    sql = """
    SELECT question, value
    FROM many2many_q_qrow m2m
    LEFT JOIN questionnaire_row row on row.id =     m2m.questionnaire_row_id
    LEFT JOIN questionnaire_answer answer on    answer.many2many_q_qrow_id = m2m.id
    WHERE questionnaire_id = %s
    """
    cur.execute(sql, (q_id,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset


def select_appointments(cpr_nr):
    cur = conn.cursor()
    sql = """
    SELECT date, time, name
    FROM appointment a
    LEFT JOIN doctor d on d.id = a.doctor_id
    WHERE patient_cpr_nr = %s
    ORDER by date
    """
    cur.execute(sql, (cpr_nr,))
    tuple_resultset = cur.fetchall()
    cur.close()
    return tuple_resultset
