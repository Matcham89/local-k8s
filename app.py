# app.py
from flask import Flask, render_template_string
import os

app = Flask(__name__)

@app.route("/")
def home():
    app_message = os.getenv("APP_MESSAGE", "Default Message")
    secret = os.getenv("SECRET", "Not Connected")
    other_secret = os.getenv("OTHER_SECRET", "Not Set")

    # HTML Template to render in the browser
    html_template = """
    <html>
    <head><title>{{ title }}</title></head>
    <body>
        <h1>{{ app_message }}</h1>
        <p><strong>Vault Secret:</strong> {{ secret }}</p>
        <p><strong>Other Secret:</strong> {{ other_secret }}</p>
    </body>
    </html>
    """
    return render_template_string(html_template, 
                                  title="Application-A", 
                                  app_message=app_message, 
                                  secret=secret, 
                                  other_secret=other_secret)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
