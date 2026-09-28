# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :maintenance, optional: true do
	gem "bake-gem"
	gem "bake-modernize"
	gem "bake-releases"

	gem "socketry", git: "https://github.com/socketry/socketry.git", tag: "v0.7.0"
	gem "agent-context"
	gem "agent-skills"

	gem "utopia-project"
end

group :test do
	gem "sus"
	gem "covered"

	gem "rubocop"
	gem "rubocop-md"
	gem "rubocop-socketry"

	gem "bake-test"
end
