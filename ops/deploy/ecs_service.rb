require 'aws-sdk'

class EcsService

  def initialize
    @ecs_client = Aws::ECS::Client.new
  end

  def attach_target_group
    eb2_client = Aws::ElasticLoadBalancingV2::Client.new
    resp = eb2_client.describe_target_groups({names: ['lifei-alb-tg']})
    target_group_arn = resp.target_groups.first.target_group_arn

    as_client = Aws::AutoScaling::Client.new
    resp = as_client.attach_load_balancer_target_groups({
      auto_scaling_group_name: 'lifei',
      target_group_arns: [target_group_arn]
    })
  end

  def create_service
    @ecs_client.create_service({
      cluster: 'lifei',
      service_name: 'lifei-service', # required
      task_definition: 'lifei-task', # required
      load_balancers: [
        {
          target_group_arn:'arn:aws:elasticloadbalancing:ap-southeast-2:412873404789:targetgroup/lifei-alb-tg/a89cd6c2b68ea499',
          # load_balancer_name: "lifei-alb",
          container_name: 'nginx',
          container_port: 80,
        },
      ],
      desired_count: 1, # required
      role: 'ecs-role-lifei-test',
      deployment_configuration: {
        maximum_percent: 100,
        minimum_healthy_percent: 0,
      }
    })
  end

  # def create_service
  #   @ecs_client.create_service({
  #                                cluster: 'lifei',
  #                                service_name: 'lifei-service1', # required
  #                                task_definition: 'lifei-task', # required
  #                                load_balancers: [
  #                                  {
  #                                    load_balancer_name: "lifei-alb",
  #                                    container_name: 'nginx',
  #                                    container_port: 80,
  #                                  },
  #                                ],
  #                                desired_count: 1, # required
  #                                role: 'ecs-role-lifei-test',
  #                                deployment_configuration: {
  #                                  maximum_percent: 0,
  #                                  minimum_healthy_percent: 1,
  #                                }
  #                              })
  # end

  def update_service
    @ecs_client.update_service({
      cluster: "lifei",
      service: "lifei-service", # required
      desired_count: 1,
      task_definition: "lifei-task",
      deployment_configuration: {
        maximum_percent: 100,
        minimum_healthy_percent: 0,
      }
    })
  end

  def create_task_definition
    @ecs_client.register_task_definition({
      family: 'lifei-task',
      container_definitions: [{
        memory: 100,
        port_mappings: [
          {
            host_port: 0,
            container_port: 80,
            protocol: "tcp"
          }
        ],
        essential: true,
        name: 'nginx',
        image: 'lifeizhou/oche_web',
        links: ['app']
      },
      {
        memory: 300,
        port_mappings: [
          {
            host_port: 0,
            container_port: 8080,
            protocol: 'tcp'
          }
        ],
        essential: false,
        name: 'app',
        image: 'lifeizhou/oche_app'
      }
      ]
    })
  end

end