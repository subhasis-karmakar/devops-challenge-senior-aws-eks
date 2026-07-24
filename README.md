# DevOps Challenge - AWS EKS Infrastructure Automation

Production-ready solution for the Particle41 Senior DevOps Challenge using **Terraform**, **Amazon EKS**, **Amazon ECR**, **Docker**, **GitHub Actions**, and the **AWS Load Balancer Controller**.

---

## Architecture

```text
                    GitHub
                       │
          GitHub Actions (Manual)
        ┌─────────┼──────────┐
        │         │          │
        ▼         ▼          ▼
 Terraform     Docker     Kubernetes
 Infrastructure Build      Deploy
        │         │          │
        ▼         ▼          ▼
      AWS      Amazon ECR   Amazon EKS
        │                    │
        └────────────┬───────┘
                     ▼
          AWS Load Balancer Controller
                     │
                     ▼
             Application Load Balancer
                     │
                     ▼
                Flask Application
```

---

# Features

- Infrastructure as Code using Terraform
- Amazon EKS Cluster
- Managed Node Group
- Custom VPC
- Public & Private Subnets
- NAT Gateway
- Internet Gateway
- IAM Roles
- OIDC Provider
- Amazon ECR
- AWS Load Balancer Controller
- Application Load Balancer (ALB)
- Kubernetes Deployment
- Kubernetes Service
- Kubernetes Ingress
- Health Checks
- GitHub Actions CI/CD
- Docker Multi-stage Build
- Production-ready project structure

---

# Project Structure

```text
.
├── .github
│   └── workflows
│       ├── terraform.yml
│       ├── build-and-push.yml
│       └── deploy.yml
│
├── app
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── namespace.yaml
│
├── terraform
│   ├── backend.tf
│   ├── backend.hcl
│   ├── providers.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── networking.tf
│   ├── security-groups.tf
│   ├── iam.tf
│   ├── eks.tf
│   ├── nodegroup.tf
│   ├── alb-controller.tf
│   ├── ecr.tf
│   ├── outputs.tf
│   └── versions.tf
│
└── README.md
```

---

# Technology Stack

| Technology | Purpose |
|------------|---------|
| Terraform | Infrastructure as Code |
| AWS EKS | Kubernetes |
| Amazon ECR | Container Registry |
| Docker | Containerization |
| GitHub Actions | CI/CD |
| AWS ALB Controller | Ingress Controller |
| Python | Application |
| Flask | REST API |

---

# Infrastructure

Terraform provisions

- Custom VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Amazon EKS Cluster
- Managed Node Group
- IAM Roles
- OIDC Provider
- Amazon ECR Repository
- AWS Load Balancer Controller

---

# CI/CD Pipeline

## 1. Infrastructure

```text
terraform.yml
```

Performs

- Terraform Init
- Terraform Format Check
- Terraform Validate
- Terraform Plan
- Terraform Apply

---

## 2. Build

```text
build-and-push.yml
```

Performs

- Build Docker Image
- Login to Amazon ECR
- Push Image
- Tag latest
- Tag Git SHA

---

## 3. Deploy

```text
deploy.yml
```

Performs

- Update kubeconfig
- Deploy Kubernetes resources
- Wait for rollout
- Verify deployment
- Display ALB URL

---

# Deployment Workflow

```text
Terraform
      │
      ▼
Amazon EKS
      │
      ▼
Build Docker Image
      │
      ▼
Push to Amazon ECR
      │
      ▼
Deploy to Kubernetes
      │
      ▼
Application Load Balancer
      │
      ▼
Application Available
```

---

# Application Endpoints

| Endpoint | Description |
|----------|-------------|
| / | Home |
| /health | Health Check |

---

# GitHub Secrets

| Secret |
|---------|
| AWS_ACCESS_KEY_ID |
| AWS_SECRET_ACCESS_KEY |
| AWS_REGION |
| AWS_ACCOUNT_ID |
| ECR_REPOSITORY |
| EKS_CLUSTER_NAME |

---



## GitHub Actions

The project uses three manual GitHub Actions workflows for infrastructure provisioning, container image build, and Kubernetes deployment.

---

## GitHub Actions

![GitHub Actions](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/github-actions.jpg)

---

## Amazon EKS Cluster

![Amazon EKS](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/eks-cluster.jpg)

---

## Amazon ECR Repository

![Amazon ECR](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/ecr.jpg)

---

## AWS Application Load Balancer

![ALB](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/alb.jpg)

---

## Running Application

![Application](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/application.jpg)

---

## Kubernetes Pods

![Pods](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/pods.jpg)

---

## Kubernetes Ingress

