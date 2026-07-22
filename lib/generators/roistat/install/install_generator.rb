# frozen_string_literal: true

require "rails/generators"

class Roistat::Generators::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  desc "Creates a Roistat initializer with all configuration options"

  def create_initializer_file
    template "roistat.rb", "config/initializers/roistat.rb"
  end
end
