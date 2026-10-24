import os
import psycopg2
from flask import Flask, request, jsonify

app = Flask(__name__)

DB_HOST = os.environ.get("DB_HOST", "postgres")
DB_NAME = os.environ.get("DB_NAME", "appdb")
DB_USER = os.environ.get("DB_USER", "appuser")
DB_PASS = os.environ.get("DB_PASS", "apppassword")


def get_db():
    return psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )


def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            content TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    conn.commit()
    cur.close()
    conn.close()


@app.route("/")
def home():
    return "<h1>Flask + Postgres + Nginx</h1><p>POST to /add with JSON {\"message\": \"hello\"} — GET /list to see all messages.</p>"


@app.route("/add", methods=["POST"])
def add():
    data = request.get_json()
    if not data or "message" not in data:
        return jsonify({"error": "send JSON with a message key"}), 400

    conn = get_db()
    cur = conn.cursor()
    cur.execute("INSERT INTO messages (content) VALUES (%s)", (data["message"],))
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"status": "saved", "message": data["message"]}), 201


@app.route("/list")
def list_messages():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT id, content, created_at FROM messages ORDER BY created_at DESC")
    rows = cur.fetchall()
    cur.close()
    conn.close()

    messages = [{"id": r[0], "content": r[1], "created_at": str(r[2])} for r in rows]
    return jsonify(messages)


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5005, debug=True)
