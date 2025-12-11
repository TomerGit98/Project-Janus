# 🚀 Project Janus: Go Microservice on AWS EKS
<p align="center">
  <a href="https://github.com/TomerGit98/Project-Janus/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/TomerGit98/Project-Janus/janus-ci-cd.yaml?branch=main&label=CI%2FCD" alt="CI/CD Status">
  </a>
  <img src="https://img.shields.io/github/languages/top/TomerGit98/Project-Janus" alt="Top language">
  <img src="https://img.shields.io/github/repo-size/TomerGit98/Project-Janus" alt="Repo size">
  <img src="https://img.shields.io/badge/cloud-AWS-FF9900?logo=amazon-aws&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/kubernetes-EKS-326CE5?logo=kubernetes&logoColor=white" alt="EKS">
  <img src="https://img.shields.io/badge/helm-chart-0F1689?logo=helm&logoColor=white" alt="Helm">
  <img src="https://img.shields.io/badge/terraform-IaC-7B42F6?logo=terraform&logoColor=white" alt="Terraform">
</p>

**This project was - of course - AI Assisted, but not in the sense you think**
What does that mean? - my initial prompt can be found in:
  * **`docs/project_janus_initial_promt.md`**
---
**Lying about using AI is bad - so I am transparent in how I used it, some times I got really really stuck, and treated him like my Senior helping me, more suggestions, even fixes.**
**But I am proud to say - I did alone - with guidance - the majority of the work :D**
---
# Now - INTRO! :D
**Project Janus** is a small but “real-world style” Go microservice deployed on **AWS EKS**, designed to show end-to-end DevOps skills:

- **Go microservice** with:
  - `/health` – simple health check,
  - `/items` – sample JSON API,
  - `/metrics` – Prometheus metrics (`cpu_temperature_celsius`, `hd_errors_total`).
- **Infrastructure as Code** with **Terraform**:
  - VPC, Subnets, NAT Gateway,
  - EKS cluster (`project-janus`),
  - Managed node group and addons (CNI, CoreDNS, kube-proxy).
- **Deployment & configuration** with **Helm**:
  - App chart, Service, LoadBalancer, probes, resources,
  - ConfigMap for non-secret config,
  - K8s Secret from External Secrets.
- **Secure secrets** with:
  - **External Secrets Operator** (ESO),
  - **AWS Secrets Manager**.
- **Observability** with:
  - **kube-prometheus-stack** (Prometheus + Grafana),
  - **metrics-server** (resource metrics),
  - `ServiceMonitor` for app metrics.
- **CI/CD** with **GitHub Actions**:
  - `go test ./...`,
  - Docker build & push to ECR,
  - `helm upgrade --install` to EKS.

This repo is intentionally small but touches many “real job” topics: IAM, EKS access, Helm, ESO, metrics, and GitHub Actions.
This repository encapsulates a flow:
1. Terraform creates the VPC + EKS + node group.
2. GitHub Actions builds and pushes the Go image to ECR and deploys via Helm.
3. ESO pulls secrets from AWS Secrets Manager into a K8s Secret.
4. The app exposes metrics; Prometheus scrapes them; Grafana visualizes them.


## 🌟 Key Technologies

| Category | Tools | Description |
| :--- | :--- | :--- |
| **Microservice** | **Go (Golang)** | A language I never touched before |
| **IaC & Cloud** | **Terraform, AWS EKS, AWS Secrets Manager** | Full provisioning of VPC, EKS cluster, and necessary IAM roles. - Fist time playing with it |
| **Containerization** | **Docker, AWS ECR, Helm** | Container image building, private registry, and Kubernetes packaging. - first time writing my OWN chart and not working on existing one |
| **Orchestration** | **Kubernetes** | Deployment, Service, Ingress, ConfigMaps, and health probes. first major K8s playing |
| **Security** | **External Secrets Operator (ESO)** | Securely syncs secrets from AWS Secrets Manager to Kubernetes `Secrets`. - because I didn't want to upload with a "secret" to GitHub - even though it was a mock (watch Harry Potter and you can guess it) |
| **Observability** | **Prometheus, Grafana** | Automated scraping of application metrics via `ServiceMonitor`. - First time creating it and dashboards, not only using the UI |
| **CI/CD** | **GitHub Actions** | Automated build, test, push, and zero-downtime Helm deployment. - Planty of play with Jenkins - but not enough with GHActions - so I chose it |

