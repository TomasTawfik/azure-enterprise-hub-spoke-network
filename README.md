# 🌐 Azure Enterprise Hub-and-Spoke Network Architecture

> An enterprise-grade Azure networking solution implementing the Hub-and-Spoke topology with centralized security, traffic management, and Infrastructure as Code (IaC).

---

## 📖 Project Overview

This project demonstrates the design and deployment of an **Enterprise Hub-and-Spoke Network Architecture** on Microsoft Azure using **ARM Templates**.

The architecture follows Microsoft Azure networking best practices by centralizing shared network services inside a **Hub Virtual Network**, while isolating application workloads into dedicated **Spoke Virtual Networks**.

The solution integrates Azure Firewall, Virtual Network Peering, User Defined Routes (UDRs), Network Security Groups (NSGs), NAT Gateway, Azure Load Balancer, and a multi-tier application architecture to provide secure, scalable, and highly available networking.

---

# 🎯 Project Objectives

* Design an enterprise-grade Hub-and-Spoke network topology.
* Centralize network security using Azure Firewall.
* Isolate Web, Application, and Database tiers.
* Secure traffic using Network Security Groups (NSGs).
* Route traffic through Azure Firewall using User Defined Routes (UDRs).
* Provide secure outbound Internet access through Azure NAT Gateway.
* Improve availability using Azure Load Balancer.
* Automate infrastructure deployment using ARM Templates.

---

# 🏗 Solution Architecture

> **Architecture Diagram**

<p align="center">

**(Insert Architecture Diagram Here)**

</p>

---

# 🌐 Network Topology

```text
Internet
    │
    ▼
Azure Firewall
    │
    ▼
Hub Virtual Network
    │
────┼────────────────────────────
    │
    ▼
Spoke Virtual Network
    │
 ┌──┴───────────────┐
 │                  │
 ▼                  ▼
Web Tier        App Tier
      │
      ▼
 Database Tier
```

---

# 🔒 Security Architecture

The solution follows a layered security model.

### Azure Firewall

* Centralized traffic inspection
* Network Rule Collections
* Secure traffic filtering

### Network Security Groups

* Web Tier Security
* Application Tier Security
* Database Tier Security

### User Defined Routes

* Forced routing through Azure Firewall
* Controlled network communication

### Network Segmentation

* Isolated application tiers
* Reduced attack surface
* Improved network security

---

# ☁ Azure Services Used

| Azure Service           | Purpose                        |
| ----------------------- | ------------------------------ |
| Azure Virtual Network   | Network Segmentation           |
| Hub Virtual Network     | Shared Network Services        |
| Spoke Virtual Network   | Workload Isolation             |
| Azure Firewall          | Centralized Security           |
| Network Security Groups | Traffic Filtering              |
| User Defined Routes     | Traffic Routing                |
| Azure NAT Gateway       | Outbound Internet Connectivity |
| Azure Load Balancer     | Traffic Distribution           |
| VNet Peering            | Hub-to-Spoke Connectivity      |
| ARM Templates           | Infrastructure as Code         |

---

# 🚀 Traffic Flow

1. Client traffic enters the Azure environment.
2. Azure Firewall inspects all incoming traffic.
3. User Defined Routes direct traffic through the Hub network.
4. Azure Load Balancer distributes traffic to backend resources.
5. Requests reach the appropriate application tier.
6. Application components communicate securely between Web, App, and Database tiers.
7. Outbound traffic exits through Azure NAT Gateway.

---

# ✨ Key Features

* Enterprise Hub-and-Spoke Architecture
* Azure Firewall Integration
* Multi-Tier Network Design
* Network Security Groups
* User Defined Routes (UDRs)
* Azure NAT Gateway
* Azure Load Balancer
* Infrastructure as Code (ARM Templates)
* High Availability
* Scalable Network Architecture

---

# 📂 Repository Structure

```text
Azure-Enterprise-Hub-Spoke-Network/

├── ARM/
│   ├── template.json
│   └── parameters.json
│
├── Bicep/
│
├── Architecture/
│   └── Architecture-Diagram.png
│
├── Screenshots/
│
├── Demo/
│   └── Demo-Link.txt
│
└── README.md
```

---

# 📸 Screenshots

Add screenshots of:

* Azure Resource Group
* Hub Virtual Network
* Spoke Virtual Network
* Azure Firewall
* Route Tables
* Azure Load Balancer
* Network Security Groups
* Azure Portal Overview

---

# 🎥 Demo Video

The complete deployment walkthrough is available below:

**Google Drive:** *(Paste your demo video link here)*

---

# 🛠 Technologies

* Microsoft Azure
* Azure Virtual Network (VNet)
* Hub-and-Spoke Architecture
* Azure Firewall
* Network Security Groups (NSGs)
* User Defined Routes (UDRs)
* Azure NAT Gateway
* Azure Load Balancer
* ARM Templates

---

# 🚀 Future Improvements

* Azure Bastion
* Azure Monitor
* Azure Key Vault
* Private Endpoints
* Microsoft Defender for Cloud
* GitHub Actions CI/CD

---

# 👨‍💻 Author

**Mostafa Alfaz**

Azure Cloud Engineer

GitHub: *(Your GitHub Profile)*

LinkedIn: *(Your LinkedIn Profile)*

---

⭐ If you found this project useful, consider giving it a star.
