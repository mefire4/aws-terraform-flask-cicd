from flask import Flask, request, jsonify
import boto3
import uuid

app = Flask(__name__)
dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
table = dynamodb.Table('items-table')

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'}), 200

@app.route('/items', methods=['GET'])
def get_items():
    response = table.scan()
    return jsonify(response.get('Items', [])), 200

@app.route('/items', methods=['POST'])
def add_item():
    data = request.get_json()
    item_id = str(uuid.uuid4())
    table.put_item(Item={
        'item_id': item_id,
        'nom': data.get('nom', ''),
        'description': data.get('description', '')
    })
    return jsonify({'item_id': item_id, 'message': 'Item ajouté'}), 201

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)