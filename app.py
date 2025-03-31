from flask import Flask, jsonify, request
import requests
from flask_cors import CORS
import random
from datetime import datetime

app = Flask(__name__)
CORS(app)

trades = []  # In-memory trade history list

@app.route("/")
def home():
    return "Flask backend is running."

@app.route("/price")
def get_price():
    try:
        url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
        response = requests.get(url)
        data = response.json()
        price = data["bitcoin"]["usd"]
        return jsonify({"price": price})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/orderbook")
def get_orderbook():
    try:
        url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
        response = requests.get(url)
        data = response.json()
        base_price = data["bitcoin"]["usd"]

        orderbook = []
        for _ in range(20):
            price_fluctuation = random.uniform(-100, 100)
            order_price = round(base_price + price_fluctuation, 2)
            quantity = round(random.uniform(0.1, 0.5), 4)
            order_type = random.choice(["BUY", "SELL"])
            orderbook.append({
                "type": order_type,
                "price": order_price,
                "quantity": quantity
            })

        return jsonify(orderbook)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ✅ POST /trade - store a new trade
@app.route("/trade", methods=["POST"])
def post_trade():
    try:
        data = request.get_json()
        trade_type = data.get("type")
        price = float(data.get("price"))
        quantity = float(data.get("quantity"))
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        trade = {
            "type": trade_type,
            "price": price,
            "quantity": quantity,
            "timestamp": timestamp
        }

        trades.append(trade)
        return jsonify({"message": "Trade recorded", "trade": trade}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# ✅ GET /trades - return all stored trades
@app.route("/trades", methods=["GET"])
def get_trades():
    return jsonify(trades)

if __name__ == "__main__":
    print("Starting Flask API server...")
    app.run(debug=True, port=5050)
