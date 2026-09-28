# frozen_string_literal: true

require_relative "lib/async/openai/version"

Gem::Specification.new do |spec|
	spec.name = "async-openai"
	spec.version = Async::OpenAI::VERSION

	spec.summary = "An asynchronous client for the OpenAI API."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"

	spec.homepage = "https://github.com/socketry/async-openai"

	spec.metadata = {
		"documentation_uri" => "https://socketry.github.io/async-openai/",
		"source_code_uri" => "https://github.com/socketry/async-openai.git",
	}

	spec.files = Dir.glob(["{bake,context,lib}/**/*", "*.md"], File::FNM_DOTMATCH, base: __dir__)

	spec.required_ruby_version = ">= 3.3"

	spec.add_dependency "async"
	spec.add_dependency "async-rest"
end
