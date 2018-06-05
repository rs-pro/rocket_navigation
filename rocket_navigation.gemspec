
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rocket_navigation/version"

Gem::Specification.new do |spec|
  spec.name          = "rocket_navigation"
  spec.version       = RocketNavigation::VERSION
  spec.authors       = ["Gleb Tv"]
  spec.email         = ["glebtv@gmail.com"]

  spec.summary       = %q{rocket_navigation is a gem for creating navigation / menu (for Rails).}
  spec.description   = %q{Currently alpha qualiy, use at your own risk.}
  spec.homepage      = "https://gitlab.com/rocket-science/rocket_navigation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>= 5.0'
  spec.add_runtime_dependency 'actionpack', '>= 5.0'
  spec.add_runtime_dependency 'actionview', '>= 5.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency 'guard-rspec', '~> 4.2'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'tzinfo', '>= 0'
end
