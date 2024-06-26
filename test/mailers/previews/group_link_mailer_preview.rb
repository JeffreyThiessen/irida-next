# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/group_link_mailer
class GroupLinkMailerPreview < ActionMailer::Preview
  def access_granted_to_group_user_email
    setup_group
    setup_user_emails(params[:locale])
    GroupLinkMailer.access_granted_user_email(@user_emails, @group, @namespace, params[:locale])
  end

  def access_granted_to_project_user_email
    setup_project
    setup_user_emails(params[:locale])
    GroupLinkMailer.access_granted_user_email(@user_emails, @group, @namespace, params[:locale])
  end

  def access_revoked_from_group_user_email
    setup_group
    setup_user_emails(params[:locale])
    GroupLinkMailer.access_revoked_user_email(@user_emails, @group, @namespace, params[:locale])
  end

  def access_revoked_from_project_user_email
    setup_project
    setup_user_emails(params[:locale])
    GroupLinkMailer.access_revoked_user_email(@user_emails, @group, @namespace, params[:locale])
  end

  def access_granted_to_group_manager_email
    setup_group
    setup_manager_emails(params[:locale])
    GroupLinkMailer.access_granted_manager_email(@manager_emails, @group, @namespace, params[:locale])
  end

  def access_granted_to_project_manager_email
    setup_project
    setup_manager_emails(params[:locale])
    GroupLinkMailer.access_granted_manager_email(@manager_emails, @group, @namespace, params[:locale])
  end

  def access_revoked_from_group_manager_email
    setup_group
    setup_manager_emails(params[:locale])
    GroupLinkMailer.access_revoked_manager_email(@manager_emails, @group, @namespace, params[:locale])
  end

  def access_revoked_from_project_manager_email
    setup_project
    setup_manager_emails(params[:locale])
    GroupLinkMailer.access_revoked_manager_email(@manager_emails, @group, @namespace, params[:locale])
  end

  private

  def setup_group
    @group = Group.last
    @namespace = Group.first
  end

  def setup_project
    @group = Group.last
    @namespace = Project.first.namespace
  end

  def setup_user_emails(locale)
    @user_emails = Member.user_emails(@namespace, locale)
  end

  def setup_manager_emails(locale)
    @manager_emails = Member.manager_emails(@namespace, locale)
  end
end
