ENV=dev
BUCKET_NAME=dtc-${ENV}-terraform-state
PROJECT_ID=$$(gcloud config list --format 'value(core.project)')

configure-backend:
	gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}; \
	gsutil versioning set on gs://${BUCKET_NAME};

destroy-backend:
	gsutil rm -r gs://${BUCKET_NAME};