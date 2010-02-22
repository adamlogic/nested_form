#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "nested_form"
  s.version = "0.1.1"
  s.authors = ["Ryan Bates", "Alexander Mankuta"]
  s.homepage = "http://github.com/cheba/nested_forms"
  s.summary = "Rails plugin to conveniently handle multiple models in a single form"
  s.description = "#{s.summary}. Not tested with Rails 3."
  s.email = Base64.decode64("Y2hlYmFAcG9pbnRsZXNzb25lLm9yZw==")
  s.has_rdoc = true
  s.licenses = %w[BSD]

  # files
  s.files = %w[generators/nested_form_js/nested_form_js_generator.rb generators/nested_form_js/templates/jquery.js generators/nested_form_js/USAGE init.rb lib/nested_form/builder.rb lib/nested_form.rb lib/nested_form/view_helper.rb rails/init.rb]
  s.test_files = %w[Rakefile spec/nested_form/builder_spec.rb spec/nested_form/view_helper_spec.rb spec/spec_helper.rb]

  s.require_paths = %w[lib]

  s.extra_rdoc_files = %w[README.rdoc]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new(">= 1.8.6")

  # dependencies
  s.add_development_dependency "rspec", "~> 1.2"
end
