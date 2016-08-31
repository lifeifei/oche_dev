require 'aws-sdk'
require 'yaml'
require_relative './task_definition'
require_relative './verifier'
require_relative './deployment_in_process'
require 'retriable'
require 'rest-client'

class EcsService

  attr_accessor :options

  WAIT_COUNT = 600
  def initialize(env, version)
    @ecs_client = Aws::ECS::Client.new
    @env = env.to_sym
    @options = YAML.load_file('config.yml')[@env]
    @version = version
  end

  def deploy
    puts "========== starting to deploy version #{@version} to environment: #{@env}"
    task_definition_arn = register_task_definition
    puts "========== new task definition arn: #{task_definition_arn}"
    get_service.nil? ? create_service : update_service
    puts '========== verifying deployment'
    Retriable.retriable on: DeploymentInProcess, tries: WAIT_COUNT, base_interval: 1, multiplier: 1 do
      raise DeploymentInProcess unless deploy_finish?(task_definition_arn)
    end
    puts "========== finished to deploy version #{@version} to environment: #{@env}"
  end

  def verify_deployed
    resp = elb_client.describe_load_balancers(names: [@options[:alb_name]])
    dns = resp.load_balancers.first.dns_name
    resp = RestClient.get("http://#{dns}/app/oche/result")
    puts JSON.parse(resp.body).inspect
    puts "========== deployment is successful"
  end

  def deploy_finish?(task_definition_arn)
    service_detail = get_service
    verifier.deploy_finish?(service_detail, task_definition_arn, @options[:desired_count])
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
    resp = @ecs_client.register_task_definition(TaskDefinition.new.create_task_definition(@options))
    resp.task_definition.task_definition_arn
  end

  private

  def find_target_group_arn_by_name
    resp = eb2_client.describe_target_groups({names: [@options[:target_group_name]]})
    resp.target_groups.first.target_group_arn
  end

  def get_service
    resp = @ecs_client.describe_services({cluster: @options[:cluster_name], services: [@options[:service_name]]})
    resp.services.empty? ? nil : resp.services[0]
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

  def verifier
    @verifier ||= Verifier.new
  end

  def elb_client
    @elb_client ||= Aws::ElasticLoadBalancingV2::Client.new
  end

end