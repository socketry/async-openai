# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/rest/representation"

module Async
	module OpenAI
		# Represents a response returned by the Responses API.
		class Response < Async::REST::Representation
			# @returns [Array(Hash)] The generated output items.
			def output
				self.value[:output]
			end

			# @returns [String] The text from all output text content items.
			def output_text
				self.output.to_a.flat_map do |item|
					if item[:type] == "message"
						item[:content].to_a.filter_map do |content|
							content[:text] if content[:type] == "output_text"
						end
					else
						[]
					end
				end.join
			end

			# @returns [String] The response status.
			def status
				self.value[:status]
			end

			# @returns [String] The model identifier used for the response.
			def model
				self.value[:model]
			end

			# @returns [Hash | nil] Token usage information for the response.
			def usage
				self.value[:usage]
			end
		end
	end
end