![Ingress](https://raw.githubusercontent.com/subhasis-karmakar/devops-challenge-senior-aws-eks/main/docs/images/ingress.jpg)



# Project Setup (GitHub Actions)

This project is deployed entirely using **GitHub Actions**. After configuring the required GitHub Secrets and Variables, simply run the workflows in the specified order.

## Prerequisites

Before deploying the project, ensure you have:

- An AWS Account
- A GitHub Account
- An IAM user with permissions to manage:
  - Amazon VPC
  - Amazon EC2
  - Amazon EKS
  - Amazon ECR
  - IAM
  - Elastic Load Balancer (ALB)
  - Amazon S3
  - Amazon DynamoDB

---

## Step 1: Fork or Clone the Repository

```bash
git clone https://github.com/<your-github-username>/devops-challenge-senior-aws-eks.git

cd devops-challenge-senior-aws-eks
```

Push the repository to your own GitHub account.

---

## Step 2: Create Terraform Backend Resources

Create an Amazon S3 bucket for the Terraform remote state.

```bash
aws s3 mb s3://<terraform-state-bucket>
```

Create a DynamoDB table for Terraform state locking.

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

## Step 3: Update Terraform Configuration

Update the following files with your AWS environment details:

### `terraform/backend.hcl`

Update the values for:

- S3 bucket name
- Region
- DynamoDB table

Example:

```hcl
bucket         = "<terraform-state-bucket>"
key            = "terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-locks"
encrypt        = true
```

### `terraform/terraform.tfvars`

Review and update the configuration as required for your environment, including:

- AWS Region
- Project Name
- Environment
- Kubernetes Version
- Node Group Configuration

---

## Step 3: Configure GitHub Secrets

Navigate to:

**GitHub → Repository → Settings → Secrets and variables → Actions**

### Repository Secrets

Configure the following secrets:

| Secret | Description |
|---------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key |
| `AWS_ACCOUNT_ID` | AWS Account ID |
| `AWS_REGION` | us-east-1 |
| `ECR_REPOSITORY` | particle41-dev-ecr |
| `EKS_CLUSTER_NAME` | particle41-dev-eks |

---

## Step 4: Execute GitHub Actions

Run the following workflows in order from the **Actions** tab.

### 1. Terraform Infrastructure

This workflow provisions:

- VPC
- Public & Private Subnets
- Internet Gateway
- NAT Gateway
- IAM Roles
- Amazon EKS Cluster
- Managed Node Group
- Amazon ECR Repository
- AWS Load Balancer Controller

Wait until the workflow completes successfully.

### 2. Build & Push Docker Image

This workflow:

- Builds the application Docker image
- Pushes the image to Amazon ECR

### 3. Deploy Application

This workflow:

- Deploys the application to Amazon EKS
- Performs a rolling update
- Waits for the deployment rollout to complete

---

## Step 5: Verify the Deployment

After the workflows complete successfully, configure `kubectl`:

```bash
aws eks update-kubeconfig \
  --region <AWS_REGION> \
  --name <EKS_CLUSTER_NAME>
```

Verify the deployment:

```bash
kubectl get nodes

kubectl get pods -n particle41

kubectl get ingress -n particle41
```

Retrieve the ALB URL:

```bash
kubectl get ingress -n particle41
```

Access the application:

```text
http://<ALB_DNS_NAME>
```

Or verify using:

```bash
curl http://<ALB_DNS_NAME>
```

---

## GitHub Actions Execution Order

```text
Terraform Infrastructure
          │
          ▼
Build & Push Docker Image
          │
          ▼
Deploy Application
          │
          ▼
Application Available via ALB
```

> **Note:** The GitHub Actions workflows automatically consume the configured GitHub Secrets and Variables to provision infrastructure and deploy the application. No manual Terraform or Kubernetes commands are required during deployment.


# Skills Demonstrated

- AWS
- Kubernetes
- Amazon EKS
- Docker
- Terraform
- Infrastructure as Code
- GitHub Actions
- Continuous Integration
- Continuous Deployment
- Amazon ECR
- IAM
- VPC Networking
- ALB
- Kubernetes Ingress
- Production DevOps Practices

---

# Future Improvements

- Helm Charts
- ArgoCD GitOps
- Prometheus
- Grafana
- ExternalDNS
- Cert Manager
- HTTPS with ACM
- Horizontal Pod Autoscaler
- Cluster Autoscaler
- SonarQube
- Trivy Security Scan
- OPA/Gatekeeper

---

# Author

**Subhasis Karmakar**

Senior DevOps | Cloud | Kubernetes | Terraform | AWS | GitHub Actions
