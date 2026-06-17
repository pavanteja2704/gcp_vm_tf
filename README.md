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
