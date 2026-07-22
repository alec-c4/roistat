# frozen_string_literal: true

require "spec_helper"
require "rails/generators"
require "rails/generators/testing/behavior"
require "generators/roistat/install/install_generator"

RSpec.describe Roistat::Generators::InstallGenerator, type: :generator do
  include Rails::Generators::Testing::Behavior
  include FileUtils

  tests described_class
  destination File.expand_path("../../tmp", __dir__)

  before { prepare_destination }

  describe "AC-P11: install initializer" do
    subject(:initializer) { File.read(File.join(destination_root, "config/initializers/roistat.rb")) }

    before { run_generator }

    it "creates config/initializers/roistat.rb" do
      expect(File).to exist(File.join(destination_root, "config/initializers/roistat.rb"))
    end

    it "includes Roistat.configure and required credentials" do
      expect(initializer).to include("Roistat.configure")
      expect(initializer).to include("config.api_key")
      expect(initializer).to include("config.project")
      expect(initializer).to include('ENV.fetch("ROISTAT_API_KEY")')
      expect(initializer).to include('ENV.fetch("ROISTAT_PROJECT_ID")')
    end

    it "documents optional configuration options" do
      expect(initializer).to include("config.base_url")
      expect(initializer).to include("config.timeout")
      expect(initializer).to include("config.open_timeout")
      expect(initializer).to include("config.binary_tempfile_threshold")
    end
  end
end
