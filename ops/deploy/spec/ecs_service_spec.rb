require_relative '../ecs_service'
describe EcsService do

  describe '#deploy_finish?' do
    let(:task_definition_arn) { 'arn2223'}
    let(:desired_count) {1}
    let(:ecs_service) {EcsService.new('training', 1).tap {|service| service.options = {desired_count: desired_count}}}

    context 'when service state does not match' do
      it 'should return false' do
        expect(ecs_service).to receive(:get_service).and_return(double(status: 'PENDING', desired_count: 1,
              running_count: 1, pending_count: 0, task_definition: task_definition_arn))
        expect(ecs_service.deploy_finish?(task_definition_arn)).to eq(false)
      end

      context 'when service state does match' do
        context 'when service deployment state does match' do
          it 'should return true' do
            actual_deployment_values = double(status: 'PRIMARY', desired_count: desired_count,
              running_count: desired_count, pending_count: 0, task_definition: task_definition_arn)
            expect(ecs_service).to receive(:get_service).and_return(double(status: 'ACTIVE', desired_count: desired_count,
                  running_count: desired_count, pending_count: 0, task_definition: task_definition_arn, deployments: [actual_deployment_values]))
            expect(ecs_service.deploy_finish?(task_definition_arn)).to eq(true)
          end

        end

        context 'when service deployment state does not match' do
          it 'should return false' do
            actual_deployment_values = double(status: 'PRIMARY', desired_count: desired_count,
              running_count: desired_count, pending_count: 0, task_definition: '111')
            expect(ecs_service).to receive(:get_service).and_return(double(status: 'ACTIVE', desired_count: desired_count,
                  running_count: desired_count, pending_count: 0, task_definition: task_definition_arn, deployments: [actual_deployment_values]))
            expect(ecs_service.deploy_finish?(task_definition_arn)).to eq(false)
          end
        end
      end


    end


  end


end