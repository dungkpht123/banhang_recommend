import os

from flask import Flask,request,jsonify
from flask_cors import CORS
import recommendation

app = Flask(__name__)
CORS(app)


@app.route('/recommend', methods=['GET'])
def recommend_movies():
    res = recommendation.result(int(request.args.get('user_id')), 10)
    # res = recommendation.result(request.args.get('user_id'), 10)
    return jsonify(res)

@app.route('/cb_recommend', methods=['GET'])
def recommend_cb():
    res = recommendation.CB_result(int(request.args.get('product_id')))
    # res = recommendation.result(request.args.get('user_id'), 10)
    return jsonify(res)


if __name__ == '__main__':
    port = os.environ.get('PORT', 5000)
    app.run(port=port, debug=True)