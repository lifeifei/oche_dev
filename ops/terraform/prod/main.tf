module "oche" {
  source      = "../modules/oche"
  environment = "prod"
  key_name    = "lifei-dev"
  name        = "oche-prod"
  region      = "ap-southeast-2"
  availability_zones = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
  internal_subnets = "10.30.0.0/19,10.30.64.0/19,10.30.128.0/19"
  external_subnets = "10.30.32.0/20,10.30.96.0/20,10.30.160.0/20"
  ecs_instance_type = "m4.large"
  ecs_desired_capacity = 4
  ecs_min_size = 2
}