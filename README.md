# AZ104-Labs
This Vagrant configuration provides a complete Azure development and lab environment running in VirtualBox, keeping your Windows host clean from Azure tools and dependencies.

## Prerequisites

Dependencies:  
- VirtualBox
- Vagrant
- vbguest plugin: `vagrant plugin install vagrant-vbguest`
- VS Code

## What's Included

### Azure Tools
- **Azure CLI** - Command-line interface for Azure management
- **PowerShell 7** - Cross-platform PowerShell
- **Azure PowerShell Module (Az)** - PowerShell cmdlets for Azure
- **Bicep CLI** - Infrastructure as Code with Bicep
- **Terraform** - Alternative IaC tool for Azure

### Additional Tools
- **azcopy** - Azure Storage data transfer utility
- **kubectl** - Kubernetes command-line tool (for AKS work)
- **helm** - Kubernetes package manager
- **git** - Version control
- **jq** - JSON processor for CLI work
- **vim** - Text editor

## Setup Instructions

### 1. Clone or Create Project Directory

```powershell
# On your Windows host
mkdir azure-lab
cd azure-lab

# Place the Vagrantfile in this directory
# If cloning from git:
git clone https://github.com/jeffstagg/AZ104-Labs AZ104-Labs
cd AZ104-Labs
```

### 2. Start the VM

```powershell
vagrant up
```

### 3. Connect to the VM

```powershell
vagrant ssh
```

You're now inside the Ubuntu VM with all Azure tools ready!

## Usage

### Working with Shared Folders

The directory containing your Vagrantfile is automatically mounted at `/vagrant` in the VM:

**On Windows host:**
```powershell
# Edit files with VSCode
code azure-lab\my-template.bicep
```

**In the VM:**
```bash
# Access the same file
cd /vagrant
bicep build my-template.bicep
az deployment group create --template-file my-template.json ...
```

Files are automatically synced - save in VSCode on Windows, run immediately in the VM!

### Azure Authentication

**Azure CLI (Device Code Flow)**
```bash
az login --use-device-code
```

Follow the browser prompt to authenticate.  
Then select your subscription.


## Project Structure

```
AZ104-Labs/
├── Vagrantfile          # VM configuration
├── .gitignore          # Git ignore rules
├── README.md           # This file
├── templates/          # Your ARM/Bicep templates (create as needed)
│   ├── main.bicep
│   └── modules/
├── scripts/            # PowerShell/Bash scripts (create as needed)
│   └── deploy.ps1
└── projects/           # Your lab projects (create as needed)
```

## Vagrant Commands

```powershell
# Start the VM
vagrant up

# Connect to the VM
vagrant ssh

# Stop the VM (preserves state)
vagrant halt

# Restart the VM
vagrant reload

# Delete the VM completely
vagrant destroy

# Re-run provisioning (reinstall tools)
vagrant provision

# Check VM status
vagrant status

# Update the base box
vagrant box update
```

## Cost Management

Remember to clean up Azure resources after your labs:

```bash
# Delete a resource group and all resources in it
az group delete --name MyLabRG --yes --no-wait

# List all resource groups
az group list --output table

# Stop VMs when not in use
az vm deallocate --resource-group MyLabRG --name MyVM
```

## Additional Resources

- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure/)
- [Azure PowerShell Documentation](https://docs.microsoft.com/powershell/azure/)
- [Bicep Documentation](https://docs.microsoft.com/azure/azure-resource-manager/bicep/)
- [ARM Template Reference](https://docs.microsoft.com/azure/templates/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
