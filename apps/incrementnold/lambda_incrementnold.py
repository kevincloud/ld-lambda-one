import json
import os
import sys
import time
import boto3


ddb_table = boto3.resource('dynamodb').Table(os.environ["DDB_TABLE"])
logs = boto3.client('logs')


def cwlog(message):
    LOG_GROUP = os.environ['LOG_GROUP']
    LOG_STREAM = 'ApplicationLogs'
    global logs
    timestamp = int(round(time.time() * 1000))

    logs.put_log_events(
        logGroupName=LOG_GROUP,
        logStreamName=LOG_STREAM,
        logEvents=[
            {
                'timestamp': timestamp,
                'message': time.strftime('%Y-%m-%d %H:%M:%S')+'\t'+message
            }
        ]
    )


def inc_number():
    global ddb_table
    item = ddb_table.get_item(Key={'SessionId': os.environ["SESSIONID"]})
    rec = item["Item"]
    num = int(rec["NumberItem"]) + 1
    ddb_table.update_item(
        Key={'SessionId': os.environ["SESSIONID"]},
        UpdateExpression="set NumberItem = :g",
        ExpressionAttributeValues={
            ':g': num
        },
        ReturnValues="UPDATED_NEW"
    )
    cwlog("NumberItem updated in DDB Table")
    return num


def inc_alpha():
    global ddb_table
    item = ddb_table.get_item(Key={'SessionId': os.environ["SESSIONID"]})
    rec = item["Item"]
    listchr = list(rec["AlphaItem"])
    alpha = listchr[0]
    nextc = chr(ord(alpha) + 1)
    if ord(nextc) > 90:
        nextc = 'A'
    ddb_table.update_item(
        Key={'SessionId': os.environ["SESSIONID"]},
        UpdateExpression="set AlphaItem = :g",
        ExpressionAttributeValues={
            ':g': nextc
        },
        ReturnValues="UPDATED_NEW"
    )
    cwlog("AlphaItem updated in DDB Table")
    return nextc


def get_dbvalues(nn, nc):
    return json.dumps({
        'number': int(nn),
        'letter': str(nc)
    })


def lambda_handler(event, context):
    nn = inc_number()
    nc = inc_alpha()

    return {
        'isBase64Encoded': False,
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'OPTIONS,GET,POST'
        },
        'body': get_dbvalues(nn, nc)
    }
