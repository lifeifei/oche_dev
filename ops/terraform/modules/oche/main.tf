variable "name" {
  description = "the name of your stack"
}

variable "environment" {
  description = "the name of your environment"
}

variable "key_name" {
  description = "the name of the ssh key to use"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "ap-southeast-2"
}

variable "cidr" {
  description = "the CIDR block to provision for the VPC, if set to something other than the default, both internal_subnets and external_subnets have to be defined as well"
  default     = "10.30.0.0/16"
}

variable "internal_subnets" {
  description = "a comma-separated list of CIDRs for internal subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = "10.30.0.0/19,10.30.64.0/19,10.30.128.0/19"
}

variable "external_subnets" {
  description = "a comma-separated list of CIDRs for external subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = "10.30.32.0/20,10.30.96.0/20,10.30.160.0/20"
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both internal_subnets and external_subnets have to be defined as well"
  default     = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
}

variable "ecs_instance_type" {
  description = "the instance type to use for your default ecs cluster"
  default     = "m4.large"
}

variable "ecs_instance_ebs_optimized" {
  description = "use EBS - not all instance types support EBS"
  default     = false
}

variable "ecs_min_size" {
  description = "the minimum number of instances to use in the default ecs cluster"
  default = 3
}

variable "ecs_max_size" {
  description = "the maximum number of instances to use in the default ecs cluster"
  default     = 10
}

variable "ecs_desired_capacity" {
  description = "the desired number of instances to use in the default ecs cluster"
  default     = 3
}

module "stack" {
  source      = "github.com/lifeifei/stack"
  environment = "${var.environment}"
  key_name    = "${var.key_name}"
  name        = "${var.name}"
  region      = "${var.region}"
  availability_zones = "${var.availability_zones}"
  internal_subnets = "${var.internal_subnets}"
  external_subnets = "${var.external_subnets}"
  ecs_instance_type = "${var.ecs_instance_type}"
  ecs_instance_ebs_optimized = "${var.ecs_instance_ebs_optimized}"
  ecs_desired_capacity = "${var.ecs_desired_capacity}"
  ecs_min_size = "${var.ecs_min_size}"
  target_group_arns = "${module.service_alb.target_group_arn}"
}

module "service_alb" {
  source          = "github.com/lifeifei/stack//alb"
  name            = "${var.name}-alb"
  target_group_name = "${var.name}-alb-tg"
  port            = 80
  protocol        = "HTTP"
  is_internal     = false
  environment     = "${module.stack.environment}"
  security_groups = "${module.stack.external_elb}"
  subnet_ids      = "${module.stack.external_subnets}"
  log_bucket      = "${module.stack.log_bucket_id}"
  vpc_id          = "${module.stack.vpc_id}"
  log_prefix      = "${var.name}-alb_log"
}