Setting Up `bolt.diy` on Google Cloud Run

This guide provides step-by-step instructions to deploy `bolt.diy` on Google Cloud Run, using the confirmed working setup.

---

Prerequisites
1. Google Cloud CLI installed ([Google Cloud SDK Install Guide](https://cloud.google.com/sdk/docs/install)).
2. Git installed and configured.
3. Access to your Google Cloud Project.
4. Your Google Cloud project ID (e.g., `example-project-id`).
5. The `bolt.diy` repository already pushed to GitHub.

---

Steps to Deploy

1. Clone the Repository
Ensure you have the latest version of the repository:

git clone https://github.com/huntsdesk/bolt.diy.git
cd bolt.diy

---

2. Build and Push the Docker Image to Google Artifact Registry

Step 2.1: Create a Docker Repository (if not already created)

gcloud artifacts repositories create bolt-diy-repo \
  --repository-format=docker \
  --location=us-central1 \
  --description="Repository for bolt.diy"

Step 2.2: Authenticate Docker to Use Artifact Registry

gcloud auth configure-docker us-central1-docker.pkg.dev

Step 2.3: Build and Push the Image
Build and push the image to the Artifact Registry:

gcloud builds submit --tag us-central1-docker.pkg.dev/example-project-id/bolt-diy-repo/bolt-diy

---

3. Update Placeholders

Before running the deployment command, update the placeholders in the command:
- Replace `[projectID]` with your Google Cloud Project ID (e.g., `example-project-id`).
- Replace `[service-account]` with your service account name (e.g., `example-service-account`).
- Replace `[project-id]` with your Google Cloud Project ID again.

---

4. Deploy the Application to Google Cloud Run

Run the following command to deploy the service:

gcloud run deploy bolt-diy \
--image=us-central1-docker.pkg.dev/[projectID]/bolt-diy-repo/bolt-diy \
--allow-unauthenticated \
--port=5173 \
--service-account=[service-account]@developer.gserviceaccount.com \
--memory=4Gi \
--region=us-central1 \
--project=[project-id]

---

5. Access Your Application

Once the deployment is complete, Google Cloud Run will provide a public URL for your service (e.g., `https://bolt-diy-xyz123.a.run.app`).

Test the URL in your browser to confirm the service is running.

---

6. Configure a Custom Domain

If you want to use a custom domain for your service:

Create a CNAME Record: In your domain registrar, create a CNAME record pointing your desired subdomain (e.g., app.example.com) to the public URL provided by Google Cloud Run (e.g., bolt-diy-xyz123.a.run.app).

---

You have successfully deployed `bolt.diy` on Google Cloud Run!
