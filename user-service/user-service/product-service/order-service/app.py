from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"service": "Order Service", "status": "running"})

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

app.run(host="0.0.0.0", port=5003)
