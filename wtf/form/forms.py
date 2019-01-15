from flask_wtf import Form
from wtforms import StringField, validators, SubmitField, PasswordField
from wtforms.fields.html5 import EmailField


class LoginForm(Form):
    login = StringField("Login :", [validators.DataRequired("Required")])
    password = PasswordField("Password :", [validators.DataRequired("Required")])
    submit = SubmitField("Sign in")


class RegistrationForm(Form):
    id_code = StringField("ID code :", [validators.DataRequired("Required")])
    last_name = StringField("Last name :", [validators.DataRequired("Required")])
    first_name = StringField("First name :", [validators.DataRequired("Required")])
    login = StringField("Login :", [validators.DataRequired("Required")])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    ])
    confirm = PasswordField('Confirm Password')
    email = EmailField("Email :", [validators.DataRequired("Required"), validators.Email("Please enter your email.")])


class ProfileForm(Form):
    id_code = StringField()
    last_name = StringField("Last name :")
    first_name = StringField("First name :")
    login = StringField("Login :")
    email = EmailField("Email :")


class PasswordForm(Form):
    id_code = StringField()
    old_password = PasswordField("Old password :")
    new_password = PasswordField("New password :", [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords do not match')
    ])
    confirm = PasswordField("Confirm :")


