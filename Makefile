ENV=dev
BUCKET_NAME=dtc-${ENV}-terraform-state
PROJECT_ID=$$(gcloud config list --format 'value(core.project)')

configure-backend:
	gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}; \
	gsutil versioning set on gs://${BUCKET_NAME};

destroy-backend:
	gsutil rm -r gs://${BUCKET_NAME};

create-pool:
	gcloud iam workload-identity-pools create ${POOL_NAME} \
		--location="global" \
		--description="Workload identity pool for ${ENV} environment" \
		--display-name=${DISPLAY_NAME};

delete-pool:
	gcloud iam workload-identity-pools delete ${POOL_NAME} --location="global";

list-providers:
	@gcloud iam workload-identity-pools providers list \
		--workload-identity-pool=${POOL_NAME} \
		--location="global";

create-provider:
	@gcloud iam workload-identity-pools providers create-oidc ${PROVIDER_NAME} \
		--location="global" \
		--workload-identity-pool=${POOL_NAME} \
		--attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
		--issuer-uri="https://token.actions.githubusercontent.com";

delete-provider:
	@gcloud iam workload-identity-pools providers delete ${PROVIDER_NAME} \ 
		--workload-identity-pool="my-workload-identity-pool" \
		--location="global";

get-pool-id:
	@gcloud iam workload-identity-pools describe ${POOL_NAME} \
		--project=${PROJECT_ID} \
		--location="global" \
		--format="value(name)"


add-identity-policy:
	@gcloud iam service-accounts add-iam-policy-binding "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  		--project=${PROJECT_ID} \
		--role="roles/iam.workloadIdentityUser" \
		--member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"