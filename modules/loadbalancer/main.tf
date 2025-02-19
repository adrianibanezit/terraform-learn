# ----------------------------------------
# Load Balancer público con dos instancias
# ----------------------------------------

resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "terraformers-alb"
    security_groups = [ aws_security_group.alb_sg.id ]
    subnets = var.subnet_ids
}

# ------------------------------------
# Security group para el Load Balancer
# ------------------------------------

resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    description = "Allow HTTP inbound traffic"
    ingress {
        from_port = var.lb_port
        to_port = var.lb_port
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]   
        description = "Allow HTTP inbound traffic to the servers"
        }
    egress {
        from_port = var.server_port
        to_port = var.server_port
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
    port = var.lb_port
    protocol = "HTTP"

    health_check {
        enabled = true
        matcher = 200
        path = "/"
        port = var.server_port
        protocol = "HTTP"
    }
}

# ----------------------------------
# Attachment para el servidor 1 y 2
# ----------------------------------
resource "aws_lb_target_group_attachment" "server" {
    for_each = var.instances_ids
    target_group_arn = aws_lb_target_group.this.arn
    target_id = each.value
    port = var.server_port
}

# ------------------------
# Listener para nuestro LB
# ------------------------

resource "aws_lb_listener" "this" {
    load_balancer_arn = aws_lb.alb.arn
    port = var.lb_port
    protocol = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.this.arn
        type = "forward"
    }
}