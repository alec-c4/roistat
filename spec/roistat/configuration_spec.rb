# frozen_string_literal: true

RSpec.describe Roistat::Configuration do
  describe "global configure" do
    it "stores api_key and project" do
      Roistat.configure do |config|
        config.api_key = "test-key"
        config.project = "12345"
      end

      expect(Roistat.configuration.api_key).to eq("test-key")
      expect(Roistat.configuration.project).to eq("12345")
    end

    it "exposes defaults for optional options" do
      expect(Roistat.configuration.base_url).to eq(Roistat::Configuration::DEFAULT_BASE_URL)
      expect(Roistat.configuration.timeout).to eq(30)
      expect(Roistat.configuration.open_timeout).to eq(10)
      expect(Roistat.configuration.binary_tempfile_threshold).to eq(1 * 1024 * 1024)
    end
  end
end
