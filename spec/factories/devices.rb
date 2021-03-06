# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    name { generate(:name) }
    rack_height { generate(:vid) }

    device_type
  end
end
