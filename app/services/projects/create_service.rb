# frozen_string_literal: true

module Projects
  # Service used to Create Projects
  class CreateService < BaseService
    attr_accessor :namespace_params

    def initialize(user = nil, params = {})
      super(user, params)
      @namespace_params = @params.delete(:namespace_attributes)
    end

    def execute
      @project = Project.new(creator: current_user)

      @project.build_namespace(params.merge(owner: current_user, type: 'Project'))

      @project.save

      @project
    end
  end
end
