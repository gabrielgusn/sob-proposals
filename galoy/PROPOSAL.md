# Summer of Bitcoin Proposal: Add AWS Support to Galoy-Infra

## Name and Contact Information

* **Name:** Gabriel Gustavo Nicolodi
* **Email:** gabriel.gnicolodi@gmail.com and gabriel.nicolodi@proton.me
* **Discord:** gnicld
* **Time Zone:** America/Sao_Paulo (GMT-3)
* **University Name:** Paraná's Federal University of Technology - UTFPR
* **Country:** Brazil
* **GitHub:** github.com/gabrielgusn
* **LinkedIn:** linkedin.com/in/gabrielgusn

## Title

Add AWS Support to Galoy-Infra

## Synopsis

This project will extend the `galoy-infra` repository to support Amazon Web Services (AWS), adding the most used Cloud as an option alongside GCP and Azure. Using Terraform, I will develop modules for core AWS infrastructure: private networking (VPC), managed Kubernetes with Ingress Controller(EKS), a relational database (RDS), Bastion host for access and least-privilege access management (IAM). The focus is on a secure-by-default foundation with Kubernetes Network Policies and precise IAM roles, enabling flexible deployment of Galoy application stacks (like Blink, Lana, Bria, Cala, Stablesats) on AWS.

## Project Plan

This project creates Terraform modules for AWS mirroring the existing `galoy-infra` structure, focusing on delivering a production-ready AWS platform efficiently, then enabling core Galoy application deployment.

### Phase 0: Research & Preparation (Pre-SoB / Community Bonding)

* **Analyze Existing `galoy-infra`:** Review GCP/Azure modules and examples for structure and patterns.
* **Initial Galoy Stacks Analysis:** Begin understanding Galoy and its infrastructure needs for its applications (e.g., Blink, Lana, Bria, Cala, Stablesats) based on the application repositories and documentation.
* **Setup:** Configure development environment and AWS credentials.
* **Competency Test Completion:** Finish the competency test using only Terraform providers resources.

### Phase 1: Core Infrastructure Provisioning & Continued Analysis (Approx. Weeks 1-8)

Rapidly build the foundational AWS infrastructure platform via Terraform while deepening the understanding of application requirements.

* **Continue Galoy Stack Analysis:** Further analyze the deployment requirements, dependencies, and operational needs of the target Galoy stack(s) identified in Phase 0, ensuring infrastructure choices align with application needs.
* **Terraform State:** Configure S3 backend.
* **Module Development:** Create `modules/inception/aws`, `modules/platform/aws`, `modules/postgresql/aws`.
* **Secure Networking (`inception/aws`):** Implement secure VPC (private/public subnets across AZs, NAT Gateway(s), IGW, Route Tables, Security Groups).
* **Access Management (`inception/aws`):** Implement essential IAM Roles (EKS Cluster/Node, RDS access) with least privilege.
* **Managed Kubernetes (`platform/aws`):** Provision EKS cluster (Control Plane, Node Groups). Configure secure cluster access and an Ingress Controller (Nginx or AWS ALB Ingress Controller).
* **Relational Database (`postgresql/aws`):** Provision RDS PostgreSQL (Multi-AZ, private subnets, backups, encryption). Configure EKS and Bastion host access.
* **Initial K8s Config:** Implement baseline Kubernetes Network Policies via Terraform.
* **Testing & Docs:** Develop `examples/aws` for core infra deployment. Verify EKS-RDS connectivity. Document modules (`README.md`).

### Phase 2: Application Stack Enablement (Approx. Weeks 9-12)

Configure the AWS environment for deploying one or more core Galoy application stacks, **prioritized in discussion with mentors** (e.g., Blink, Lana, Bria, Cala, Stablesats), leveraging the analysis from Phase 1.

* **App Requirements Implementation:** Translate the analyzed requirements into specific configurations: K8s resources (Namespaces, SA, etc.), IAM permissions, networking rules, dependencies, and secrets.
* **Terraform for K8s Resources:** Manage app-specific K8s resources and dependencies (e.g., via Helm provider).
* **Refined Security:** Implement detailed K8s Network Policies and specific roles tailored to the target application(s).
* **Basic Observability:** Enable and configure AWS CloudWatch Container Insights via Terraform for foundational monitoring.
* **Deployment Examples:** Enhance `examples/aws` with configurations/scripts for deploying the target application stack(s).
* **Testing & Validation:** Perform functional testing of the target stack(s) on AWS. Verify security/observability.
* **Final Documentation:** Complete all module and example documentation.

