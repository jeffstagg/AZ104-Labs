# 🔵 LAB 1 — Identity, VM, Networking (Azure Portal)

## 🎯 Goal

Create an Azure AD user, assign RBAC via group, deploy a VM into a secured network, and allow remote access from home only.

## 🧰 Tools

Azure Portal only

## 🗂️ Prereqs

- Azure subscription
- Your **public home IP** (google “what is my ip”)


## TODO
- [ ] Portal run
- [ ] CLI run
- [ ] Timed run
- [ ] Cleanup verified


---

## Step 1 — Create Resource Group

1. Azure Portal → **Resource groups**
    
2. Create:
    
    - Name: `rg-az104-lab1`
        
    - Region: closest to you
        

---

## Step 2 — Create Azure AD User

1. Portal → **Microsoft Entra ID**
    
2. Users → **New user**
    
3. Create user:
    
    - Username: `labuser1`
        
    - Password: auto-generate
        
4. Save credentials
    

---

## Step 3 — Create Security Group

1. Entra ID → Groups → **New group**
    
2. Type: Security
    
3. Name: `rg-lab1-vm-users`
    
4. Add `labuser1`
    

---

## Step 4 — Assign RBAC

1. Open `rg-az104-lab1`
    
2. Access control (IAM)
    
3. Add role assignment:
    
    - Role: **Virtual Machine User Login**
        
    - Assign access to: Group
        
    - Group: `rg-lab1-vm-users`
        

---

## Step 5 — Create Virtual Network

1. Portal → Virtual networks → Create
    
2. Name: `vnet-lab1`
    
3. Address space: `10.10.0.0/16`
    
4. Subnets:
    
    - `subnet-workload` → `10.10.1.0/24`
        
    - `subnet-future` → `10.10.2.0/24`
        

---

## Step 6 — Create Network Security Group

1. Portal → NSGs → Create
    
2. Name: `nsg-lab1`
    
3. Inbound rule:
    
    - Source: IP Address
        
    - Source IP: **your home IP**
        
    - Port: 3389 (RDP)
        
    - Action: Allow
        
4. Associate NSG to `subnet-workload`
    

---

## Step 7 — Create VM

1. Portal → Virtual Machines → Create
    
2. Basics:
    
    - Name: `vm-lab1`
        
    - Image: Windows Server 2022
        
    - Size: B2s
        
3. Administrator account:
    
    - Username: `azureadmin`
        
4. Networking:
    
    - VNet: `vnet-lab1`
        
    - Subnet: `subnet-workload`
        
    - Public IP: Yes
        
    - NSG: Existing → `nsg-lab1`
        
5. Disks:
    
    - Add **data disk** (Standard SSD)
        
6. Create VM
    

---

## Step 8 — Log In as Lab User

1. RDP to VM
    
2. Log in using:
    
    - Username: `labuser1@<tenant>`
        
3. Confirm login works
    

---

## 🔎 Validation

- RDP works from home
    
- RDP blocked from other IPs
    
- User can log in but cannot manage VM settings
    

---

## 🧠 Exam Notes

- RBAC is **not authentication**
    
- NSG rules are subnet-level here
    
- Group-based access is best practice