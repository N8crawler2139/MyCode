from flask import Flask, request, send_from_directory
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)

UPLOAD_FOLDER = '/home/kali/Server/upload/'
HOSTED_FOLDER = '/home/kali/Server/hosted/'

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part', 400
    file = request.files['file']
    if file.filename == '':
        return 'No selected file', 400
    if file:
        filename = secure_filename(file.filename)
        file.save(os.path.join(UPLOAD_FOLDER, filename))
        return 'File successfully uploaded', 200

@app.route('/getfile/<filename>', methods=['GET'])
def get_file(filename):
    filename = secure_filename(filename)  # Sanitize the filename
    try:
        return send_from_directory(HOSTED_FOLDER, filename)
    except Exception as e:
        return str(e), 404

if __name__ == '__main__':
    app.run(debug=True, port=80)
