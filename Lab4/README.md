# 🟠 LAB 4 — Storage & RBAC (CLI + PS)

## 🎯 Goal

Control access to storage via roles and automation.

## TODO
- [ ] Portal run
- [ ] CLI run
- [ ] Timed run
- [ ] Cleanup verified


---

## Step 1 — Create Storage

```
az storage account create \
  -n stlab4$RANDOM \
  -g rg-lab3 \
  -l eastus \
  --sku Standard_LRS

```

---

## Step 2 — Create Container

```
az storage container create --name data --account-name <storage>

```

---

## Step 3 — Assign RBAC

```
New-AzRoleAssignment `
  -ObjectId <group-object-id> `
  -RoleDefinitionName "Storage Blob Data Reader" `
  -Scope <storage-resource-id>

```

---

## 🧠 Exam Notes

- RBAC ≠ access keys
    
- Blob vs File permissions differ