#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# Configuration
PROJECT_ID="project-9daeb647-2a9c-4b5f-a21"
SA="bash-sa@project-9daeb647-2a9c-4b5f-a21.iam.gserviceaccount.com"
TF_VARFILE1="vm.tfvars"

clear

echo -e "${CYAN}=========================================================================="
echo -e "         🚀 Google Cloud Terraform VM Deployment Script"
echo -e "==========================================================================${RESET}\n"

# Prevent Terraform from using any local credentials
unset GOOGLE_APPLICATION_CREDENTIALS
unset GOOGLE_OAUTH_ACCESS_TOKEN

echo -e "${YELLOW}[1/6] Validating Service Account...${RESET}"

if [[ -z "$SA" ]]; then
    echo -e "${RED}❌ Service Account is empty. Exiting.${RESET}"
    exit 1
fi

gcloud iam service-accounts describe "$SA" >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Service Account does not exist or is inaccessible: $SA${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Service Account validation successful.${RESET}\n"

echo -e "${YELLOW}[2/6] Setting the GCP project...${RESET}"
echo -e "Using project: ${GREEN}$PROJECT_ID${RESET}"

gcloud config set project "$PROJECT_ID" >/dev/null

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to set project.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Project configured successfully.${RESET}\n"

echo -e "${YELLOW}[3/6] Generating access token via Service Account impersonation...${RESET}"

MYTOKEN=$(gcloud auth print-access-token \
  --impersonate-service-account="$SA" 2>/dev/null)

if [[ $? -ne 0 || -z "$MYTOKEN" ]]; then
    echo -e "${RED}❌ Failed to impersonate service account.${RESET}"
    echo -e "${RED}Check that your user has:${RESET}"
    echo -e "${RED}  roles/iam.serviceAccountTokenCreator${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Service Account impersonation successful.${RESET}"
echo -e "${GREEN}Using SA: $SA${RESET}\n"

echo -e "${YELLOW}[4/6] Initializing Terraform...${RESET}"

terraform init -upgrade

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform init failed.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Terraform initialized successfully.${RESET}\n"

echo -e "${YELLOW}[5/6] Running Terraform Plan...${RESET}"

terraform plan \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file="$TF_VARFILE1"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform plan failed.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Terraform plan completed successfully.${RESET}\n"

echo -e "${CYAN}=========================================================================="
echo -e "⚠️ Auto-approving Terraform apply in 5 seconds. Press Ctrl+C to cancel."
echo -e "${CYAN}==========================================================================${RESET}"

for i in {5..1}; do
    echo -ne "${YELLOW}Applying in $i...\r${RESET}"
    sleep 1
done

echo -e "\n${YELLOW}[6/6] Applying Terraform changes...${RESET}"

terraform apply \
  -auto-approve \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file="$TF_VARFILE1"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform apply failed.${RESET}"
    exit 1
fi

echo -e "\n${GREEN}✅ Terraform apply completed successfully.${RESET}"
echo -e "${GREEN}Resources were created using Service Account impersonation only.${RESET}"

echo -e "\n${CYAN}=========================================================================="
echo -e "🎉 Deployment completed successfully!"
echo -e "${CYAN}==========================================================================${RESET}"