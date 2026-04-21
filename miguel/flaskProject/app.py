from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hola Mundo"
    # return "<p>Hello, World!</p>"

@app.route("/calculator")
def calc_page():
    return render_template("calc.html")
@app.route("/cv")
def cv_page():
    return render_template("cv.html")
