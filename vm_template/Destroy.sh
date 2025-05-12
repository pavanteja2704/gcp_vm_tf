#!/bin/bash

# Colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# Configuration
PROJECT_ID="pavan-457011"
SA="1057655170911-compute@developer.gserviceaccount.com"
TF_VARFILE1="vm.tfvars"

clear

echo -e "${CYAN}=========================================================================="
echo -e "        ⚠️ Terraform Destroy - GCP VM Teardown Script"
echo -e "==========================================================================${RESET}\n"

echo -e "${YELLOW}[1/5] Setting the GCP project...${RESET}"
echo -e "Using project: ${GREEN}$PROJECT_ID${RESET}"
gcloud config set project "$PROJECT_ID"
echo -e "${GREEN}✅ Project configured successfully.${RESET}\n"

echo -e "${YELLOW}[2/5] Generating access token for service account impersonation...${RESET}"
export MYTOKEN=$(gcloud auth print-access-token --impersonate-service-account="$SA")
if [[ -z "$MYTOKEN" ]]; then
    echo -e "${RED}❌ Failed to get access token. Check your SA permissions and config.${RESET}"
    exit 1
fi
echo -e "${GREEN}✅ Access token generated successfully.${RESET}\n"

echo -e "${YELLOW}[3/5] Initializing Terraform...${RESET}"
terraform init -upgrade
echo -e "${GREEN}✅ Terraform initialized.${RESET}\n"

echo -e "${YELLOW}[4/5] Running Terraform Destroy Plan...${RESET}"
terraform plan -destroy \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file=$TF_VARFILE1
if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Terraform plan for destroy failed. Please fix the errors above.${RESET}"
    exit 1
fi
echo -e "${GREEN}✅ Destroy plan looks good.${RESET}\n"

echo -e "${YELLOW}[5/5] Proceeding with Terraform Destroy... (auto-approved)${RESET}"
terraform destroy \
  -auto-approve \
  -var="access_token=$MYTOKEN" \
  -var="project_id=$PROJECT_ID" \
  -var-file=$TF_VARFILE1

echo -e "\n${GREEN}✅ Terraform destroy completed successfully without user prompt.${RESET}"
echo -e "${CYAN}=========================================================================="
echo -e "🧹 ${GREEN}Teardown complete.${RESET}"
echo -e "${CYAN}==========================================================================${RESET}"
