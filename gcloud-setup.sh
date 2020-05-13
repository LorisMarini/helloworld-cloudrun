#! /bin/bash

# Before you start, find the billing account id with
# gcloud alpha billing accounts list

# Update the SDK with
# gcloud components update
# gcloud components install alpha

set -euo pipefail

if [ "$#" -ne 2 ]; then
   echo "Usage:  ./gcloud-setup.sh billingid project-id"
   echo "   eg:  ./gcloud-setup.sh 0X0X0X-0X0X0X-0X0X0X helloworld-123"
   exit
fi

APIS="cloudbuild.googleapis.com containerregistry.googleapis.com run.googleapis.com storage-component.googleapis.com"

ACCOUNT_ID=$1
shift
PROJECT_ID=$1

# create project if it doesn't exist
EXISTING_PROJECT_ID=$(gcloud projects list \
                      --filter $PROJECT_ID \
                      --format='value(project_id)' \
                      --limit 1)

if [ "$EXISTING_PROJECT_ID" != "$PROJECT_ID" ];
then
  # create project
  echo Project not found, creating project $PROJECT_ID...
  gcloud projects create $PROJECT_ID \
    --name $PROJECT_ID\
    --enable-cloud-apis
  sleep 1
else
  echo "Project $PROJECT_ID aready exists"
fi

# enable billing if necessary
BILLED_PROJECT=$(gcloud beta billing projects list \
                 --billing-account=$ACCOUNT_ID \
                 --format='value(project_id)'\
                 --filter $PROJECT_ID)

if [ "$BILLED_PROJECT" != "$PROJECT_ID" ];
then
  # configure billing
  echo Linking billing account $ACCOUNT_ID to project $PROJECT_ID...
  gcloud beta billing projects link $PROJECT_ID --billing-account=$ACCOUNT_ID \
    || echo "Ensure the ACOUNT_ID is valid by running: gcloud alpha billing accounts list"
else
  echo "Billing already enabled for project $PROJECT_ID"
fi

# enable apis
for A in $APIS; do
  echo Enabling API $A...
  gcloud services enable $A --project $PROJECT_ID
  sleep 1
done
