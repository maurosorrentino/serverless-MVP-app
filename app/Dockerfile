# Use AWS Lambda base image for Python
FROM public.ecr.aws/lambda/python:3.11

COPY get_s3_objects.py .
COPY requirements.txt .

RUN pip install -r requirements.txt

CMD ["get_s3_objects.lambda_handler"]
