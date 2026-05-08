# Pull the VPC and subnets that ECS will need
data "aws_vpc" "default" {
  filter {
    name   = "is-default"
    values = [true]
  }
}

data "aws_subnet_ids" "us-east" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}
