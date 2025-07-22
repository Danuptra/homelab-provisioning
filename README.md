🏠 Homelab Provisioning (Terraform + Ansible + K3s )
===================================================================

This project provisions a self-hosted Kubernetes (**K3s**) cluster using:

* **Terraform** with **Libvirt** to provision Virtual Machines (VMs)
* **Ansible** to automate system setup and Kubernetes installation


📂 Project Structure
--------------------

```text
homelab-provisioning/
├── README.md
├── ansible-homelab-provisioning/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.yml
│   ├── node-token
│   ├── playbook.yml
│   └── roles/
│       ├── common-setup/
│       ├── cluster-master/
│       └── cluster-worker/
├── ansible.cfg
├── cloud-init/
│   ├── network-config-master.yml
│   ├── network-config-worker.yml
│   └── user-data.yml
├── main.tf
├── modules/
│   └── instances/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── variables.tf
└── terraform.tfstate*
```

🚀 Provisioning Workflow
------------------------

### 1️⃣ Provision VMs with Terraform

```bash
terraform init
terraform apply
```

### 2️⃣ Install K3s with Ansible  

```bash
ansible-playbook playbook.yml
```
- Installs common prerequisite packages.
- Installs K3s on the master node.
- Creates the K3s cluster and joins worker nodes using the node-token.

---
Made with ❤️ by [Danuptra](https://github.com/Danuptra)
