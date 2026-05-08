# Create an application load balancer (ALB) that the app will use
module "alb" {
  source                                  = "../modules/alb"
  vpc_id                                  = data.aws_vpc.default.id
  subnet_ids                              = data.aws_subnet_ids.us-east.ids
  load_balancer_name                      = "${local.prefix}-alb"
  attributes                              = [local.prefix]
  alb_access_logs_s3_bucket_force_destroy = true
}

