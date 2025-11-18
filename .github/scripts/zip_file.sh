#!/usr/bin/env bash
set -euo pipefail

FILE_NAME="$1"
VERSION="$2"
LAMBDA_ARTIFACTS_BUCKET="$3"

S3_KEY="list-s3-contents-$VERSION-$FILE_NAME.zip"

if aws s3 ls s3://$LAMBDA_ARTIFACTS_BUCKET/$S3_KEY; then
  echo "Artifact $S3_KEY already exists. Skipping build."
else
  echo "Building package for version $VERSION"
  cd app
  zip -r ../$FILE_NAME.zip .
  cd ..
  aws s3 cp $FILE_NAME.zip s3://$LAMBDA_ARTIFACTS_BUCKET/$S3_KEY
fi
