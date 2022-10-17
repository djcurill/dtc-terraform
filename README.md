# dtc-terraform

IaC repo for creating GCP infrastructure for the Data Talks Club 2022 Data Engineering Zoom Camp

## Configuring Federated Worker Pool

```bash
gcloud auth activate-service-account <sa-email> --key-file /path/to/credentials.json

gcloud iam workload-identity-pools create "dev-ci-terraform" \ 
    --project="${PROJECT_ID}" \ 
    --location="global" \
    --display-name="Github CI/CD: Terraform"

gcloud iam workload-identity-pools providers create-oidc "dev-ci-oidc-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="dev-ci-terraform" \
  --display-name="CI/CD oidc provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "dtc-dataops-dev-terraform@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"

gcloud iam workload-identity-pools providers describe "dev-ci-oidc-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="dev-ci-terraform" \
  --format="value(name)"
```
