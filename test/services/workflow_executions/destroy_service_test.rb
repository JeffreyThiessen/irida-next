# frozen_string_literal: true

require 'test_helper'

module WorkflowExecutions
  class DestroyServiceTest < ActiveSupport::TestCase
    def setup
      @user = users(:john_doe)
      @user_destroyable = users(:janitor_doe)
    end

    test 'should not destroy a workflow execution if the user is not the submitter' do
      user = users(:jane_doe)
      workflow_execution = workflow_executions(:irida_next_example_completed)
      assert workflow_execution.completed?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        exception = assert_raises(ActionPolicy::Unauthorized) do
          WorkflowExecutions::DestroyService.new(workflow_execution, user).execute
        end

        assert_equal WorkflowExecutionPolicy, exception.policy
        assert_equal :destroy?, exception.rule
        assert exception.result.reasons.is_a?(::ActionPolicy::Policy::FailureReasons)
        assert_equal I18n.t(:'action_policy.policy.workflow_execution.destroy?',
                            namespace_type: workflow_execution.namespace.type,
                            name: workflow_execution.namespace.name),
                     exception.result.message
      end
    end

    test 'should not destroy a prepared workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_prepared)
      assert workflow_execution.prepared?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should not destroy a submitted workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_submitted)
      assert workflow_execution.submitted?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should destroy a completed workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_completed_DELETE)
      assert workflow_execution.completed?
      assert workflow_execution.cleaned?

      assert_difference -> { WorkflowExecution.count } => -1,
                        -> { SamplesWorkflowExecution.count } => -1,
                        -> { Sample.count } => 0 do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user_destroyable).execute
      end
    end

    test 'should not destroy an uncleaned completed workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_completed_unclean)
      assert workflow_execution.completed?
      assert_not workflow_execution.cleaned?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should destroy an errored workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_error_DELETE)
      assert workflow_execution.error?
      assert workflow_execution.cleaned?

      assert_difference -> { WorkflowExecution.count } => -1,
                        -> { SamplesWorkflowExecution.count } => -1,
                        -> { Sample.count } => 0 do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user_destroyable).execute
      end
    end

    test 'should not destroy an uncleaned error workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_error_unclean)
      assert workflow_execution.error?
      assert_not workflow_execution.cleaned?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should not destroy a canceling workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_canceling)
      assert workflow_execution.canceling?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should destroy a canceled workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_canceled_DELETE)
      assert workflow_execution.canceled?
      assert workflow_execution.cleaned?

      assert_difference -> { WorkflowExecution.count } => -1,
                        -> { SamplesWorkflowExecution.count } => -1,
                        -> { Sample.count } => 0 do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user_destroyable).execute
      end
    end

    test 'should not destroy an uncleaned canceled workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_canceled_unclean)
      assert workflow_execution.canceled?
      assert_not workflow_execution.cleaned?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should not destroy a running workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_running)
      assert workflow_execution.running?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end

    test 'should not destroy a new workflow execution' do
      workflow_execution = workflow_executions(:irida_next_example_new)
      assert workflow_execution.initial?

      assert_no_difference -> { WorkflowExecution.count },
                           -> { SamplesWorkflowExecution.count } do
        WorkflowExecutions::DestroyService.new(workflow_execution, @user).execute
      end
    end
  end
end
