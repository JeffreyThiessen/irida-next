# frozen_string_literal: true

require 'test_helper'

module Projects
  class DestroyServiceTest < ActiveSupport::TestCase
    def setup
      @user = users(:john_doe)
      @project = projects(:john_doe_project2)
    end

    test 'delete project with with correct permissions' do
      assert_difference -> { Project.count } => -1, -> { Member.count } => -4 do
        Projects::DestroyService.new(@project, @user).execute
      end
    end

    test 'delete project with incorrect permissions' do
      user = users(:joan_doe)

      assert_raises(ActionPolicy::Unauthorized) { Projects::DestroyService.new(@project, user).execute }

      exception = assert_raises(ActionPolicy::Unauthorized) do
        Projects::DestroyService.new(@project, user).execute
      end

      assert_equal ProjectPolicy, exception.policy
      assert_equal :allowed_to_destroy?, exception.rule
      assert exception.result.reasons.is_a?(::ActionPolicy::Policy::FailureReasons)
    end

    test 'valid authorization to destroy project' do
      assert_authorized_to(:allowed_to_destroy?, @project,
                           with: ProjectPolicy,
                           context: { user: @user }) do
        Projects::DestroyService.new(
          @project, @user
        ).execute
      end
    end
  end
end
