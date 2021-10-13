$LOAD_PATH.push File.expand_path("lib", __dir__)
# Maintain your gem's version:
require "zaikio/procurement/version"

Gem::Specification.new do |spec|
  spec.name          = "zaikio-procurement"
  spec.version       = Zaikio::Procurement::VERSION
  spec.authors       = ["Zaikio GmbH", "Sascha Weidlich"]
  spec.email         = ["sw@zaikio.com"]
  spec.homepage      = "https://www.zaikio.com/"
  spec.summary       = "Ruby API Client for Zaikio's Procurement Platform"
  spec.description   = "Ruby API Client for Zaikio's Procurement Platform"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["changelog_uri"] = "https://github.com/zaikio/zaikio-procurement-ruby/blob/main/CHANGELOG.md"
    spec.metadata["source_code_uri"] = "https://github.com/zaikio/zaikio-procurement-ruby"
  end

  spec.files = Dir[
    "{app,config,db,lib}/**/*", "MIT-LICENSE",
    "Rakefile", "README.md"
    ]

  spec.require_paths = ["lib"]
  spec.add_dependency "concurrent-ruby"
  spec.add_dependency "jwt"
  spec.add_dependency "multi_json"
  spec.add_dependency "oj"
  spec.add_dependency "spyke"
  spec.add_dependency "zaikio-client-helpers", "~> 0.2"

  spec.required_ruby_version = ">= 2.7.1"
end