---

## 📐 Architecture Overview

The diagram below illustrates the flow of infrastructure, code, deployment, and observability components. 

| Component | Role |
| :--- | :--- |
| **Go Microservice** | The core application, exposing `/health`, `/items`, and custom `/metrics`. |
| **GitHub Actions** | CI/CD pipeline. Builds the Go app, runs tests, pushes the image to **ECR**, and deploys to **EKS** via Helm. |
| **Terraform** | Provisions the **AWS EKS** cluster, VPC, and all supporting infrastructure. |
| **External Secrets Operator** | Deploys `ExternalSecret` to fetch sensitive data from **AWS Secrets Manager** and create a native K8s `Secret`. |
| **Prometheus/Grafana** | Scrapes the application's `/metrics` endpoint (via `ServiceMonitor`) and visualizes data in Grafana dashboards. |

```mermaid
flowchart LR
  subgraph AWS["AWS Account"]
    subgraph VPC["VPC (project-janus)"]
      subgraph eks["EKS Cluster (project-janus)"]
        subgraph ns_app["Namespace: default"]
          svc[Service: go-demo-go-microservice-chart (LoadBalancer)]
          pod[Pod: Go microservice\n(main.go + /metrics)]
        end

        subgraph ns_ext["Namespace: external-secrets"]
          eso[External Secrets Operator]
        end

        subgraph ns_mon["Namespace: monitoring"]
          prom[Prometheus]
          graf[Grafana]
        end

        svc --> pod
        prom --> svc
        prom -->|"ServiceMonitor"| svc
      end
    end

    secrets[AWS Secrets Manager\nweek1/go-microservice/placeholder]
    ecr[ECR: portfolio-projects/go-microservice-demo]
  end

  gha[GitHub Actions CI/CD] -->|Push image| ecr
  gha -->|helm upgrade/install| eks

  eso --> secrets
  pod -->|scraped metrics| prom
  graf --> prom
```
---

## 🚀 Features Implemented

### Infrastructure (Terraform)
* **Networking:** Full VPC setup with public/private subnets and NAT Gateway.
* **EKS Cluster:** Managed Node Group on EC2 instances.
* **Security:** IAM access entries for cluster administration and a dedicated IAM Role for ESO integration.

### Application (Go Microservice)
* Standard Go HTTP server with health and items endpoints.
* **Custom Prometheus Metrics:** Implements domain-specific metrics (e.g., `cpu_temperature_celsius`, `hd_errors_total`) for observability demonstration.
* Unit tests for all core handlers and helper functions.

### Kubernetes (Helm)
* A robust **Helm Chart** packaging the entire microservice.
* Includes `Deployment`, `Service`, `ConfigMap`, `Ingress`, and `ServiceMonitor`.
* Configuration for **readiness and liveness probes** for reliable deployment.
* Secure secrets handling using **`ExternalSecret`** and **`ClusterSecretStore`** resources.

### Observability
* Deployment of the **`kube-prometheus-stack`** (Prometheus + Grafana).
* Automatic metric scraping using a dedicated **`ServiceMonitor`** resource targeting the Go app's `/metrics`.
* Grafana automatically discovers and visualizes application metrics.

---

## 📦 Getting Started

You’ll need:

* AWS account + IAM user/role with:

  * Permissions for EKS, EC2, VPC, IAM, Secrets Manager, ECR.
