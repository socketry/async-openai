# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/rest/resource"

module Async
	module OpenAI
		# Represents an authenticated connection to the OpenAI API.
		class Client < Async::REST::Resource
			ENDPOINT = Async::HTTP::Endpoint.parse("https://api.openai.com/v1")

			# @parameter api_key [String] The OpenAI API key.
			def initialize(delegate, reference = ::Protocol::URL::Reference.parse, headers = ::Protocol::HTTP::Headers.new, api_key: ENV["OPENAI_API_KEY"])
				headers = headers.merge("authorization" => "Bearer #{api_key}") if api_key

				super(delegate, reference, headers)
			end
		end
	end
end
