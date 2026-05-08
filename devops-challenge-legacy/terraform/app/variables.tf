variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = "helloworld"
}

variable "name" {
  type        = string
  description = "Name of the application container"
  default     = "app"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "dev"
}

variable "container_image" {
  type        = string
  description = "The image used to start the container. Images in the Docker Hub registry available by default"
}

variable "app_container_port" {
  type        = number
  description = "Port for app container to expose"
  default     = 3000
}

variable "container_memory" {
  type        = number
  description = "The amount of RAM to allow container to use in MB"
  default     = 512
}

variable "container_memory_reservation" {
  type        = number
  description = "The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than `container_memory` if set"
  default     = 128
}

variable "container_cpu" {
  type        = number
  description = "The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/Amaz    onECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = 256
}

variable "log_driver" {
  type        = string
  description = "The log driver to use for the container. If using Fargate launch type, only supported value is awslogs"
  default     = "awslogs"
}

