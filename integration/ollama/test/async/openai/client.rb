# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "async/openai"
require "sus/fixtures/async/reactor_context"

describe "Async::OpenAI with Ollama" do
	include Sus::Fixtures::Async::ReactorContext

	let(:endpoint) {ENV.fetch("OPENAI_API_ENDPOINT", "http://localhost:11434/v1")}
	let(:model) {ENV.fetch("OPENAI_MODEL", "qwen3:0.6b")}
	let(:client) {Async::OpenAI::Client.open(endpoint, api_key: "ollama")}

	with "#models" do
		it "lists the configured model" do
			models = client.models

			expect(models.ids).to be(:include?, model)
		end
	end

	with "#chat" do
		it "creates a chat completion" do
			completion = client.chat(
				[{role: "user", content: "Reply with one short greeting."}],
				model: model,
			)

			expect(completion.model).to be == model
			expect(completion.response).to be =~ /\S/
		end
	end

	with "#responses" do
		it "creates a response" do
			response = client.responses("Reply with one short greeting.", model: model)

			expect(response.model).to be == model
			expect(response.status).to be == "completed"
			expect(response.output_text).to be =~ /\S/
		end
	end
end
