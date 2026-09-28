# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/rest/representation"

module Async
	module OpenAI
		# Represents the models available to the current API key.
		class Models < Async::REST::Representation
			# @returns [Array(Hash)] The model records returned by the API.
			def data
				self.value[:data]
			end

			# @returns [Array(String)] The available model identifiers.
			def ids
				self.data.map{|model| model[:id]}
			end
		end
	end
end
