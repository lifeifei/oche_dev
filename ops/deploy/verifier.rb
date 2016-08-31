class Verifier
  def deploy_finish?(service_detail, expected_task_definition_arn, expected_desired_count)
    expected_service_state_values = expected_service_state(expected_task_definition_arn, expected_desired_count)
    expected_service_deployment_state_values = expected_service_deployment_state(expected_task_definition_arn, expected_desired_count)
    verify_state(expected_service_state_values, service_detail) && verify_state(expected_service_deployment_state_values, service_detail.deployments.first)
  end

  def verify_state(expected_state, actual_state)
    is_state_match = true
    expected_state.keys.each do |attribute|
      actual_value = actual_state.send(attribute)
      puts "#{attribute.to_s} actual: #{actual_value}, expected: #{expected_state[attribute]}"
      is_state_match = false if actual_value != expected_state[attribute]
    end
    is_state_match
  end

  def expected_service_state(expected_task_definition_arn, expected_desired_count)
    expected_task_state(expected_task_definition_arn, expected_desired_count).merge(status: 'ACTIVE')
  end

  def expected_service_deployment_state(expected_task_definition_arn, expected_desired_count)
    expected_task_state(expected_task_definition_arn, expected_desired_count).merge(status: 'PRIMARY')
  end

  def expected_task_state(expected_task_definition_arn, expected_desired_count)
    {
      desired_count: expected_desired_count,
      running_count: expected_desired_count,
      pending_count: 0,
      task_definition: expected_task_definition_arn
    }
  end
end