variable "alb_name" {
  description = "alb name"
}


variable "alb_target_group_name" {
  description = "alb target group name"
}

module "service_alb" {
  source          = "github.com/lifeifei/stack//alb"
  name            = "${var.alb_name}"
  target_group_name = "${var.alb_target_group_name}"
  port            = 80
  protocol        = "HTTP"
  is_internal     = false
  environment     = "${module.stack.environment}"
  security_groups = "${module.stack.external_elb}"
  subnet_ids      = "${module.stack.external_subnets}"
  log_bucket      = "${module.stack.log_bucket_id}"
  vpc_id          = "${module.stack.vpc_id}"
  log_prefix      = "${var.alb_name}_log"
}

