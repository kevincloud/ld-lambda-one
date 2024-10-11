import time
import os
import boto3


ddb_table = boto3.resource("dynamodb").Table(os.environ["DDB_TABLE"])
logs = boto3.client("logs")


def cwlog(message):
    LOG_GROUP = os.environ["LOG_GROUP"]
    LOG_STREAM = "ApplicationLogs"
    global logs
    timestamp = int(round(time.time() * 1000))

    logs.put_log_events(
        logGroupName=LOG_GROUP,
        logStreamName=LOG_STREAM,
        logEvents=[
            {
                "timestamp": timestamp,
                "message": time.strftime("%Y-%m-%d %H:%M:%S") + "\t" + message,
            }
        ],
    )


def lambda_handler(event, context):
    global ddb_table
    cwlog("Get data from DDB table")
    item = ddb_table.get_item(Key={"SessionId": os.environ["SESSIONID"]})
    rec = item["Item"]
    retval = (
        '{"number": '
        + str(int(rec["NumberItem"]))
        + ', "letter": "'
        + rec["AlphaItem"]
        + '"}'
    )
    cwlog("Data retrieved")

    return {"isBase64Encoded": False, "statusCode": 200, "body": retval}
