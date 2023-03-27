# frozen_string_literal: true

# IridaSchema
class IridaSchema < GraphQL::Schema # rubocop:disable GraphQL/ObjectDescription
  query Types::QueryType
  mutation Types::MutationType

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  max_depth 15
  max_complexity 250
  default_max_page_size 100

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context) # rubocop:disable Lint/UselessMethodDefinition
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Union and Interface Resolution
  def self.resolve_type(type, object, ctx)
    return if type.respond_to?(:assignable?) && type.assignable?(object)

    super
  end

  # Stop validating when it encounters this many errors:
  validate_max_errors 100

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, _type: nil, _ctx: nil)
    raise "#{object} does not implement `to_global_id`." unless object.respond_to?(:to_global_id)

    object.to_global_id
  end

  # Find an object by looking it up from its global ID, passed as a string.
  def self.object_from_id(global_id, ctx = {})
    gid = parse_gid(global_id, ctx)

    GlobalID.find(gid)
  end

  # Parse a string to a GlobalID, raising if there are problems with it.
  def self.parse_gid(global_id, ctx = {})
    expected_types = Array(ctx[:expected_type])
    gid = GlobalID.parse(global_id)

    raise "#{global_id} is not a valid IRIDA Next ID." unless gid

    if expected_types.any? && expected_types.none? { |type| gid.model_class.ancestors.include?(type) }
      raise "#{global_id} is not a valid ID for #{expected_types.join(', ')}"
    end

    gid
  end
end