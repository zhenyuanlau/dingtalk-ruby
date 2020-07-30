lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dingtalk/version"

Gem::Specification.new do |spec|
  spec.name          = "dingtalk-ruby"
  spec.version       = Dingtalk::VERSION
  spec.authors       = ["Zhenyuan Lau"]
  spec.email         = ["zhenyuanlau@icloud.com"]

  spec.summary       = %q{Dingtalk Ruby SDK}
  spec.description   = %q{Dingtalk Ruby SDK according official specification.}
  spec.homepage      = "https://github.com/zhenyuanlau/dingtalk-ruby"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zhenyuanlau/dingtalk-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/zhenyuanlau/dingtalk-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop"
end
