from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "hello world"

@app.route('/healthz')
def healthz():
    return "OK", 200  # Risposta per la liveness probe

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
