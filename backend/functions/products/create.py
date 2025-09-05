import json
import boto3
import os
import uuid

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    table_name = os.environ['TABLE_NAME']
    table = dynamodb.Table(table_name)
    data = json.loads(event['body'])
    
    item = {
        'id': str(uuid.uuid4()),
        'name': data['name'],
        'price': data['price'],
        'description': data.get('description', ''),
        'category': data.get('category', 'General'),
        'stock': data.get('stock', 0)
    }
    
    try:
        table.put_item(Item=item)
        return {
            'statusCode': 201,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps(item)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'error': str(e)})
        }