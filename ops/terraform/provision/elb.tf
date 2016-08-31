variable "task_name" {
  description = "ECS task name"
}


variable "dns_name" {
  description = "The DNS name to use, e.g nginx"
  default = ""
}

module "lifeielb" {
  source          = "github.com/lifeifei/stack//elb"
  name            = "${var.task_name}"
  port            = 80
  protocol        = "HTTP"
  environment     = "${module.stack.environment}"
  security_groups = "${module.stack.internal_elb}"
  healthcheck     = "/"
  subnet_ids      = "${module.stack.internal_subnets}"
  log_bucket      = "${module.stack.log_bucket_id}"
  zone_id         = "${module.stack.zone_id}"
  dns_name        = "${coalesce(var.dns_name, var.task_name)}"
}

/**
 * Outputs.
 */

// The name of the ELB
output "name" {
  value = "${module.lifeielb.name}"
}

// The DNS name of the ELB
output "dns" {
  value = "${module.lifeielb.dns}"
}

// The id of the ELB
output "elb" {
  value = "${module.lifeielb.id}"
}

// The zone id of the ELB
output "zone_id" {
  value = "${module.lifeielb.zone_id}"
}

// FQDN built using the zone domain and name
output "fqdn" {
  value = "${module.lifeielb.fqdn}"
}