## Project Timeline

*(Approximate 14-week timeline, adjust based on official dates)*

* **Community Bonding:** Complete Phase 0 (Initial Analysis, Research, Setup). Refine plan with mentors.
* **Phase 1: Core Infrastructure & Continued Analysis (Weeks 1-6):**
    * **W 1-2:** Continue Galoy stack analysis. Implement VPC & core IAM. Configure state backend.
    * **W 3-4:** Continue analysis. Implement EKS & baseline Network Policies.
    * **W 5-8:** Finalize analysis needed for Phase 1. Implement RDS. Test core infra integration (EKS<->RDS<->Bastion). Document modules.
* **Mid-term Evaluation (Around W 8):** Report progress. Demonstrate core infra. Discuss Phase 2 application focus and specific enablement plan based on completed analysis.
* **Phase 2: Application Enablement (Weeks 9-12):**
    * **W 9-10:** Implement specific K8s resources & Network Policies via Terraform based on Phase 1 analysis.
    * **W 9-10:** Enable basic observability (CloudWatch Insights).
    * **W 11-12:** Finalize Terraform configs for app enablement. Develop deployment examples.
* **Final Weeks (Weeks 13-14):** Buffer. Final testing & validation. Complete documentation. Code cleanup. Prepare submission.
> Reporting progress in each week

* **Time Commitment:** Approx. 20 hours/week. During the week I work as a full-time DevSecOps Engineer at LuizaLabs at 9:00-18:00 UTC-3, for that I will focus on the project mainly at night and weekends. At night I have college classes but that should not be any kind of impediment.

## Deliverables

1.  **Terraform Modules:** Functional, documented modules for `inception/aws` (VPC/IAM), `platform/aws` (EKS), `postgresql/aws` (RDS).
2.  **Application Enablement Resources (Terraform):** Code managing K8s resources (Namespaces, SA, Network Policies, Ingress Controller) and IAM roles for the target Galoy application stack(s).
3.  **Basic Observability:** Configuration enabling CloudWatch Insights for EKS.
4.  **Example Implementation (`examples/aws`):** Working example for core infrastructure and guidance/scripts for deploying the target application stack(s).
5.  **Comprehensive Documentation:** Module READMEs and example guides.

**Stretch Goals:**

1.  **Full Observability Stack:** Deploy Prometheus/Grafana stack via Terraform/Helm.
2.  **Performance Benchmarking:** Basic performance tests of the deployed stack.

## Future Deliverables

1.  **Community Support:** Assist users adopting the AWS infrastructure post-SoB.
2.  **Enhanced Observability:** Fully develop the observability stack (Prometheus/Grafana).
3. **Secrets Management:** Integrate, if relevant, AWS Secrets Manager or Parameter Store.
4.  **OCI Exploration:** Investigate adapting modules for Oracle Cloud Infrastructure, leveraging its always free resources (OKE Kubernetes Control Plane and up to 4 CPUs and 24 GB Memory for ARM compute instances).

## Benefits to Community

* **Cloud Choice:** Enables Galoy deployment on AWS.
* **Self-Sovereignty:** Allows users to run Galoy on their own AWS infrastructure.
* **Secure Foundation:** Provides secure-by-default IaC for AWS.
* **Automation:** Ensures consistent, repeatable infrastructure deployments.
* **Operational Readiness:** Includes foundational observability.
* **Strengthened Ecosystem:** Makes Galoy more accessible and operable on AWS.

## Biographical Information

I am a DevSecOps Engineer at LuizaLabs and a Systems Information student at UTFPR with deep knowledge of Kubernetes, including cluster management, application deployment, and security implementation. This expertise is ideal for configuring AWS EKS securely and efficiently for the Galoy stack. I have foundational AWS and Terraform knowledge and I am a proactive learner.

This is my third time participating in the Summer of Bitcoin program and I also participated in some other Bitcoin related programs/events like Vinteum's Bitcoin Developer Launchpad, Bitcoin++ Floripa and some classes from Chaincode labs.

I truly believe in Bitcoin as a freedom technology and I understand its importance and benefits for the whole society but I also know that Bitcoin is not as inevitable as people use to think it is and it has a lot of things that still needs to be done in order to allow Bitcoin to scale for the use of billions of people. 
Galoy's mission is compelling, and this projects comes exactly for merging the two os my career passions: infrastructure and Bitcoin.
---