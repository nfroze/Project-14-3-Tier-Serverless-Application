import json
import boto3

dynamodb = boto3.resource('dynamodb')

def handler(event, context):
    table = dynamodb.Table('serverless-products-dev')
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