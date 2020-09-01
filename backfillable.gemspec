require_relative 'lib/backfillable/version'

Gem::Specification.new do |spec|
  spec.name          = "backfillable"
  spec.version       = Backfillable::VERSION
  spec.authors       = ["Quan Nguyen"]
  spec.email         = ["ndmquan@gmail.com"]

  spec.summary       = %q{Manage and run your Rails app's backfills}
  spec.description   = %q{A lib that helps teams manage and run data backfills in Rails}
  spec.homepage      = "https://github.com/mquan/backfillable"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mquan/backfillable"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rails", "~> 6.0"
end
