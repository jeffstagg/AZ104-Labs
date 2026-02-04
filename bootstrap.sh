#!/usr/bin/env bash
set -e

echo "==============================="
echo "Starting Vagrant Architect Lab provisioning..."
echo "==============================="

# -----------------------------
# Core system packages
# -----------------------------
apt-get update -y
apt-get install -y \
    ca-certificates \
    curl \
    apt-transport-https \
    lsb-release \
    gnupg \
    software-properties-common \
    unzip \
    jq \
    build-essential \
    git

# -----------------------------
# Azure CLI
# -----------------------------
if ! command -v az &> /dev/null; then
    echo "Installing Azure CLI..."
    curl -sLS https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor \
      | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" \
      > /etc/apt/sources.list.d/azure-cli.list

    apt-get update
    apt-get install -y azure-cli
fi

# -----------------------------
# Terraform
# -----------------------------
if ! command -v terraform &> /dev/null; then
    echo "Installing Terraform..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg \
      | gpg --dearmor \
      -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | tee /etc/apt/sources.list.d/hashicorp.list

    apt-get update
    apt-get install -y terraform
fi

# -----------------------------
# kubectl
# -----------------------------
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key \
      | gpg --dearmor \
      -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
    https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" \
    > /etc/apt/sources.list.d/kubernetes.list

    apt-get update
    apt-get install -y kubectl
fi

# -----------------------------
# Helm
# -----------------------------
if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# -----------------------------
# Docker
# -----------------------------
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    install -m 0755 -d /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | gpg --dearmor \
      -o /etc/apt/keyrings/docker.gpg

    chmod a+r /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

    apt-get update
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

    usermod -aG docker vagrant
fi

# -----------------------------
# Azure login / subscription guidance
# -----------------------------
SP_FILE="/workspace/.azure-sp.json"

# Detect active subscription
SUBSCRIPTION_ID=$(az account list --query "[?state=='Enabled'].id | [0]" -o tsv || true)

if [ -f "$SP_FILE" ]; then
    echo "Service principal found. Logging in..."
    CLIENT_ID=$(jq -r .clientId $SP_FILE)
    CLIENT_SECRET=$(jq -r .clientSecret $SP_FILE)
    TENANT_ID=$(jq -r .tenantId $SP_FILE)
    az login --service-principal -u "$CLIENT_ID" -p "$CLIENT_SECRET" --tenant "$TENANT_ID"
    az account set --subscription "$(jq -r .subscriptionId $SP_FILE)"

elif [ -n "$SUBSCRIPTION_ID" ]; then
    echo ""
    echo "=================================================="
    echo "Active subscription detected: $SUBSCRIPTION_ID"
    echo "Use interactive login for free-tier labs:"
    echo "  vagrant ssh"
    echo "  az login --use-device-code"
    echo "Optional: create a service principal if supported:"
    echo "  az ad sp create-for-rbac --name vagrant-az-lab --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID --sdk-auth > /workspace/.azure-sp.json"
    echo "=================================================="
    echo ""
else
    echo ""
    echo "=================================================="
    echo "No active Azure subscription detected!"
    echo "You are likely on a free-tier account without full tenant permissions."
    echo "Interactive az login will work for free-tier exercises, but service principal automation is not available."
    echo "Use:"
    echo "  vagrant ssh"
    echo "  az login --use-device-code"
    echo "=================================================="
    echo ""
fi

# -----------------------------
# Final versions check
# -----------------------------
echo "==============================="
echo "Provisioning complete"
echo "==============================="
terraform -version
az version
kubectl version --client
docker --version
helm version
