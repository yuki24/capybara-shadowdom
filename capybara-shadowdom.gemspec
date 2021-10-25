# frozen_string_literal: true

require_relative "lib/capybara/shadowdom/version"

Gem::Specification.new do |spec|
  spec.name          = "capybara-shadowdom"
  spec.version       = Capybara::Shadowdom::VERSION
  spec.authors       = ["Yuki Nishijima"]
  spec.email         = ["yuki24@hey.com"]

  spec.summary       = "Shadow DOM support for Capybara"
  spec.description   = "Test Web Components built with the Shadow DOM"
  spec.homepage      = "https://github.com/yuki24/capybara-shadowdom"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test)/|\.(?:git)|appveyor)})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara"
end
