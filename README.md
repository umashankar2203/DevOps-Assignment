# DevOps Multi-Cloud Deployment Assignment

A production-grade multi-cloud deployment demonstrating a **FastAPI** backend and **Next.js** frontend orchestrated across **AWS (ECS Fargate)** and **GCP (Cloud Run)** using **Terraform** as Infrastructure as Code (IaC).

---

## Overview

This project showcases a modern DevOps approach to high availability and cloud-agnostic architecture. By leveraging managed container services, we achieve operational maturity without the overhead of managing a Kubernetes cluster.

### Key Features
* **Multi-Cloud Design:** Backend redundancy across AWS and GCP.
* **Infrastructure as Code (IaC):** 100% automated provisioning via Terraform.
* **Secure Networking:** Private subnet isolation and security group hardening.
* **Scalability:** Automated CPU-based horizontal scaling.
* **Environment Isolation:** Logical separation of Dev, Staging, and Prod.

---

## Live URLs

| Component | Provider | URL |
| :--- | :--- | :--- |
| **Frontend** | Vercel | [https://your-frontend-url.vercel.app](https://multi-cloud-frontend-ten.vercel.app)|
| **AWS Backend** | AWS ALB | [http://your-alb-url.amazonaws.com](http://pgagi-backend-alb-Prod-1227545064.ap-south-1.elb.amazonaws.com) |
| **GCP Backend** | Cloud Run | [https://your-cloud-run-url.run.app](https://pgagi-backend-gcp-670335862351.asia-south1.run.app) |

---

##  High-Level Architecture

### AWS (Primary Cloud)

* **Ingress:** Application Load Balancer (ALB) in Public Subnets.
* **Compute:** ECS Fargate Tasks residing in **Private Subnets**.
* **Security:** ALB acts as the sole entry point; containers are not directly reachable.
* **Deployment:** Rolling updates (100/200 strategy) with health-check-based routing.

### GCP (Secondary Cloud)

* **Ingress:** Managed Google HTTPS Ingress (SSL termination included).
* **Compute:** Cloud Run (Serverless Containers).
* **Scaling:** Fully managed autoscaling with zero-scale capabilities for cost-saving.

---

##  Networking & Security

| Feature | AWS Implementation | GCP Implementation |
| :--- | :--- | :--- |
| **Traffic Flow** | Internet → ALB → ECS | Internet → Google Ingress → Cloud Run |
| **Subnetting** | Public (ALB) / Private (ECS) | Managed Google Network |
| **SSL/TLS** | HTTP (ALB default domain limitation) | HTTPS (Google Managed Certificates) |
| **Access Control** | Security Groups (Port 80/8000) | IAM-based Access Control |

> **Note on AWS HTTPS:** SSL is intentionally bypassed for the default ALB DNS as ACM requires a custom domain for certificate validation.

---

## Scalability

### AWS (ECS Fargate)
* **Resources:** 2048 CPU | 4096 Memory.
* **Capacity:** Min: 3 tasks / Max: 10 tasks.
* **Trigger:** CPU-based autoscaling policies.

### GCP (Cloud Run)
* **Resources:** 2 vCPU | 4 GiB Memory.
* **Capacity:** Min: 1 instance / Max: 10 instances.
* **Trigger:** Automated request-based concurrency scaling.

---

##  Infrastructure as Code (Terraform)

The infrastructure is organized into environments to ensure safety and predictability.

```text
Infra/
├── Dev/      # Cost-optimized, minimal resources
├── Staging/  # Pre-production validation, moderate scaling
└── Prod/     # High Availability, maximum scaling, S3+DynamoDB Backend

Managed Resources:

AWS: ECS Cluster, Task Definitions, ALB, Target Groups, ASG Policies.
GCP: Cloud Run Service, IAM Roles, API Enablement.
State: Remote state stored in S3 with state locking via DynamoDB.

Project Structure
.
├── backend/           # FastAPI Python application
│   ├── app/
│   │   └── main.py    # API logic & endpoints
│   └── requirements.txt
├── frontend/          # Next.js / React application
├── Infra/             # Terraform configurations per environment
│   ├── Dev/
│   ├── Staging/
│   └── Prod/
└── README.md

Local SetupPrerequisites
Prerequisites

#Python 3.8+
#Node.js 16+
#npm or yarn
#Docker (for container builds)
#Terraform
#AWS CLI (configured)
#GCP CLI (configured)

##Backend Setup (Local Development)
1.Navigate to the backend directory:
cd backend

2.Create a virtual environment:

python -m venv venv
.\venv\Scripts\activate  # Windows

3.Install dependencies:
pip install -r requirements.txt

4.Run the FastAPI server:
uvicorn app.main:app --reload --port 8000

Backend will be available at:
http://localhost:8000

##Frontend Setup (Local Development)

1.Navigate to the frontend directory:
cd frontend

2.Install dependencies:
npm install

3.Configure backend URL in .env.local:
NEXT_PUBLIC_API_URL=http://localhost:8000

4.Start the development server:
 npm run dev

Frontend will be available at:
http://localhost:3000

##API Endpoints

GET /api/health
Returns:

{"status": "healthy", "message": "Backend is running successfully"}

GET /api/message
Returns:

{"message": "You've successfully integrated the backend!"}

##Demo Video
Add your demo video link here.
The demo covers:
1.Repository walkthrough
2.AWS deployment
3.GCP deployment
4.Autoscaling configuration
5.Networking explanation
6.Architectural decisions

##Cost Awareness
1.AWS ECS + ALB incur steady operational cost
2.Cloud Run scales based on traffic
3.Non-production environments can be scaled down after evaluation

####Final Status
1.AWS backend deployed and healthy
2.GCP backend deployed and healthy
3.Frontend publicly accessible
4.Autoscaling configured
5.Environment separation implemented
6.Infrastructure as Code completed
