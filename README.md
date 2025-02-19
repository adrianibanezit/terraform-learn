# Hello Terraform

[![Terraform](https://img.shields.io/badge/Terraform+-purple?style=for-the-badge&logo=terraform&logoColor=white&labelColor=101010)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonwebservices&logoColor=white&labelColor=101010)](https://aws.amazon.com/es/)

## Proyecto con Terraform y AWS

Este es un pequeño projecto de una infraestructura en AWS.

![HOME](https://cdn.plainconcepts.com/wp-content/uploads/2022/10/terraform-que-es.png)

## 🚀 Estructura del proyecto

Dentro de mi proyecto Terraform, verás las siguientes carpetas y archivos:

```text
terraform-learn/
├── README.md
├── main.tf
├── modules
│   ├── ec2-instances
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── loadbalancer
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf

```