* Local tools:

  * `terraform`
  * `aws` CLI
  * `kubectl`
  * `helm`
  * `docker`
  * Go toolchain (`go`)

Make sure your AWS credentials are set (e.g. via `aws configure`) and your IAM identity matches what Terraform and EKS expect (e.g. `terraform-user` / `janus-ci` in your setup).
---
### 1. Deploy Infrastructure (AWS EKS)

Use Terraform to provision the entire cloud environment, including the VPC, EKS cluster, and IAM roles.

```bash
cd infra
terraform init
terraform apply
```

After successful deployment, configure your local `kubectl` to connect to the new cluster:

```bash
aws eks update-kubeconfig \
  --region eu-central-1 \
  --name $(terraform output -raw Cluster_Name)
```

### 2\. Set Up External Secrets Operator (ESO)

The ESO requires an IAM role configured to read from AWS Secrets Manager. Update the placeholder below with the IAM Role ARN outputted by Terraform.
**> The IAM role ARN is output by Terraform (for example: `eso_iam_role_arn`) – plug that value into the `role-arn` below.**
```bash
# Install the External Secrets Operator
helm repo add external-secrets [https://charts.external-secrets.io](https://charts.external-secrets.io)
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --create-namespace \
  --set serviceAccount.create=true \
  --set serviceAccount.name=external-secrets \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="<IAM-ROLE-ARN-FROM-TERRAFORM>"

# Apply the SecretStore and ExternalSecret manifests
kubectl apply -f k8s/secretstore.yaml
kubectl apply -f k8s/externalsecret.yaml
```

### 3\. Enable Prometheus Monitoring

Install the comprehensive monitoring stack.

```bash
helm repo add prometheus-community [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts)
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

**Access Grafana and Prometheus:**
Port-forward the services to view the dashboards and scraped metrics:

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090:9090
```

### 4\. Deploy the Application

Deploy the microservice using the bundled Helm chart.

```bash
helm upgrade --install go-demo ./go-microservice-chart
```

**Verification:**

```bash
# LB Variable is for getting the external Load Balancer hostname and test the app
LB=$(kubectl get svc go-demo-go-microservice-chart \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo "LB URL: http://$LB"

# Basic health checks
curl "http://$LB/health"
curl "http://$LB/items"
curl "http://$LB/metrics"
```

-----

## 🤖 CI/CD with GitHub Actions

The `ci-cd.yaml` workflow automates the entire deployment process upon every push to the `main` branch.

**Workflow Stages:**

1.  **Test:** Runs all Go unit tests.
2.  **Build & Push:** Builds the Docker image and pushes it to AWS ECR.
3.  **Deploy:** Authenticates to EKS using OIDC/IAM and executes a `helm upgrade --install` for a zero-downtime deployment.

> **Note:** The CI/CD pipeline uses a dedicated `janus-ci` IAM user/role with scoped permissions for ECR push and EKS deployment operations (Principle of Least Privilege).

-----

## 📚 Repository Structure

A clear layout for navigation and maintenance:

```
Project-Janus/
├── app/                      # Go microservice source code
├── go-microservice-chart/    # Helm chart for Kubernetes deployment
├── infra/                    # Terraform (IaC) for AWS provisioning
├── k8s/                      # External Secrets Operator (ESO) manifests
├── .github/workflows/        # GitHub Actions CI/CD pipeline
└── docs/                     # Operational runbooks and diagrams
```

### Local App Usage

To run the Go application directly for local testing:

```bash
cd app/
go run main.go
# Test Endpoints:
curl localhost:8080/health
curl localhost:8080/items
curl localhost:8080/metrics
```

-----

## 📘 Operational Runbook

For day-to-day operations, maintenance, and debugging, a full operational guide is provided:

  * **`docs/project_janus_daily_runbook.pdf`**

