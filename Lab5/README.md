# 🔴 LAB 5 — ARM Template (Full Stack)

## 🎯 Goal

Deploy full environment using Infrastructure as Code.

## TODO
- [ ] Portal run
- [ ] CLI run
- [ ] Timed run
- [ ] Cleanup verified


---

## Step 1 — Create ARM Template

Includes:
- VNet
- Subnet
- NSG
- VM
- Storage
- Log Analytics
    
---

## Step 2 — Deploy

```
az deployment group create \
  -g rg-arm-lab \
  --template-file template.json \
  --parameters parameters.json

```

---

## 🧠 Exam Notes

- ARM = **declarative**
- Dependencies auto-resolve