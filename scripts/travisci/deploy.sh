#! /bin/bash

echo "Mock deployment commenced."

### REST API Deployment
#deploy:
#  provider: elasticbeanstalk
#  access_key_id:
#    secure: $AWS_ACCESS_KEY
#  secret_access_key:
#    secure: $AWS_SECRET_ACCESS_KEY
#  bucket: $AWS_EB_S3_BUCKET # The S3 bucket EB uses to store the application files.
#  region: $AWS_REGION
#  app: $AWS_EB_APP
#  env: $AWS_EB_ENV
#  zip_file: './www/Archive.zip'
#  skip_cleanup: true
#  on:
#    tags: true

### Front-end Deployment
#deploy:
#  provider: s3
#  access_key_id: $AWS_ACCESS_KEY
#  secret_access_key: $AWS_SECRET_ACCESS_KEY
#  bucket: $AWS_S3_BUCKET
#  skip_cleanup: true
#  region: $AWS_REGION
#  local_dir: www
#  on:
#    tags: true
#
#after_deploy:
#  - travis-ci-cloudfront-invalidation -a $AWS_ACCESS_KEY -s $AWS_SECRET_ACCESS_KEY -c $AWS_CF_ID -i '/*' -b $TRAVIS_BRANCH -p $TRAVIS_PULL_REQUEST -o $TRAVIS_BRANCH
