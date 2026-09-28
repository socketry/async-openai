# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/rest/representation"

module Async
	module OpenAI
		# Represents a chat completion returned by the Chat Completions API.
		class ChatCompletion < Async::REST::Representation
			# @returns [Array(Hash)] The generated completion choices.
			def choices
				self.value[:choices]
			end

			# @returns [Hash | nil] The first choice's assistant message.
			def message
				if choice = self.choices&.first
					choice[:message]
				end
			end

			# @returns [String | Array | nil] The first choice's message content.
			def response
				if message = self.message
					message[:content]
				end
			end

			# @returns [Array(Hash) | nil] The first choice's tool calls.
			def tool_calls
				if message = self.message
					message[:tool_calls]
				end
			end

			# @returns [String] The model identifier used for the completion.
			def model
				self.value[:model]
			end

			# @returns [Hash | nil] Token usage information for the completion.
			def usage
				self.value[:usage]
			end
		end
	end
end
