#!/bin/bash

# Colors for formatting
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# Configuration
PROJECT_ID="pavan-457011"
SA="1057655170911-compute@developer.gserviceaccount.com"
TF_VARFILE1="vm.tfvars"

clear

echo -e "${CYAN}=========================================================================="
echo -e "         🚀 Google Cloud Terraform VM Deployment Script"
echo -e "==========================================================================${RESET}\n"

echo -e "${YELLOW}[1/6] Setting the GCP project...${RESET}"
echo -e "Using project: ${GREEN}$PROJECT_ID${RESET}"
gcloud config set project "$PROJECT_ID"
echo -e "${GREEN}✅ Project configured successfully.${RESET}\n"

echo -e "${YELLOW}[2/6] Generating access token for service account impersonation...${RESET}"
export MYTOKEN=$(gcloud auth print-access-token --impersonate-service-account="$SA")
if [[ -z "$MYTOKEN" ]]; then
    echo -e "${RED}❌ Failed to get access token. Check your SA permissions and config.${RESET}"
    exit 1
fi
echo -e "${GREEN}✅ Access token generated successfully.${RESET}\n"

echo -e "${YELLOW}[3/6] Initializing Terraform...${RESET}"
terraform init -upgrade
echo -e "${GREEN}✅ Terraform initialized.${RESET}\n"

echo -e "${YELLOW}[4/6] Running Terraform Plan...${RESET}"
terraform plan \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file=$TF_VARFILE1
if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform plan failed. Please fix the errors above before continuing.${RESET}"
    exit 1
fi
echo -e "${GREEN}✅ Terraform plan completed.${RESET}\n"

echo -e "${CYAN}=========================================================================="
echo -e "⚠️  ${YELLOW}Auto-approving Terraform apply in 5 seconds. Press Ctrl+C to cancel.${RESET}"
echo -e "${CYAN}==========================================================================${RESET}\n"

# Countdown before apply
for i in {5..1}; do
    echo -ne "${YELLOW}Applying in $i...\r${RESET}"
    sleep 1
done

echo -e "\n${YELLOW}[5/6] Applying Terraform changes... (auto-approved)${RESET}"
terraform apply -auto-approve \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file=$TF_VARFILE1

echo -e "\n${GREEN}✅ Terraform apply completed successfully.${RESET}"

echo -e "\n${CYAN}=========================================================================="
echo -e "🎉 ${GREEN}Script execution completed. Thank you!${RESET}"
echo -e "${CYAN}==========================================================================${RESET}"
