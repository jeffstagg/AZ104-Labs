# 🟢 LAB 2 — Storage, Backup, Monitoring (Portal)

## 🎯 Goal

Protect VM data, monitor health, and configure alerts.

## TODO
- [ ] Portal run
- [ ] CLI run
- [ ] Timed run
- [ ] Cleanup verified


---

## Step 1 — Create Storage Account

1. Storage accounts → Create
    
2. Name: `stlab2<random>`
    
3. Redundancy: LRS
    

---

## Step 2 — Create File Share

1. Storage → File shares → Create
    
2. Name: `fileshare1`
    
3. Mount to VM (use provided script)
    

---

## Step 3 — Create Recovery Services Vault

1. Recovery Services vaults → Create
    
2. Name: `rsv-lab2`
    
3. Region: same as VM
    

---

## Step 4 — Enable VM Backup

1. Open vault → Backup
    
2. Select Azure VM
    
3. Choose `vm-lab1`
    
4. Policy:
    
    - Daily
        
    - Retention: 30 days
        
5. Enable backup
    

---

## Step 5 — Create Log Analytics Workspace

1. Log Analytics → Create
    
2. Name: `law-lab2`
    
3. Link VM
    

---

## Step 6 — Create Alerts

1. Azure Monitor → Alerts
    
2. Create:
    
    - CPU > 75% for 5 minutes
        
    - Backup job failed
        

---

## 🔎 Validation

- Backup job succeeds
    
- Metrics visible
    
- Alert rules active
    

---

## 🧠 Exam Notes

- Know **Recovery Services Vault vs Backup Center**
    
- Alerts use **action groups**