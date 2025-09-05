import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')

def decimal_default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError

def handler(event, context):
    table = dynamodb.Table('serverless-products-dev')
    product_id = event['pathParameters']['id']
    data = json.loads(event['body'])
    
    # Build update expression dynamically
    update_expr = "SET "
    expr_values = {}
    for key, value in data.items():
        if key != 'id':  # Don't update the ID
            update_expr += f"{key} = :{key}, "
            expr_values[f":{key}"] = value
    
    update_expr = update_expr.rstrip(', ')  # Remove trailing comma
    
    try:
        response = table.update_item(
            Key={'id': product_id},
            UpdateExpression=update_expr,
            ExpressionAttributeValues=expr_values,
            ReturnValues="ALL_NEW"
        )
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps(response['Attributes'], default=decimal_default)
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