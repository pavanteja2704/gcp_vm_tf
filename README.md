create a SA "bash-sa@project-8888.iam.gserviceaccount.com"
Grant roles 
 Compute Admin
 Service Account Token Creator
 Service Account User

 update SA & Project ID in api.sh and destroy.sh

now run ====   bash api.sh   or ./api.sh  

if you are using bash you need to change provider.tf file 
update this 

provider "google" {
    project         = var.project_id
    access_token    = var.access_token
}
provider "google-beta" {
    project         = var.project_id
    access_token    = var.access_token
}



if you are usinfg github action you need to comment access_token beause we are using Workload Identity Pools

so update the provider.tf

provider "google" {
    project         = var.project_id
    #access_token    = var.access_token
}
provider "google-beta" {
    project         = var.project_id
    #access_token    = var.access_token
}


setup of WIF

<img width="1221" height="720" alt="image" src="https://github.com/user-attachments/assets/d81f0f7c-db1a-4019-9830-556c99ec596d" />

<img width="622" height="827" alt="image" src="https://github.com/user-attachments/assets/eae51b5e-90e3-4ab0-a83f-f6c95b4ac264" />


gcloud iam service-accounts add-iam-policy-binding \
  github-wlif@project-9daeb647-2a9c-4b5f-a21.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/826364797512/locations/global/workloadIdentityPools/github-wlif/attribute.repository/YOUR_GITHUB_ORG/YOUR_REPO_NAME"

  gcloud projects add-iam-policy-binding project-9daeb647-2a9c-4b5f-a21 \
  --role="roles/compute.admin" \
  --member="serviceAccount:github-wlif@project-9daeb647-2a9c-4b5f-a21.iam.gserviceaccount.com"
