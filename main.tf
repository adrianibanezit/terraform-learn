# -------------------------
# Define el provider de AWS
# -------------------------

provider "aws" {
    region = local.region    
}

locals {
    region = "eu-west-1"
    ami = var.ubuntu_ami[local.region]
}

# ------------
# Data Source 
# ------------

data "aws_subnet" "public_subnet" {
    for_each = var.servers

    availability_zone = "${local.region}${each.value.az}"
}
data "aws_vpc" "default" {
    default = true 
}

module "ec2_servers" {
    source = "./modules/ec2-instances"
    server_port = 8080
    instance_type = "t2.micro"
    ami_id = local.ami
    servers = {
        for id_ser, data in var.servers:
            id_ser => {
                subnet_ids = data.aws_subnet.public_subnet[id_ser].id
            }
    }
}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    subnet_ids = [ for subnet in data.aws_subnet.public_subnet : subnet.id ]
    instances_ids = module.ec2_servers.instances_ids
    lb_port = 80
    server_port = 8080
}