
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bpl/derivatives/version"

Gem::Specification.new do |spec|
  spec.name          = "bpl-derivatives"
  spec.version       = BPL::Derivatives::VERSION
  spec.authors       = ["Benjamin Barber"]
  spec.email         = ["bbarber@bpl.org"]

  spec.summary       = %q{Dervivatives Processor borrowed heavily from Samvera hydra-derivatives}
  spec.description   = %q{Dervivatives Processor borrowed heavily from Samvera hydra-derivatives with the added benefit of being decoupled to ActiveFedora}
  spec.homepage      = "https://github.com/boston-library/bpl-derivatives"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency 'active_encode', '~> 0.1'
  spec.add_dependency 'activesupport', '>= 4.0', '< 6'
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_dependency 'mime-types', '> 2.0', '< 4.0'
  spec.add_dependency 'mini_magick', '>= 3.2', '< 5'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'awesome_print', '~> 0'
  spec.add_development_dependency 'nokogiri', '~> 1.10'
end
