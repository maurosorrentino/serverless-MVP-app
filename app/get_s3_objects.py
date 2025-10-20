import boto3
import os
import logging
import json

s3_resource = boto3.resource("s3")
# CRITICAL = 50
# ERROR = 40
# WARNING = 30
# INFO = 20
# DEBUG = 10
# NOTSET = 0
log_level = os.environ.get("LOG_LEVEL") or 20

logger = logging.getLogger()
logger.setLevel(log_level)

def get_objects(bucket):
    return [obj.key for obj in bucket.objects.all()]

def lambda_handler(event, context):
    logger.info("Lambda function started.")
    
    bucket_name = os.environ.get("BUCKET_NAME")
    
    if not bucket_name:
        logger.error("Environment variable BUCKET_NAME not found.")
        return {"statusCode": 500, "error": "env var not found"}
    
    logger.info(f"Using bucket: {bucket_name}")
    
    try:
        bucket = s3_resource.Bucket(bucket_name)
        objects = get_objects(bucket)
        logger.info(f"Retrieved {len(objects)} objects from bucket {bucket_name}.")
    except Exception as e:
        logger.exception(f"Error accessing bucket {bucket_name}: {str(e)}")
        return {"statusCode": 500, "error": "Bucket access error"}
    
    logger.info("Lambda execution completed successfully.")
    return {"statusCode": 200, "body": json.dumps({"objects": objects})}
