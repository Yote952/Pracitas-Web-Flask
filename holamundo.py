import pymysql
from app import app
from dbconfig import mysql
from werkzeug.security import generate_password_hash, check_password_hash
#from flask import *
from flask import request, render_template, flash, redirect
#app = Flask(__name__)
app.debug = True
def registar():
    redirect("/")

@app.route("/register")
def register():
    return render_template("Registro.html")

@app.route('/show')
def show():
    conn = None
    cursor = None
    try:
        if request.method == 'POST':
            nf = request.form['nf']
            nl = request.form['nl']
            print('nombre el' + nf, nl)
            conn = mysql.connect()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.execute("select * from empleados")
            rows = cursor.fetchall()
            print(rows)
        #return render_template("out.html",f=nf,l=nl)
    except Exception as e:
        print('Error:' +e.message)

@app.route("/")
def main():
    return render_template('login.html')

@app.route("/getValores")
def getValores():
    name = request.args.get('name', 52)
    lastname = request.args.get('lastname', 26)
    middlename = request.args.get('middlename',26)
    phone = request.args.get('phone',10)
    postal = request.args.get('postal',8)
    gender = request.args.get('gender',15)
    country = request.args.get('country',52)
    city = request.args.get('city',52)
    street = request.args.get('street',128)
    suburb = request.args.get('suburb',128)
    polity = request.args.get('polity',128)
    return render_template('init.html',
        name=name,
        lastname=lastname,
        middlename=middlename,
        phone=phone,
        postal=postal,
        gender=gender,
        country=country,
        polity=polity,
        city=city,
        street=street,
        suburb=suburb)

if __name__ == "__main__":
    app.run()