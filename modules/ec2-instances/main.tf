// Main for EC2 instances module

# ----------------------------------------
# Define las instancias EC2 con AMI Ubuntu
# ----------------------------------------
resource "aws_instance" "server" {
    for_each = var.servers
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = each.value.subnet_id
    vpc_security_group_ids = [ aws_security_group.my_sg.id ]
    tags = {
        Name = each.value.name
        Environment = "lab"
    }

    user_data = <<-EOF
        #!/bin/bash
        echo "Hello, Terraformers soy el ${each.value.name}!" > index.html
        nohup busybox httpd -f -p ${var.server_port} -h . &
        EOF
}

# ------------------------------------------------------
# Define un grupo de seguridad con acceso al puerto 8080
# ------------------------------------------------------

resource "aws_security_group" "my_sg" {
    name = "my_sg"
    description = "Access to 8080"
    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
}
    tags = {
        Environment = "lab"
    }
}