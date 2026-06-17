#!/bin/bash

# Colors for formatting
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"git 
BLUE="\e[34m"
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

# Prevent Terraform from using local credentials
unset GOOGLE_APPLICATION_CREDENTIALS
unset GOOGLE_OAUTH_ACCESS_TOKEN

echo -e "${YELLOW}[1/6] Validating Service Account...${RESET}"

if [[ -z "$SA" ]]; then
    echo -e "${RED}❌ Service Account is empty.${RESET}"
    exit 1
fi

gcloud iam service-accounts describe "$SA" >/dev/null 2>&1

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Service Account not found or inaccessible:${RESET} $SA"
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

echo -e "${YELLOW}[3/6] Generating access token for service account impersonation...${RESET}"

export MYTOKEN=$(gcloud auth print-access-token \
  --impersonate-service-account="$SA" 2>/dev/null)

if [[ $? -ne 0 || -z "$MYTOKEN" ]]; then
    echo -e "${RED}❌ Failed to impersonate Service Account.${RESET}"
    echo -e "${RED}Verify you have roles/iam.serviceAccountTokenCreator on:${RESET}"
    echo -e "${RED}$SA${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Access token generated successfully using:${RESET} ${GREEN}$SA${RESET}\n"

echo -e "${YELLOW}[4/6] Initializing Terraform...${RESET}"

terraform init -upgrade

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform initialization failed.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Terraform initialized.${RESET}\n"

echo -e "${YELLOW}[5/6] Running Terraform Plan...${RESET}"

terraform plan \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file="$TF_VARFILE1"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform plan failed. Please fix the errors above before continuing.${RESET}"
    exit 1
fi

echo -e "${GREEN}✅ Terraform plan completed.${RESET}\n"

echo -e "${CYAN}=========================================================================="
echo -e "⚠️  ${YELLOW}Auto-approving Terraform apply in 5 seconds. Press Ctrl+C to cancel.${RESET}"
echo -e "${CYAN}==========================================================================${RESET}\n"

for i in {5..1}; do
    echo -ne "${YELLOW}Applying in $i...\r${RESET}"
    sleep 1
done

echo -e "\n${YELLOW}[6/6] Applying Terraform changes... (auto-approved)${RESET}"

terraform apply -auto-approve \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file="$TF_VARFILE1"

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform apply failed.${RESET}"
    exit 1
fi

echo -e "\n${GREEN}✅ Terraform apply completed successfully.${RESET}"
echo -e "${GREEN}✅ Resources created using Service Account impersonation.${RESET}"

echo -e "\n${CYAN}=========================================================================="
echo -e "🎉 ${GREEN}Script execution completed. Thank you!${RESET}"
echo -e "${CYAN}==========================================================================${RESET}"