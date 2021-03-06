class TaskDefinition
  def create_task_definition(options, version)
    {
      family: options[:task_definition][:name],
      container_definitions: [{
        memory: options[:task_definition][:essential_container_memory],
        port_mappings: [
          {
            host_port: 0,
            container_port: options[:essential_container_port],
            protocol: 'tcp'
          }
        ],
        essential: true,
        name: options[:essential_container_name],
        image: "lifeizhou/oche_web:#{version}",
        links: ['app']
      },
      {
        memory: options[:task_definition][:app_container_memory],
        port_mappings: [
          {
            host_port: 0,
            container_port: 8080,
            protocol: 'tcp'
          }
        ],
        essential: false,
        name: 'app',
        image: "lifeizhou/oche_app:#{version}",
        environment: [
          { name: 'ENV_NAME', value: options[:task_definition][:env_name] }
        ]
      }]
    }
  end

end