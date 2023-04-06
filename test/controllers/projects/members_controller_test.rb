# frozen_string_literal: true

require 'test_helper'

module Projects
  class MembersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'should get project members listing => projects/members#index' do
      sign_in users(:john_doe)
      namespace = namespaces_user_namespaces(:john_doe_namespace)
      project = projects(:john_doe_project2)
      get namespace_project_members_path(namespace, project)
      assert_response :success
    end

    test 'should display add new member to project page' do
      sign_in users(:john_doe)
      namespace = namespaces_user_namespaces(:john_doe_namespace)
      project = projects(:john_doe_project2)
      get new_namespace_project_member_path(namespace, project)
      assert_response :success
    end

    test 'should add new member to project' do
      sign_in users(:john_doe)

      namespace = namespaces_user_namespaces(:john_doe_namespace)
      project = projects(:john_doe_project2)

      get new_namespace_project_member_path(namespace, project)
      created_by_user = users(:john_doe)
      user = users(:jane_doe)

      assert_difference('Members::ProjectMember.count') do
        post namespace_project_members_path, params: { member: { user_id: user.id,
                                                                 namespace_id: namespace.id,
                                                                 created_by_id: created_by_user.id,
                                                                 type: 'ProjectMember',
                                                                 access_level: Member::AccessLevel::OWNER } }
      end

      assert_redirected_to namespace_project_members_path(namespace, project)
    end

    test 'should delete a member from the project' do
      sign_in users(:john_doe)

      namespace = namespaces_user_namespaces(:john_doe_namespace)
      project = projects(:john_doe_project2)

      get new_namespace_project_member_path(namespace, project)
      project_member = members_project_members(:project_two_member_james_doe)

      assert_difference('Members::ProjectMember.count', -1) do
        delete namespace_project_member_path(namespace, project, project_member)
      end

      assert_redirected_to namespace_project_members_path(namespace, project)
    end
  end
end