import json
import os
import signal
import sys
import time
import boto3
import ldclient
from ldclient.config import Config


logs = boto3.client('logs')

ldclient.set_config(Config(os.environ['LD_SDK_KEY']))

if ldclient.get().is_initialized():
    print("SDK successfully initialized!")
else:
    print("SDK failed to initialize")


def shut_down(signum, frame):
    print("[runtime] SIGTERM received")
    print("[runtime] cleaning up")

    ldclient.get().close()

    time.sleep(0.2)

    print("[runtime] exiting")
    sys.exit(0)


signal.signal(signal.SIGTERM, shut_down)


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


def inc_number(mynumber):
    num = int(mynumber) + 1
    if num > 99:
        num = 1
    cwlog("NumberItem updated in DOM")
    return num


def inc_alpha(myletter):
    alpha = myletter
    nextc = chr(ord(alpha) + 1)
    if ord(nextc) > 90:
        nextc = 'A'
    cwlog("AlphaItem updated in DOM")
    return nextc


def get_flag():
    user_context = {
        "key": os.environ["SESSIONID"],
        "custom": {
            "user-type": "beta",
            "location": "GA"
        }
    }

    return ldclient.get().variation("incNumber", user_context, False)


def get_dbvalues(nn, nc):
    return json.dumps({
        'number': int(nn),
        'letter': str(nc)
    })


def lambda_handler(event, context):
    params = json.loads(event['body'])
    nn = int(params['mynumber'])
    nc = params['myletter']
    cwlog("Retrieve the flag")
    update_number = get_flag()
    cwlog("Flag was retrieved")

    if update_number == True:
        nn = inc_number(nn)
    else:
        nc = inc_alpha(nc)

    ldclient.get().flush()

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
