import json


def inc_number(mynumber):
    num = int(mynumber) + 1
    if num > 99:
        num = 1
    return num


def inc_alpha(myletter):
    alpha = myletter
    nextc = chr(ord(alpha) + 1)
    if ord(nextc) > 90:
        nextc = 'A'
    return nextc


def get_dbvalues(nn, nc):
    return json.dumps({
        'number': int(nn),
        'letter': str(nc)
    })


def lambda_handler(event, context):
    params = json.loads(event['body'])
    nn = inc_number(params['mynumber'])
    nc = inc_alpha(params['myletter'])

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
