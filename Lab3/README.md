# 🟣 LAB 3 — Azure CLI + PowerShell (Compute & Network)

## 🎯 Goal

Deploy VM + networking using CLI and manage it with PowerShell.

## TODO
- [ ] Portal run
- [ ] CLI run
- [ ] Timed run
- [ ] Cleanup verified


---

## Step 1 — Login

```
az login
az account set --subscription "<your-sub>"

```

---

## Step 2 — Create RG + Network

```
az group create -n rg-lab3 -l eastus
az network vnet create \
  -g rg-lab3 \
  -n vnet-lab3 \
  --address-prefix 10.20.0.0/16 \
  --subnet-name subnet1 \
  --subnet-prefix 10.20.1.0/24

```

---

## Step 3 — Create NSG

```
az network nsg create -g rg-lab3 -n nsg-lab3
az network nsg rule create \
  -g rg-lab3 \
  --nsg-name nsg-lab3 \
  -n AllowSSH \
  --priority 100 \
  --source-address-prefixes <your-ip> \
  --destination-port-ranges 22 \
  --access Allow

```

---

## Step 4 — Create VM

```
az vm create \
  -g rg-lab3 \
  -n vm-lab3 \
  --image Ubuntu2204 \
  --admin-username azureadmin \
  --generate-ssh-keys \
  --nsg nsg-lab3

```

---

## Step 5 — PowerShell VM Management

```
Get-AzVM -ResourceGroupName rg-lab3
Stop-AzVM -Name vm-lab3 -ResourceGroupName rg-lab3
Start-AzVM -Name vm-lab3 -ResourceGroupName rg-lab3
```


---

## 🧠 Exam Notes

- CLI = `az`
    
- PowerShell = `Az.*`
    
- Know **stop vs deallocate**