import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    table_name = os.environ['TABLE_NAME']
    table = dynamodb.Table(table_name)
    product_id = event['pathParameters']['id']
    
    try:
        table.delete_item(Key={'id': product_id})
        return {
            'statusCode': 204,
            'headers': {
                'Access-Control-Allow-Origin': '*'
            }
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