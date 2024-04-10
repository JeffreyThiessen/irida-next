# frozen_string_literal: true

# Component to render Nextflow pipeline forms
class NextflowComponent < Component
  include NextflowHelper

  attr_reader :schema, :url, :workflow

  def initialize(url:, samples:, workflow:)
    @samples = samples
    @url = url
    @workflow = workflow
  end
end
