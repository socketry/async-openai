# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/rest/resource"

require_relative "models"
require_relative "chat_completion"
require_relative "response"

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

			# Retrieves the models available to the current API key.
			# @returns [Models] The model list representation.
			def models
				Models.get(self.with(path: "models"))
			end

			# Creates a chat completion for the given conversation.
			# @parameter messages [Array(Hash)] The messages in the conversation.
			# @parameter options [Hash] Additional chat completion parameters, including the model.
			# @returns [ChatCompletion] The chat completion representation.
			def chat(messages, **options)
				options[:messages] = messages

				ChatCompletion.post(self.with(path: "chat/completions"), options) do |resource, response|
					yield response if block_given?

					ChatCompletion.new(resource, value: response.read, metadata: response.headers)
				end
			end

			# Creates a response using the Responses API.
			# @parameter input [String | Array] The text or structured input for the model.
			# @parameter options [Hash] Additional response parameters, including the model.
			# @returns [Response] The response representation.
			def responses(input, **options)
				options[:input] = input

				Response.post(self.with(path: "responses"), options) do |resource, response|
					yield response if block_given?

					Response.new(resource, value: response.read, metadata: response.headers)
				end
			end
		end
	end
end