This runbook includes:

  * Start of Day / End of Day checklists.
  * Health verification steps for the EKS cluster, pods, and services.
  * Commands for checking secrets, Prometheus targets, and node status.
---


### “Moreshet Krav” / Lessons Learned
---
**TL;DR**
- Learned how EKS *actually* handles access: Access Entries instead of the old `aws-auth` ConfigMap.
- Debugged a broken node group where EC2 was “healthy” but nodes never joined the cluster.
- Integrated External Secrets Operator with AWS Secrets Manager and debugged a real “wrong secret path” issue.
---
## 1. Node Group didn't manage to start (1.5d until fixed)
📌 Summary

While provisioning an Amazon EKS cluster using Terraform, the cluster itself was created successfully, but the managed node group repeatedly failed with NodeCreationFailure, and kubectl was unable to authenticate to the cluster, returning:

```bash
error: You must be logged in to the server (the server has asked for the client to provide credentials)
```

This prevented debugging node health from inside Kubernetes and stalled progress.
---
🎯 Main Symptoms Observed
1. Node group creation failed repeatedly

Terraform produced errors such as:
```bash
NodeCreationFailure: Unhealthy nodes in the kubernetes cluster
```

Even though EC2 instances were running and passed health checks.

2. kubectl could not authenticate

Running:
```bash
kubectl get nodes
```

returned:
```bash
the server has asked for the client to provide credentials
```

even after:
```bash
aws eks update-kubeconfig
```
3. EKS console showed no RBAC mapping for our IAM user

In EKS → Cluster → Access, only two entries existed:

The EKS service role

The node group role

There was no access entry for our IAM user (terraform-user).

This meant the cluster existed, but nobody had permission to talk to it.
---
🔍 Root Causes
Root Cause 1 — Missing EKS access entry (authentication mapping)

EKS no longer uses the old aws-auth ConfigMap for RBAC.
Instead, it uses Access Entries, managed either manually or via Terraform.

Because enable_cluster_creator_admin_permissions = true was not applied correctly (unsaved file), Terraform did not create:

An aws_eks_access_entry

An aws_eks_access_policy_association

Meaning:

***The IAM user creating the cluster (terraform-user) was not given admin access to Kubernetes.***

This explains the kubectl login error.
---
Root Cause 2 — Node groups depend on working authentication & networking

The node group creation process requires:

The aws-node CNI to come up

Nodes to register with the API server

RBAC to be functional

Because the authentication layer was broken, nodes could not join the cluster, which caused:
```bash
NodeCreationFailure: Unhealthy nodes
```

---
🧪 Troubleshooting Steps Attempted

Throughout investigation we validated:

**Networking**

Subnets existed

NAT gateway existed

Routes were correct

Public IP on launch was enabled

Load balancer access was set to public = true

Networking turned out not to be the issue.

**AWS CLI & kubeconfig**

Upgraded AWS CLI from v1 → v2

Regenerated kubeconfig using:
```bash
aws eks update-kubeconfig
```

Verified token via:

aws eks get-token


All passed — meaning kubeconfig generation wasn’t the root issue.

**IAM Role Policies**

Checked all relevant IAM permissions.
IAM was correct — the missing link was EKS access entries.
---
✅ The Fix

Once we identified missing RBAC mapping, we corrected the Terraform configuration:

1. Added the correct EKS access entry

Inside the eks module block:
```hcl
enable_cluster_creator_admin_permissions = true
```

This tells the module:

Give full cluster-admin rights to the identity running the Terraform apply.

2. Ensured addons were installed

Without CNI, nodes cannot join the cluster:
```bash
addons = {
  coredns = { most_recent = true }
  kube-proxy = { most_recent = true }
  vpc-cni = { most_recent = true }
}
```
3. Ensured the correct IAM user was running Terraform

By verifying:
```bash
aws sts get-caller-identity
```

Output matched:
```bash
arn:aws:iam::184397997945:user/terraform-user
```
4. Destroyed everything

