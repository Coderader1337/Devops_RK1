from flask import Flask, jsonify
import json
import os

app = Flask(__name__)

def load_products():
    with open('products.json', 'r', encoding='utf-8') as f:
        return json.load(f)

@app.route('/health')
def health():
    return jsonify({"status": "ok"})

@app.route('/products')
def get_products():
    products = load_products()
    return jsonify(products)

@app.route('/products/<int:product_id>')
def get_product(product_id):
    products = load_products()
    product = next((p for p in products if p['id'] == product_id), None)
    if product:
        return jsonify(product)
    return jsonify({"error": "Product not found"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
