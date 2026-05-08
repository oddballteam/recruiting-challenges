resource "aws_security_group" "default" {
  description = "Controls access to the ALB (HTTP/HTTPS)"
  vpc_id      = var.vpc_id
  name        = "${var.load_balancer_name}-sg"
  tags        = var.tags
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  cidr_blocks       = var.http_ingress_cidr_blocks
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "https_ingress" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = "tcp"
  cidr_blocks       = var.https_ingress_cidr_blocks
  security_group_id = aws_security_group.default.id
}

module "access_logs" {
  source        = "cloudposse/lb-s3-bucket/aws"
  version       = "0.14.1"
  attributes    = compact(concat(var.attributes, ["alb", "access", "logs"]))
  force_destroy = var.alb_access_logs_s3_bucket_force_destroy
}

resource "aws_lb" "default" {
  #bridgecrew:skip=BC_AWS_NETWORKING_41 - Skipping Ensure that ALB Drops HTTP Headers
  #bridgecrew:skip=BC_AWS_LOGGING_22 - Skipping Ensure ELBv2 has Access Logging Enabled
  name               = var.load_balancer_name
  tags               = var.tags
  internal           = false
  load_balancer_type = "application"

  security_groups = compact(
    concat(var.security_group_ids, [aws_security_group.default.id]),
  )

  subnets                          = var.subnet_ids
  enable_cross_zone_load_balancing = true
  ip_address_type                  = var.ip_address_type

  access_logs {
    bucket  = module.access_logs.bucket_id
    enabled = true
  }
}

resource "aws_lb_target_group" "default" {
  name                 = "${var.load_balancer_name}-tg"
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  target_type          = var.target_group_target_type
  deregistration_delay = 15

  health_check {
    protocol = var.target_group_protocol
    path     = var.health_check_path
    port     = var.health_check_port
    timeout  = var.health_check_timeout
    matcher  = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    var.target_group_additional_tags
  )
}

resource "aws_lb_listener" "http_forward" {
  #bridgecrew:skip=BC_AWS_GENERAL_43 - Skipping Ensure that load balancer is using TLS 1.2.
  #bridgecrew:skip=BC_AWS_NETWORKING_29 - Skipping Ensure ALB Protocol is HTTPS
  load_balancer_arn = aws_lb.default.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.default.arn
    type             = "forward"
  }
}
