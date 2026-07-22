# frozen_string_literal: true

require_relative "lib/roistat/version"

Gem::Specification.new do |spec|
  spec.name = "roistat"
  spec.version = Roistat::VERSION
  spec.authors = ["Alexey Poimtsev"]
  spec.email = ["alexey.poimtsev@gmail.com"]

  spec.summary = "Ruby wrapper for the Roistat REST API."
  spec.description = "Ruby wrapper for the Roistat REST API. Authenticate with an API key and project id to call Roistat endpoints (leads, call tracking, and other project methods)."
  spec.homepage = "https://github.com/alec-c4/roistat"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/alec-c4/roistat"
  spec.metadata["changelog_uri"] = "https://github.com/alec-c4/roistat/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httpx", ">= 1.0"

  spec.add_development_dependency "lefthook"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "railties", ">= 7.2"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "webmock", "~> 3.0"
end
