from datetime import datetime, timezone

from flask import Flask, jsonify, request

app = Flask(__name__)


def get_client_ip():
    """
    Return the real client IP when behind an AWS ALB.
    """
    forwarded_for = request.headers.get("X-Forwarded-For")

    if forwarded_for:
        return forwarded_for.split(",")[0].strip()

    return request.remote_addr


@app.route("/", methods=["GET"])
def index():
    return jsonify(
        {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "ip": get_client_ip(),
        }
    )


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        {
            "status": "healthy"
        }
    ), 200


if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=8080,
    )