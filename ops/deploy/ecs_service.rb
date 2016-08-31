require 'aws-sdk'
require 'yaml'
require_relative './task_definition'

class EcsService

  def initialize(env=:training)
    @ecs_client = Aws::ECS::Client.new
    @options = YAML.load_file('config.yml')[env]
  end

  def deploy
    register_task_definition
    if(service_exist?)
      update_service
    else
      create_service
    end
  end

  def create_service
    create_service_settings = service_settings.merge({
      service_name: @options[:service_name],
      role: @options[:ecs_service_role],
      load_balancers: [
        {
          target_group_arn: find_target_group_arn_by_name,
          container_name: @options[:essential_container_name],
          container_port: @options[:essential_container_port],
        }
      ]
    })
    @ecs_client.create_service(create_service_settings)
  end

  def update_service
    @ecs_client.update_service(service_settings.merge(service: @options[:service_name]))
  end

  def register_task_definition
    @ecs_client.register_task_definition(TaskDefinition.new.create_task_definition(@options))
  end

  private

  def find_target_group_arn_by_name
    eb2_client = Aws::ElasticLoadBalancingV2::Client.new
    resp = eb2_client.describe_target_groups({names: [@options[:target_group_name]]})
    resp.target_groups.first.target_group_arn
  end

  def service_exist?
    resp = @ecs_client.describe_services({cluster: @options[:cluster_name], services: [@options[:service_name]]})
    !resp.services.empty?
  end

  def service_settings
    {
      cluster: @options[:cluster_name],
      task_definition: @options[:task_definition][:name],
      desired_count: @options[:desired_count],
      deployment_configuration: {
        maximum_percent: @options[:maximum_percent],
        minimum_healthy_percent: @options[:minimum_healthy_percent],
      }
    }
  end

end