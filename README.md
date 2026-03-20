# 🚀 EpicBook Deployment on AWS using Terraform

## 📌 Overview

This project demonstrates a **production-style deployment** of a full-stack application on AWS using **Terraform**.

It automates:

* Infrastructure provisioning
* Application deployment
* Database setup
* Configuration management

---

## 🏗️ Architecture

```
User → Nginx (80) → Node.js (8080) → RDS MySQL (Private)
```

---

## ⚙️ Tech Stack

* Terraform
* AWS (EC2, RDS, VPC, S3, DynamoDB)
* Node.js
* MySQL
* Nginx

---

## 🔧 Infrastructure Components

* Custom VPC (10.0.0.0/16)
* Public Subnet → EC2
* Private Subnets (Multi-AZ) → RDS
* Internet Gateway
* Route Tables
* Security Groups

---

## 🔐 Security

* SSH access restricted using dynamic IP
* RDS accessible only via EC2 SG
* Private subnet for database

---

## 🚀 Deployment Steps

```bash
terraform init
terraform plan
terraform apply
```

---

## ⚡ Automation (user_data.sh)

* Install Node.js, Nginx, MySQL client
* Clone GitHub repo
* Configure DB connection
* Wait for RDS availability
* Import schema & seed data
* Start application using PM2
* Configure Nginx reverse proxy

---

## 🧠 Challenges & Fixes

| Issue                 | Fix                        |
| --------------------- | -------------------------- |
| AMI not found         | Used correct owner ID      |
| RDS AZ error          | Created multi-AZ subnets   |
| 403 Nginx             | Fixed reverse proxy config |
| DB connection refused | Updated config.json        |
| Dynamic IP issue      | Used HTTP data source      |
| State management      | Implemented S3 + DynamoDB  |

---

## 🔄 Backend Setup

* S3 bucket → store Terraform state
* DynamoDB → state locking

---

## 🎯 Outcome

✔ Fully automated infrastructure
✔ Secure architecture
✔ Production-ready setup

---

## 🚀 Future Improvements

* Load Balancer (ALB)
* HTTPS (ACM)
* Auto Scaling
* CI/CD pipeline
* Secrets Manager

---

## 👨‍💻 Author 
**Bhupendra Bhati**

---

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&logoColor=white)](https://linkedin.com/in/bhupendrabhati)

---

⭐ If you found this useful, consider giving 5 stars!

