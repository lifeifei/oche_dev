module "stack" {
  source      = "github.com/lifeifei/stack"
  environment = "test"
  key_name    = "lifei-dev"
  name        = "lifei"
  region      = "ap-southeast-2"
  availability_zones = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
  ecs_instance_type = "t2.micro"
  ecs_instance_ebs_optimized = false
  ecs_desired_capacity = 1
  ecs_min_size = 1
  target_group_arns = "${module.service_alb.target_group_arn}"
}