# server.py
import os
import threading
import time

from flask import Flask, request, jsonify

from basketball_analyzer import process_video
from store_manager import Database

db = Database()
app = Flask(__name__)
collection = 'NetInsight'

@app.route('/')
def home():
    return 'Basketball server'


@app.route('/analyze', methods=['POST', 'GET'])
def analyze_video():
    uploaded_video = request.files.get('video')
    userid = request.form.get('userId')  # Get the userid from the request
    if not uploaded_video:
        return jsonify({'error': 'No video file uploaded'}), 400
    if not userid:
        return jsonify({'error': 'No userid provided'}), 400

    # Save the uploaded video to a temporary location
    video_path = uploaded_video.filename
    uploaded_video.save(video_path)

    # Start a new thread to process the video
    processing_thread = threading.Thread(target=process_and_send_results, args=(video_path, userid))
    processing_thread.start()

    # Return immediate response to the frontend
    return jsonify({'message': 'Video processing started...'})


def process_and_send_results(video_path, userid):
    # Process the video
    result = process_video(video_path, db)
    timestamp = time.time()
    # Remove the temporary video file
    if os.path.isfile(video_path):
        os.remove(video_path)

    db.update_firestore(userid=userid, collection=collection, data={'is_processing': False, str(timestamp): result})


if __name__ == '__main__':
    app.run(host='0.0.0.0')