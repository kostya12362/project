import datetime
from flask import Flask, render_template, request, make_response, session, redirect, url_for, flash
from wtf.form.forms import LoginForm, RegistrationForm, ProfileForm, PasswordForm
from functools import wraps
from dao.userhelper import *


app = Flask(__name__)
app.secret_key='secret123'

repos = [
"23123123",
"123213123"
]

def is_logged_in(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'login' in session:
            return f(*args, **kwargs)
        elif request.cookies.get("cookiename") is not None:
            session['login'] = request.cookies.get("cookiename")
            return f(*args, **kwargs)
        else:
            flash('Please log in', 'danger')
            return redirect(url_for('login'))
    return wrap


@app.route('/', methods=["GET", "POST"])
@is_logged_in
def index():
    if request.method == "POST":
        repo = request.form["deep_link"]
        repos.append(repo)
    return render_template('mainPage.html', repos=repos)


@app.route('/login', methods=["GET", "POST"])
def login():

    form = LoginForm()
    if request.method == "POST":
        if not form.validate():
            return render_template('login.html', form=form)
        elif User().authorization(p_login=request.form["login"], p_password=request.form["password"]) == 'OK':
            expire_date = datetime.datetime.now()
            expire_date = expire_date + datetime.timedelta(days=1)
            response = make_response(redirect(url_for('index')))
            response.set_cookie("cookiename", request.form["login"], expires=expire_date)
            session['login'] = request.form['login']
            return response
        else:
            return render_template('login.html', form=form, error='Invalid login or password')
    else:
        return render_template('login.html', form=form)


@app.route('/logout')
def logout():
    session.pop('login', None)
    response = make_response(redirect(url_for('login')))
    response.set_cookie("cookiename", '', expires=0)
    return response


@app.route('/register', methods=["GET", "POST"])
def registration():
    form = RegistrationForm()
    if request.method == "POST" and form.validate():
        status = User().register(p_id_code=request.form["id_code"], p_last_name=request.form["last_name"],
                                 p_first_name=request.form["first_name"],
                                 p_email=request.form["email"], p_login=request.form["login"],
                                 p_password=request.form["password"])

        if status == 'OK':
            flash("You are registered", 'success')
            response = make_response(redirect(url_for('index')))
            return response
        else:
            flash(status, 'danger')
            return render_template('registration.html', form=form)
    else:
        return render_template('registration.html', form=form)


@app.route('/profile', methods=["GET", "POST"])
@is_logged_in
def profile():

    form = ProfileForm()
    user = User().get_user(p_login=session['login'])
    if request.method == "GET":
        if user is not None:
            form.id_code.data = user[0]
            form.last_name.data = user[1]
            form.first_name.data = user[2]
            form.login.data = user[3]
            form.email.data = user[5]

            return render_template('profile.html', form=form)
        else:
            return render_template('profile.html', form=form)
    elif request.method == "POST" and form.validate():
        status = User().update(p_id_code=user[0], p_last_name=request.form["last_name"],
                               p_first_name=request.form["first_name"],
                               p_email=request.form["email"], p_login=request.form["login"])
        if status == 'OK':
            flash("Update", 'success')
            session['login'] = request.form["login"]
            return render_template('profile.html', form=form)
        else:
            flash('Invalid info', 'danger')
            return render_template('profile.html', form=form)
    else:
        flash('Invalid info', 'danger')
        return render_template('profile.html', form=form)


@app.route('/password', methods=["GET", "POST"])
def password():

    form = PasswordForm()
    user = User().get_user(p_login=session['login'])
    if request.method == "GET":
            return render_template('password.html', form=form)
    elif request.method == "POST" and form.validate():
        status = User().update_password(p_id_code=user[0], p_old_password=request.form["old_password"],
                                        p_new_password=request.form["new_password"],
                                        )
        if status == 'OK':
            flash("Update", 'success')
            return render_template('password.html', form=form)
        else:
            flash('Invalid password', 'danger')
            return render_template('password.html', form=form)

if __name__ == '__main__':
    app.run(debug=True)
