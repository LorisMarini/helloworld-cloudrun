#! /bin/bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
   echo "Usage:  ./build_deploy.sh project-id service-name"
   echo "   eg:  ./build_deploy.sh helloworld-123 helloworld"
   echo "Print list of projects with gcloud projects list"
   exit
fi

PROJECT_ID=$1
shift
SERVICE_NAME=$1

# build image and push it
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME --project $PROJECT_ID

# deploy to cloud run
gcloud run deploy $SERVICE_NAME \
--image gcr.io/$PROJECT_ID/$SERVICE_NAME \
--platform managed \
--memory 256Mi \
--concurrency 80 \
--region us-central1 \
--project $PROJECT_ID \
--allow-unauthenticated
