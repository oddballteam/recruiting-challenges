# Define the application container
module "app_container" {
  source                       = "../modules/ecs_container_definition"
  container_name               = var.name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  essential                    = true
  port_mappings = [
    {
      containerPort = var.app_container_port
      hostPort      = var.app_container_port
      protocol      = "tcp"
    }
  ]
  log_configuration = {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = var.name
    }
    secretOptions = null

  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.namespace}/app"
  retention_in_days = 30
}

resource "aws_ecs_cluster" "default" {
  name = "${local.prefix}-ecs-cluster"
}

# Create the ECS service task definition
module "ecs_service" {
  source                    = "../modules/ecs_service"
  prefix                    = local.prefix
  vpc_id                    = data.aws_vpc.default.id
  ecs_cluster_arn           = aws_ecs_cluster.default.arn
  container_definition_json = jsonencode([module.app_container.json_map])
  subnet_ids                = data.aws_subnet_ids.us-east.ids
  alb_security_group        = module.alb.security_group_id
  launch_type               = "FARGATE"
  desired_count             = 1
  assign_public_ip          = true
  ecs_load_balancers = [
    {
      container_name   = var.name
      container_port   = var.app_container_port
      elb_name         = null
      target_group_arn = module.alb.default_target_group_arn
    }
  ]
}
