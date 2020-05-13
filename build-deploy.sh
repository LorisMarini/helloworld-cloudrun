#! /bin/bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
   echo "Usage:  ./build_deploy.sh project-id"
   echo "   eg:  ./build_deploy.sh helloworld-123"
   echo "Print list of projects with gcloud projects list"
   exit
fi

PROJECT_ID=$1

# build image and push it
gcloud builds submit --tag gcr.io/$PROJECT_ID/helloworld --project $PROJECT_ID

# deploy to cloud run
gcloud run deploy helloworld \
--image gcr.io/$PROJECT_ID/helloworld \
--platform managed \
--memory 256Mi \
--concurrency 80 \
--region us-central1 \
--project $PROJECT_ID \
--allow-unauthenticated
