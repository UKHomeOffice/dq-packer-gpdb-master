#!/bin/bash
#
# Simple bash script to upload backup files from the local server to S3. Use it with a cron job eg.

echo 'Setting up variables'
unset PYTHONHOME

echo 'Moving to working directory and search for latest backup folder'

cd $GP_backup_location
Latest_backup=`ls -dt -- */ | head -n 1`

echo 'Latest folder found: '$Latest_backup''

echo 'Upload to: '$S3_bucket' started'

function s3_upload {
  upload=$(aws s3 cp $GP_backup_location/$Latest_backup s3://$S3_bucket/$Latest_backup --recursive)
  echo 'Data Upload completed'
}

function main {
  if s3_upload
    then
      echo 'Removing local folder '$Latest_backup''
      rm -rf $Latest_backup
  fi
}

main

exit
