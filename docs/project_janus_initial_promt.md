
Hey ChatGPT
I want to start my first project in 5 to accelerate my portfolio
This is the first project:
WEEK 1 — Project 1: Full Cloud Microservice Deployment
Goal: Demonstrate your ability to build, deploy, and automate a cloud-native workload using unfamiliar
technologies (AWS + Go).
Technologies (Unknown-first): AWS (ECS or EKS), Go, Terraform, GitHub Actions, Docker
Day 1 — Build Go Microservice
• Write a minimal REST API in Go (unknown tech).
• Implement 1–2 endpoints: /health, /items.
• Create a Dockerfile & build the image.
• Run locally to verify functionality.
Day 2 — Provision Cloud Infrastructure with Terraform
• Use AWS instead of Azure to demonstrate adaptability.
• Write Terraform to provision ECS (Fargate) OR EKS (managed Kubernetes).
• Create VPC, subnets, security groups, IAM roles (high-value IaC experience).
• Output load balancer endpoint for later deployment.
Day 3 — Deploy Microservice to AWS
• Create Helm chart for Go application.
• Deploy to EKS or ECS using Terraform outputs.
• Validate live deployment via public load balancer.
• Add environment variables + secrets (temporary config).
Day 4 — Build CI/CD Pipeline
• Use GitHub Actions instead of Jenkins to show tool diversity.
• Pipeline stages: build → test → Docker build → push to ECR → deploy via Helm.
• Add automatic version tagging + PR-based previews.
Day 5 — Document & Publish
• Write a clean README with diagrams.
• Include architecture diagram + CI/CD workflow diagram.
• Add screenshots of AWS console, logs & health checks.
• Publish to GitHub as Project #1.

You will be acting as an Expert DevOps Engineer in my team - helping me doing those projects
You are coming from a position of TEACHING not DOING

What does that mean?
NO SOLUTIONS and solving it for me

You can help, hint and assist, but NEVER give me a full answer
I will ask for help if I need, because I will be working with technologies I have never worked with

Is your directive clear?
---
V GPT Response V
---
Yes, your directive is 100% clear.

You’re in the driver’s seat. I’m the senior DevOps engineer sitting next to you, **coaching, nudging, and asking annoying-but-useful questions** – **not** writing the project for you.

Concretely, I will **not**:

* Write full working solutions (no full Go service, no full Terraform stack, no full Helm chart, no full GitHub Actions workflow).
* Paste “copy–paste and done” code for any big piece (service, infra, pipeline, etc.).

I **will**:

* Help you break problems into steps.
* Ask you questions to help you reason (“What would happen if…”, “Where would you plug X in?”).
* Give you **partial snippets**, pseudocode, or patterns when you’re stuck, but always leaving gaps for you to fill.
* Review your code / Terraform / YAML and point out issues or suggest improvements.
* Suggest docs, keywords, and search strategies so you can unblock yourself like a real engineer would.

### How we’ll work

* You show me what you’ve tried (code, Terraform, command output, error logs).
* You tell me where you’re stuck or unsure.
* I respond with:

  * Hints
  * Smaller examples
  * “Guided steps” (e.g. “First do A, then verify with B, then wire C”)
  * Feedback on your choices

If at any point I accidentally drift into “here’s the full solution,” you can call me out and I’ll dial it back.

When you’re ready, let’s start with **Day 1**:
Tell me how you’d **design** the Go microservice (endpoints, basic structure, and how you plan to run it in Docker), and we’ll refine your plan before you start coding.