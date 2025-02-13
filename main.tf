# -------------------------
# Define el provider de AWS
# -------------------------

provider "aws" {
    region = "eu-west-1"    
}

# ------------
# Data Source 
# ------------

data "aws_subnet" "az_a" {
    availability_zone = "eu-west-1a"
}

data "aws_subnet" "az_b" {
    availability_zone = "eu-west-1b"
}

data "aws_vpc" "default" {
    default = true 
}

# ----------------------------------------
# Define las instancias EC2 con AMI Ubuntu
# ----------------------------------------
resource "aws_instance" "server_1" {
    ami = "ami-03fd334507439f4d1"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.az_a.id
    vpc_security_group_ids = [ aws_security_group.my_sg.id ]
    tags = {
        Name = "server_1"
        Environment = "lab"
    }

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, Terraformers soy el servidor 1!" > index.html
        nohup busybox httpd -f -p 8080 -h . &
        EOF
}

resource "aws_instance" "server_2" {
    ami = "ami-03fd334507439f4d1"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.az_b.id
    vpc_security_group_ids = [ aws_security_group.my_sg.id ]
    tags = {
        Name = "server_2"
        Environment = "lab"
    }

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, Terraformers soy el servidor 2!" > index.html
        nohup busybox httpd -f -p 8080 -h . &
        EOF
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso al puerto 8080
# ------------------------------------------------------

resource "aws_security_group" "my_sg" {
    name = "my_sg"
    vpc_id = data.aws_vpc.default.id
    description = "Access to 8080"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [ aws_security_group.alb_sg.id ]
}
    tags = {
        Environment = "lab"
    }
}

# ----------------------------------------
# Load Balancer público con dos instancias
# ----------------------------------------

resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraformers-alb"
    security_groups = [ aws_security_group.alb_sg.id ]
    subnets = [ data.aws_subnet.az_a.id, data.aws_subnet.az_b.id ]
}

# ------------------------------------
# Security group para el Load Balancer
# ------------------------------------

resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    vpc_id = data.aws_vpc.default.id
    description = "Allow HTTP inbound traffic"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]   
        description = "Allow HTTP inbound traffic to the servers"
        }
    egress {
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP outbound traffic to the servers"
        }
}

# ----------------------------------
# Target Group para el Load Balancer
# ----------------------------------

resource "aws_lb_target_group" "this" {
    name = "terraform-alb-target-group"
    port = 80
    vpc_id = data.aws_vpc.default.id
    protocol = "HTTP"

    health_check {
        enabled = true
        matcher = 200
        path = "/"
        port = "8080"
        protocol = "HTTP"
    }
}

# ----------------------------------
# Attachment para el servidor 1 y 2
# ----------------------------------
resource "aws_lb_target_group_attachment" "server_1" {
    target_group_arn = aws_lb_target_group.this.arn
    target_id = aws_instance.server_1.id
    port = 8080
}

resource "aws_lb_target_group_attachment" "server_2" {
    target_group_arn = aws_lb_target_group.this.arn
    target_id = aws_instance.server_2.id
    port = 8080
}

# ------------------------
# Listener para nuestro LB
# ------------------------

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.this.arn
        type = "forward"
    }
}