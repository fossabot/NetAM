# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :device_type, optional: true
  delegate :name, :color, to: :device_type, prefix: true, allow_nil: true

  has_one :usage, dependent: :nullify
  has_one :rack_occupation, dependent: :delete
  has_one :rackspace, through: :rack_occupation

  enum depth_type: { small: 1, half: 2, full: 3 }, _suffix: 'depth'

  accepts_nested_attributes_for :rack_occupation, allow_destroy: true, reject_if: ->(r) { r['rack_anchor'].blank? }

  validates :name, :rack_height, :depth_type, presence: true
  validates :name, presence: true, uniqueness: true
end
