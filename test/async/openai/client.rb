# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/openai"

describe Async::OpenAI::Client do
	let(:requests) {[]}

	let(:delegate) do
		requests = self.requests

		Protocol::HTTP::Middleware.for do |request|
			payload = if request.body
				JSON.parse(request.read, symbolize_names: true)
			end

			requests << {
				method: request.method,
				path: request.path,
				authorization: request.headers["authorization"],
				payload: payload,
			}

			value = case request.path
			when "/v1/models"
				{object: "list", data: [{id: "test-model", object: "model", owned_by: "test"}]}
			when "/v1/chat/completions"
				{
					id: "chatcmpl-test",
					model: "test-model",
					choices: [{index: 0, message: {role: "assistant", content: "Hello"}, finish_reason: "stop"}],
					usage: {total_tokens: 3},
				}
			when "/v1/responses"
				{
					id: "resp_test",
					model: "test-model",
					status: "completed",
					output: [
						{type: "reasoning"},
						{type: "message", content: [{type: "output_text", text: "Hello"}]},
					],
					usage: {total_tokens: 3},
				}
			end

			Protocol::HTTP::Response[200, {"content-type" => "application/json"}, [JSON.dump(value)]]
		end
	end

	let(:client) do
		subject.new(
			delegate,
			Protocol::URL::Reference.parse("/v1"),
			Protocol::HTTP::Headers.new,
			api_key: "test-key",
		)
	end

	with "#models" do
		it "lists model identifiers" do
			models = client.models

			expect(models.ids).to be == ["test-model"]
			expect(requests.last).to have_keys(
				method: be == "GET",
				path: be == "/v1/models",
				authorization: be == "Bearer test-key",
			)
		end
	end

	with "#chat" do
		it "creates a chat completion" do
			messages = [{role: "user", content: "Say hello."}]
			completion = client.chat(messages, model: "test-model", temperature: 0)

			expect(completion.response).to be == "Hello"
			expect(completion.tool_calls).to be_nil
			expect(completion.model).to be == "test-model"
			expect(completion.usage[:total_tokens]).to be == 3
			expect(requests.last).to have_keys(
				method: be == "POST",
				path: be == "/v1/chat/completions",
				authorization: be == "Bearer test-key",
				payload: be == {messages: messages, model: "test-model", temperature: 0},
			)
		end
	end

	with "#responses" do
		it "creates a model response" do
			response = client.responses("Say hello.", model: "test-model")

			expect(response.output_text).to be == "Hello"
			expect(response.status).to be == "completed"
			expect(response.model).to be == "test-model"
			expect(response.usage[:total_tokens]).to be == 3
			expect(requests.last).to have_keys(
				method: be == "POST",
				path: be == "/v1/responses",
				authorization: be == "Bearer test-key",
				payload: be == {input: "Say hello.", model: "test-model"},
			)
		end
	end
end
