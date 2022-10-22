# dtc-terraform

IaC repo for creating GCP infrastructure for the Data Talks Club 2022 Data Engineering Zoom Camp

## Configuring Federated Worker Pool

Workload Identity Federation enables applications outside of google cloud to use short lived credentials. This reduces the risk of a cyber security attack, or for credentials getting into the wrong hands.

The first step to setting up Workload Identity Federation is to setup a Pool. Workload Pools organized and manage external identity providers. An example of an external identity provider is Github. A single GCP project can have multiple pools. For each pool, we can assign a set of roles allowing varying levels of permission.

To create a pool, use the following `gcloud` command:

```bash
gcloud iam workload-identity-pools create "pool-name" \
  --location="global" \
  --description="Describe the pool"
  --display-name="display name shown on ui"
```

Next, we add a one way trust from the identity provider (i.e. Github) to GCP. This allows a specific github URI to commuincate with the workload identity pool. This can be done by:

```bash
gcloud iam workload-identity-pools providers create-oidc "provider-name" \
  --workload-identity-pool="pool-name" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

Lastly, we add a policy to the service account we would like to impersonate. The policy allows github actions to impersonate a terraform service account.

```bash
gcloud iam service-accounts add-iam-policy-binding "<service-account-email}>" \
  --project="<your-project-id>" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"
```

The workload identity pool id can be retrieved by describing the resource. We will use the output of this command as a secret in the github action.

```bash
gcloud iam workload-identity-pools describe "pool-name" \
  --project="<project-id>" \
  --location="global" \
  --format="value(name)"
```

After adding the policy, you have correctly configured an open id connect protocol into GCP from github actions. To use this in github actions, perform the following steps:

1. Copy the `workload_identity_provider` resource name and save it as a secret in the github repository.
2. Follow the usage docs of `github` auth action [here](https://github.com/google-github-actions/auth#examples)
