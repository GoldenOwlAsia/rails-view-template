# == Schema Information
#
# Table name: roles
#
#  id            :uuid             not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :uuid
#
# Indexes
#
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id) UNIQUE
#  index_roles_on_resource                                (resource_type,resource_id)
#
class Role < ApplicationRecord
  # The primary key is a UUID, so ordering by it is arbitrary rather than
  # chronological. first/last/pagination need a real time column.
  self.implicit_order_column = :created_at

  scopify

  NAMES = %w[super_admin admin employee].freeze

  belongs_to :resource, polymorphic: true, optional: true
  has_and_belongs_to_many :users, join_table: :users_roles # rubocop:disable Rails/HasAndBelongsToMany

  validates :resource_type, inclusion: { in: Rolify.resource_types }, allow_nil: true
  # Rolify scopes roles by resource, so a name is unique per resource rather
  # than globally. Backed by the unique index on
  # (name, resource_type, resource_id).
  validates :name, inclusion: { in: NAMES }, uniqueness: { scope: %i[resource_type resource_id] }
end
