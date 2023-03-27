# frozen_string_literal: true

module Types
  # Namespace Type
  class NamespaceType < Types::BaseObject
    description 'A namespace'

    field :description, String, null: false, description: 'Description of the namespace.'
    field :full_name, String, null: false, description: 'Full name of the namespace.'
    field :full_path, ID, null: false, description: 'Full path of the namespace.' # rubocop:disable GraphQL/ExtractType
    field :id, ID, null: false, description: 'ID of the namespace.'
    field :name, String, null: false, description: 'Name of the namespace.'
    field :path, String, null: false, description: 'Path of the namespace.'
  end
end