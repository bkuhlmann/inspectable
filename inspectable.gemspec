# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "inspectable"
  spec.version = "0.2.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/inspectable"
  spec.summary = "A customizable object inspector."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/inspectable/issues",
    "changelog_uri" => "https://alchemists.io/projects/inspectable/versions",
    "homepage_uri" => "https://alchemists.io/projects/inspectable",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "Inspectable",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/inspectable"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = "~> 3.4"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
