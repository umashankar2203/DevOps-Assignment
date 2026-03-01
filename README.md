#  DevOps Multi-Cloud Deployment Assignment

# Multi-Cloud DevOps Assignment

Production-grade deployment using:
- AWS (ECS + ALB)
- GCP (Cloud Run)
- Terraform (AWS infra)
- Vercel (Frontend)

A production-grade multi-cloud architecture demonstrating a **FastAPI** backend and **Next.js** frontend orchestrated across **AWS (ECS Fargate)** and **GCP (Cloud Run)**. Infrastructure is provisioned using **Terraform (IaC)** with secure state management and environment isolation.
# Multi-Cloud DevOps Assignment


---

##  Live Application Links

| Component | Provider | URL |
| :--- | :--- | :--- |
| **Frontend** | Vercel | [View Live Demo](https://multi-cloud-frontend-ten.vercel.app) |
| **AWS Backend** | ECS Fargate | [API Endpoint](http://pgagi-backend-alb-Prod-1227545064.ap-south-1.elb.amazonaws.com) |
| **GCP Backend** | Cloud Run | [API Endpoint](https://pgagi-backend-gcp-670335862351.asia-south1.run.app) |

> [!IMPORTANT]
> **Documentation (PDF):** [Link to PDF Document]  
> **Demo Video:** [Watch Walkthrough](https://your-demo-link.com)

---

##  Overview

This project showcases a modern DevOps approach to multi-cloud reliability. By leveraging both AWS and GCP, the system ensures high availability while maintaining engineering restraint to avoid unnecessary complexity.

### Core Design Principles
* **High Availability:** Redundant deployments across two major cloud providers.
* **Infrastructure as Code (IaC):** AWS resources managed via Terraform with remote state locking.
* **Security First:** Private subnet isolation, IAM least-privilege, and zero-exposure for containers.
* **Operational Maturity:** Automated horizontal scaling and documented failure scenarios.

---

##  System Architecture

### AWS (Primary Cloud)
The AWS stack focuses on a traditional VPC-based container orchestration.
* **Ingress:** Application Load Balancer (ALB) in public subnets.
* **Compute:** ECS Fargate tasks isolated in **private subnets**.
* **Deployment:** Rolling updates (100/200 strategy) with health checks at `/api/health`.
* **Traffic Flow:** `Internet` → `ALB` → `Target Group` → `ECS Fargate`.



### GCP (Secondary Cloud)
The GCP stack utilizes a serverless approach for rapid scaling and managed overhead.
* **Compute:** Cloud Run (Serverless Containers).
* **Scaling:** Automatic request-based concurrency scaling.
* **Traffic Flow:** `Internet` → `Google Managed Ingress` → `Cloud Run`.

---

##  Networking & Security Comparison

| Feature | AWS (ECS) | GCP (Cloud Run) |
| :--- | :--- | :--- |
| **Public Entry** | Application Load Balancer | Managed HTTPS |
| **Compute Exposure** | Private Subnet | Fully Managed |
| **SSL/TLS** | HTTP (ALB DNS Limitation) | HTTPS (Google Managed Certs) |
| **Access Control** | Security Groups | IAM-based |
| **Health Checks** | Target Group | Platform-managed |

**Security Hardening:**
* ❌ No containers directly exposed to the public internet.
* ❌ No secrets stored in Git or embedded in Docker images.
* ✅ IAM least-privilege enforced across both platforms.

---

##  Scalability Configuration

### AWS ECS Fargate
* **Resources:** 2048 CPU | 4096 MB Memory
* **Capacity:** Min 3 tasks | Max 10 tasks
* **Trigger:** CPU-based autoscaling (Target Tracking)
* **Availability:** Distributed across multiple Availability Zones (Multi-AZ)

### GCP Cloud Run
* **Resources:** 2 vCPU | 4 GiB Memory
* **Capacity:** Min 1 instance | Max 10 instances
* **Trigger:** Request-based concurrency scaling

---

## Infrastructure as Code (Terraform)

AWS infrastructure is provisioned using modular Terraform scripts with a robust backend strategy:
* **State Storage:** Amazon S3
* **State Locking:** DynamoDB
* **Isolation:** Separate state files for `Dev`, `Staging`, and `Prod`.

```text
Infra/
├── Dev/        # Development environment resources
├── Staging/    # Pre-production validation
└── Prod/       # Production-grade resources
Note: GCP Cloud Run was provisioned via managed platform tools to reduce overhead and avoid overengineering the secondary cloud provider.

Project Structure
.
├── backend/            # FastAPI application
│   ├── app/
│   │   └── main.py     # API Logic & Endpoints
│   └── requirements.txt
├── frontend/           # Next.js / React application
├── Infra/              # Terraform configs (AWS only)
│   ├── Dev/
│   ├── Staging/
│   └── Prod/
└── README.md

Local Setup
Prerequisites
Python 3.8+ | Node.js 16+
Docker & Terraform
Configured AWS & GCP CLIs

Backend Setup

cd backend
python -m venv venv
.\venv\Scripts\activate   # Windows
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000

Backend URL:

http://localhost:8000
Frontend Setup
cd frontend
npm install

Create .env.local:

NEXT_PUBLIC_API_URL=http://localhost:8000

Start:
npm run dev

Frontend URL:
http://localhost:3000
API Endpoints
GET /api/health
{
  "status": "healthy",
  "message": "Backend is running successfully"
}
GET /api/message
Returns:
{
  "message": "You've successfully integrated the backend!"
}
📄 Documentation

Detailed architecture and operational documentation:
➡️ [Link to PDF Documentation]
Includes:
1.Architecture reasoning
2.Deployment strategy
3.Failure scenarios
4.Future growth planning
5.Engineering tradeoffs

🎥 Demo Video

Demo walkthrough (8–12 minutes):
➡️ [Add Demo Video Link]
Covers:
1.Repository walkthrough
2.AWS deployment
3..GCP deployment
4.Environment separation
5.Autoscaling configuration
6.Networking explanation
7.Operational thinking8.Tradeoffs & limitations

💰 Cost Awareness

1.AWS ECS + ALB incur steady operational cost
2.Cloud Run scales based on traffic
3.Non-production environments can be scaled down post-evaluation
4.Managed services reduce operational overhead

✅ Final Status

1.AWS backend deployed and healthy
2.GCP backend deployed and healthy
3.Frontend publicly accessible
4.Autoscaling configured
5.Environment separation implemented
6.Terraform remote state configured (S3 + DynamoDB)
7.Multi-cloud architecture validated

🎯 Engineering Philosophy
1.The system was designed to:
2.Avoid overengineering
3.Use managed services where appropriate
4.Maintain scalability without Kubernetes
5.Enable incremental evolution
6.Balance reliability and simplicity
