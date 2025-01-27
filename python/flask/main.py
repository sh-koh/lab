#!/usr/bin/env python

from flask import Flask, render_template
import os

app = Flask(__name__)


hostname = os.uname()[1]
user = os.environ.get("USER")


@app.route("/")
def main():
    data = {"hostname": hostname, "user": user}
    return render_template("index.html", title="poooog", data=data)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
