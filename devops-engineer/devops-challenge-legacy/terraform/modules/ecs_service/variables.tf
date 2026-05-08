variable "prefix" {
  type        = string
  description = "The ID to use for names, typically {namespace}-{name}-{environment}"
}

variable "tags" {
  type        = map
  description = "Tags to pass to resources"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where resources are created"
}

variable "alb_security_group" {
  type        = string
  description = "Security group of the ALB"
  default     = ""
}

variable "ecs_cluster_arn" {
  type        = string
  description = "The ARN of the ECS cluster where service will be provisioned"
}

variable "ecs_load_balancers" {
  type = list(object({
    container_name   = string
    container_port   = number
    elb_name         = string
    target_group_arn = string
  }))
  description = "A list of load balancer config objects for the ECS service; see [ecs_service#load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#load_balancer) docs"
  default     = []
}

variable "container_definition_json" {
  type        = string
  description = <<-EOT
    A string containing a JSON-encoded array of container definitions
    (`"[{ "name": "container1", ... }, { "name": "container2", ... }]"`).
    See [API_ContainerDefinition](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html),
    [cloudposse/terraform-aws-ecs-container-definition](https://github.com/cloudposse/terraform-aws-ecs-container-definition), or
    [ecs_task_definition#container_definitions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#container_definitions)
    EOT
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used in Service `network_configuration` if `var.network_mode = \"awsvpc\"`"
  default     = null
}

variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "FARGATE"
}

variable "platform_version" {
  type        = string
  default     = "LATEST"
  description = <<-EOT
    The platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`.
    More information about Fargate platform versions can be found in the AWS ECS User Guide.
    EOT
}

variable "scheduling_strategy" {
  type        = string
  default     = "REPLICA"
  description = <<-EOT
    The scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`.
    Note that Fargate tasks do not support the DAEMON scheduling strategy.
    EOT
}

variable "network_mode" {
  type        = string
  description = "The network mode to use for the task. This is required to be `awsvpc` for `FARGATE` `launch_type` or `null` for `EC2` `launch_type`"
  default     = "awsvpc"
}

variable "task_cpu" {
  type        = number
  description = "The number of CPU units used by the task. If using `FARGATE` launch type `task_cpu` must match [supported memory values](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "The amount of memory (in MiB) used by the task. If using Fargate launch type `task_memory` must match [supported cpu value](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size)"
  default     = 512
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "deployment_maximum_percent" {
  type        = number
  description = "The upper limit of the number of tasks (as a percentage of `desired_count`) that can be running in a service during a deployment"
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "The lower limit (as a percentage of `desired_count`) of the number of tasks that must remain running and healthy in a service during a deployment"
  default     = 100
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers"
  default     = 0
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are `true` or `false`. Default `false`"
  default     = false
}

variable "enable_ecs_managed_tags" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  default     = false
}

variable "wait_for_steady_state" {
  type        = bool
  description = "If true, it will wait for the service to reach a steady state (like aws ecs wait services-stable) before continuing"
  default     = false
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service."
  default     = false
}

