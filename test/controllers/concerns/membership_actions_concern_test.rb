# frozen_string_literal: true

require 'test_helper'

class MembershipActionsConcernTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'group members index' do
    sign_in users(:john_doe)

    group = groups(:group_one)
    get members_path(group)

    assert_response :success
    assert_equal 1, group.group_members.count
  end

  test 'group members new' do
    sign_in users(:john_doe)

    group = groups(:group_one)
    get new_member_path(group)

    assert_response :success
    assert_equal 1, group.group_members.count
  end

  test 'group members create' do
    sign_in users(:john_doe)

    group = groups(:group_one)
    get members_path(group)
    user = users(:john_doe)

    post members_path, params: { member: { user_id: user.id,
                                           namespace_id: group.id,
                                           created_by_id: user.id,
                                           type: 'GroupMember',
                                           access_level: Member::AccessLevel::OWNER } }

    assert_redirected_to members_path(group)
    assert_equal 2, group.group_members.count
  end

  test 'group members destroy' do
    sign_in users(:john_doe)

    group = groups(:group_one)
    get members_path(group)
    group_member = members_group_members(:group_one_member_james_doe)

    delete member_path(member_id: group_member.id)

    assert_redirected_to members_path(group)
    assert_equal 0, group.group_members.count
  end
end
