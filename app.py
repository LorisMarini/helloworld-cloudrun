import os

from flask import Flask
from flask import send_from_directory

app = Flask(__name__, static_url_path='')

@app.route('/')
def hello_world():
    target = os.environ.get('TARGET', 'World')
    return 'Hello {}!\n'.format(target)

@app.route('/<path:filename>')
def serve_static(filename):
    # https://flask.palletsprojects.com/en/1.1.x/api/?highlight=send_from_directory#flask.send_from_directory
    return send_from_directory("./static", filename)

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 8080)))
