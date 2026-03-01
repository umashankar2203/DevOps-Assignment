🚀 DevOps Multi-Cloud Deployment Assignment

A production-grade multi-cloud deployment demonstrating a FastAPI backend and Next.js frontend orchestrated across AWS (ECS Fargate) and GCP (Cloud Run). AWS infrastructure is provisioned using Terraform as Infrastructure as Code (IaC), with secure state management and environment isolation.

Live Application Links

Frontend: https://your-frontend-url.vercel.app

AWS Backend: http://your-alb-url.amazonaws.com

GCP Backend: https://your-cloud-run-url.run.app

Documentation (PDF): [Add PDF Link]
Demo Video: [Add Demo Link]

Overview

This project showcases a modern DevOps approach to production-grade multi-cloud deployment.

The system is designed with:

High availability

Horizontal scalability

Secure networking

Environment separation

Operational maturity

Engineering restraint (avoiding overengineering)

The backend is deployed across:

AWS (Primary Cloud) using ECS Fargate

GCP (Secondary Cloud) using Cloud Run

The frontend is deployed via Vercel and supports backend selection.

 Key Features

Multi-Cloud Design – Redundant backend deployment across AWS and GCP

Infrastructure as Code (IaC) – AWS provisioned via Terraform with remote state

Secure Networking – Private subnet isolation & security group hardening

Scalability – Automated horizontal scaling

Environment Isolation – Dev, Staging, and Prod separation

Zero-Downtime Deployments – Rolling updates with health checks

Operational Thinking – Failure scenarios & alerting philosophy documented

Architecture
AWS (Primary Cloud)

Ingress: Application Load Balancer (ALB) in public subnets

Compute: ECS Fargate tasks in private subnets

Health Checks: /api/health

Deployment Strategy: Rolling update (100/200)

Security: ALB is the only public entry point

Traffic Flow:

Internet → ALB → Target Group → ECS Fargate Tasks
GCP (Secondary Cloud)

Ingress: Managed HTTPS (Google-managed SSL)

Compute: Cloud Run (Serverless Containers)

Scaling: Automatic request-based scaling

Revision-based deployment & rollback

Traffic Flow:

Internet → Google Managed Ingress → Cloud Run Networking & Security
Feature	AWS	GCP
Public Entry	ALB	Managed HTTPS
Compute Exposure	Private Subnet	Fully Managed
SSL	HTTP (ALB default DNS limitation)	HTTPS (Google Managed Certs)
Access Control	Security Groups	IAM-based
Health Checks	Target Group	Platform-managed
Security Principles

No containers directly exposed publicly

No secrets stored in Git

No secrets embedded in Docker images

IAM least-privilege enforced

Stateless container design

Note: AWS HTTPS is intentionally not configured because ACM requires custom domain validation.

Scalability
AWS (ECS Fargate)

Resources: 2048 CPU | 4096 MB Memory

Capacity: Min 3 tasks | Max 10 tasks

Trigger: CPU-based autoscaling

High Availability: Multi-AZ distribution

GCP (Cloud Run)

Resources: 2 vCPU | 4 GiB Memory

Capacity: Min 1 instance | Max 10 instances

Trigger: Request-based concurrency scaling

Platform-managed resilience

Infrastructure as Code
AWS – Terraform

AWS infrastructure is provisioned using Terraform.

Remote Backend:

State Storage: Amazon S3

Locking: DynamoDB

Environment Isolation: Separate state per dev/staging/prod

Structure:

Infra/
├── Dev/
├── Staging/
└── Prod/

Resources Managed:

ECS Cluster

Fargate Services

ALB

Target Groups

Autoscaling policies

Security Groups

GCP – Managed Serverless Deployment

Cloud Run services are provisioned using Google Cloud’s managed platform.

Since Cloud Run abstracts:

Infrastructure

Load balancing

SSL

Instance lifecycle

Terraform was intentionally not applied to avoid unnecessary complexity.

Project Structure
.
├── backend/            # FastAPI application
│   ├── app/
│   │   └── main.py
│   └── requirements.txt
├── frontend/           # Next.js / React application
├── Infra/              # Terraform configs (AWS only)
│   ├── Dev/
│   ├── Staging/
│   └── Prod/
└── README.md
Local Setup
Prerequisites

Python 3.8+

Node.js 16+

npm or yarn

Docker

Terraform

AWS CLI (configured)

GCP CLI (configured)

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

Returns:

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

Architecture reasoning

Deployment strategy

Failure scenarios

Future growth planning

Engineering tradeoffs

🎥 Demo Video

Demo walkthrough (8–12 minutes):

➡️ [Add Demo Video Link]

Covers:

Repository walkthrough

AWS deployment

GCP deployment

Environment separation

Autoscaling configuration

Networking explanation

Operational thinking

Tradeoffs & limitations

Cost Awareness

AWS ECS + ALB incur steady operational cost

Cloud Run scales based on traffic

Non-production environments can be scaled down post-evaluation

Managed services reduce operational overhead

✅ Final Status

AWS backend deployed and healthy

GCP backend deployed and healthy

Frontend publicly accessible

Autoscaling configured

Environment separation implemented

Terraform remote state configured (S3 + DynamoDB)

Multi-cloud architecture validated

🎯 Engineering Philosophy

The system was designed to:

Avoid overengineering

Use managed services where appropriate

Maintain scalability without Kubernetes

Enable incremental evolution

Balance reliability and simplicity
