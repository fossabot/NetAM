# frozen_string_literal: true

require 'pathname'

module NetAM
  def self.root
    Pathname.new(File.expand_path('..', __dir__))
  end

  VERSION = File.read(root.join('VERSION')).strip.freeze
end
