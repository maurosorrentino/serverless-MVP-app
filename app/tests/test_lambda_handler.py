import unittest
from unittest.mock import patch, MagicMock
import os
import json
from get_s3_objects import lambda_handler

class TestLambdaHandler(unittest.TestCase):

    @patch.dict(os.environ, {"BUCKET_NAME": "test-bucket", "LOG_LEVEL": "20"})
    @patch("get_s3_objects.s3_resource")  # patch the boto3 resource in your module
    def test_lambda_handler_success(self, mock_s3_resource):
        # Mock the S3 bucket and its objects
        mock_bucket = MagicMock()
        mock_bucket.objects.all.return_value = [
            MagicMock(key="file1.txt"),
            MagicMock(key="file2.txt")
        ]
        mock_s3_resource.Bucket.return_value = mock_bucket

        result = lambda_handler({}, {})

        self.assertEqual(result["statusCode"], 200)
        body = json.loads(result["body"])
        self.assertEqual(body["objects"], ["file1.txt", "file2.txt"])

        # Ensure the Bucket method was called with the correct bucket name
        mock_s3_resource.Bucket.assert_called_with("test-bucket")

    @patch.dict(os.environ, {}, clear=True)  # no BUCKET_NAME set
    def test_lambda_handler_missing_bucket_env(self):

        result = lambda_handler({}, {})

        self.assertIn("error", result)
        self.assertEqual(result["error"], "env var not found")

    @patch.dict(os.environ, {"BUCKET_NAME": "test-bucket"})
    @patch("get_s3_objects.s3_resource.Bucket")
    def test_lambda_handler_bucket_access_error(self, mock_bucket_class):
        # Simulate exception when accessing bucket
        mock_bucket_class.side_effect = Exception("S3 access failed")

        result = lambda_handler({}, {})

        self.assertEqual(result["statusCode"], 500)
        self.assertIn("error", result)
        self.assertEqual(result["error"], "Bucket access error")

if __name__ == "__main__":
    unittest.main()
