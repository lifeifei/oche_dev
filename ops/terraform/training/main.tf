module "oche" {
  source      = "../modules/oche"
  environment = "training"
  key_name    = "oche-dev"
  name        = "training-test"
  region      = "ap-southeast-2"
  availability_zones = "ap-southeast-2a,ap-southeast-2b"
  internal_subnets = "10.30.0.0/19,10.30.64.0/19"
  external_subnets = "10.30.32.0/20,10.30.96.0/20"
  ecs_instance_type = "t2.micro"
  ecs_instance_ebs_optimized = false
  ecs_desired_capacity = 1
  ecs_min_size = 1
}