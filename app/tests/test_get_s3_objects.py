import unittest
from unittest.mock import MagicMock
from get_s3_objects import get_objects

class TestGetObjects(unittest.TestCase):
    def test_get_objects_returns_keys(self):
        # Mock S3 bucket
        mock_bucket = MagicMock()
        mock_bucket.objects.all.return_value = [
            MagicMock(key="file1.txt"),
            MagicMock(key="file2.txt"),
            MagicMock(key="folder/file3.txt")
        ]

        result = get_objects(mock_bucket)

        expected = ["file1.txt", "file2.txt", "folder/file3.txt"]
        self.assertEqual(result, expected)

if __name__ == "__main__":
    unittest.main()