To avoid partial state side-effects:
```bash
terraform destroy
```
5. Re-applied with the corrected configuration
```bash
terraform apply
```
---

🧠 Key Lesson Learned

EKS cluster creation is not enough — the IAM identities interacting with Kubernetes MUST be explicitly mapped using EKS Access Entries.

Without that, the cluster exists but is unusable.

This mistake is extremely common, especially for people transitioning from older EKS (or EKS tutorials) where aws-auth was created automatically.
---

## 2. Secret Handling Issue
Problem Symptoms

After integrating External Secrets Operator (ESO) with AWS Secrets Manager, the pod still displayed:

```bash
PLACEHOLDER_SECRET=BoogaBoo
```

However, the intended secret value in AWS was:
```bash
PLACEHOLDER_SECRET=AbraKadabra
```

Even after deleting the Kubernetes Secret object, restarting the deployment, and confirming the ExternalSecret was syncing correctly, the pod continued to show the old value.

Initial Hypothesis

Helm templates still referenced the old hardcoded value
→ We removed all hardcoded values (BoogaBoo) from:

secret.yaml (deleted completely)

values.yaml

deployment.yaml

Possible SecretStore misconfiguration
→ Fixed API version mismatch and namespace mismatch
→ Ensured SecretStore referenced the correct service account and region.

ESO not syncing
→ kubectl describe externalsecret showed "secret synced" which meant ESO was working.

But the pod still showed the old value.

❗ Discovery of the Real Issue

A manual check in AWS Secrets Manager revealed:

There were TWO secrets:

Secret name	Value
week1/go-microservice/placeholder	AbraKadabra
week1/go-microservice-demo (unexpected)	BoogaBoo

The ExternalSecret was pointing to the wrong secret (week1/go-microservice-demo).

This was the source of truth the pod was receiving — not the new secret.

✅ Final Fix

Deleted the incorrect secret:
```bash
aws secretsmanager delete-secret \
  --secret-id week1/go-microservice-demo \
  --force-delete-without-recovery
```

Updated the ExternalSecret to reference:

```text
week1/go-microservice/placeholder
```

Applied the corrected manifest:
```bash
kubectl apply -f externalsecret.yaml
kubectl rollout restart deployment go-demo-go-microservice-chart
```

Verified:
```bash
kubectl exec -it $POD -- sh -c 'env | grep PLACEHOLDER_SECRET'
```

Result:
```bash
PLACEHOLDER_SECRET=AbraKadabra
```

---

## How I’d Extend This in a Real Job?

If this were part of a production system, next steps would include:

1. **Multiple environments**:

   * Split into `dev`, `staging`, `prod`:

     * Separate Terraform workspaces or separate state,
     * Per-env Secrets Manager paths,
     * Per-env Helm values (resources, autoscaling, etc.).

2. **Richer observability**:

   * Real metrics (latency histograms, request counts),
   * Logs shipping (e.g., Fluent Bit → CloudWatch / Loki),
   * Basic alerting rules (e.g., high error rate, pod restarts, etc.).

3. **Stronger security**:

   * Pod security (runAsNonRoot, readOnlyRootFilesystem),
   * NetworkPolicies,
   * Image scanning in CI (Trivy),
   * Policy-as-code (e.g., Checkov for Terraform).

4. **Autoscaling and resilience**:
   * HPA based on CPU and/or custom metrics.
   * PodDisruptionBudgets for safe node drains.
   * Multiple AZ node groups for better resilience.

---

## Contact (me - of course)

Author: **Tomer Avisar**
Role: DevOps Engineer
- GitHub: [TomerGit98](https://github.com/TomerGit98)  
- LinkedIn: [linkedin.com/in/tomer-avisar-41248b1a3](https://www.linkedin.com/in/tomer-avisar-41248b1a3/)
Feel free to reach out on LinkedIn or GitHub for feedback or ideas.