import json
import os
import boto3


ddb_table = boto3.resource('dynamodb').Table(os.environ["DDB_TABLE"])


def lambda_handler(event, context):
    global ddb_table
    item = ddb_table.get_item(Key={'SessionId': os.environ["SESSIONID"]})
    rec = item["Item"]
    retval = '{"number": ' + \
        str(int(rec["NumberItem"])) + ', "letter": "' + rec["AlphaItem"] + '"}'

    return {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,GET,POST'
        },
        'body': retval
    }
