from flask import Flask, request, jsonify, render_template
import os
import requests
import json
import pusher
import google.cloud.dialogflow as dialogflow

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/pick_one')
def pick_page():
    return render_template('pick_one_subject.html')


@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.get_json(silent=True)
    if data['queryResult']['queryText'] == 'yes':
        reply = {
            "fulfillmentText": "Ok. Tickets booked successfully.",
        }
        return jsonify(reply)

    elif data['queryResult']['queryText'] == 'no':
        reply = {
            "fulfillmentText": "Ok. Booking cancelled.",
        }
        return jsonify(reply)


def detect_intent_texts(project_id, session_id, text, language_code):
    session_client = dialogflow.SessionsClient()
    session = session_client.session_path(project_id, session_id)

    if text:
        text_input = dialogflow.TextInput(
            text=text, language_code=language_code)
        query_input = dialogflow.QueryInput(text_input)
        response = session_client.detect_intent(
            session=session, query_input=query_input)
        return response.query_result.fulfillment_text

    @app.route('/send_message', methods=['POST'])
    def send_message():
        message = request.form['message']
        project_id = os.getenv('DIALOGFLOW_PROJECT_ID')
        fulfillment_text = detect_intent_texts(project_id, "unique", message, 'en')
        response_text = {"message": fulfillment_text}
        return jsonify(response_text)


# run Flask app
if __name__ == "__main__":
    app.run()
