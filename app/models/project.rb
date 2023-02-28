# frozen_string_literal: true

# entity class for Project
class Project < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  belongs_to :namespace, autosave: true, class_name: 'Namespaces::ProjectNamespace'

  delegate :description, to: :namespace
  delegate :name, to: :namespace
  delegate :path, to: :namespace
  delegate :human_name, to: :namespace
  delegate :full_path, to: :namespace

  def to_param
    path
  end
end
