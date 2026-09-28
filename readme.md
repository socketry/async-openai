# Async::OpenAI

An asynchronous Ruby client for the OpenAI API, built on Async and Async::REST. The server and proxy implementation lives in [socketry/laiya](https://github.com/socketry/laiya).

[![Development Status](https://github.com/socketry/async-openai/workflows/Test/badge.svg)](https://github.com/socketry/async-openai/actions?workflow=Test)

## Usage

The client uses `OPENAI_API_KEY` for authentication and connects to `https://api.openai.com/v1` by default. You can also pass `api_key:` to `Client.open` or provide a different endpoint.

``` ruby
require "async/openai"

Async::OpenAI::Client.open do |client|
	models = client.models
	puts models.ids

	completion = client.chat(
		[{role: "user", content: "Say hello."}],
		model: "gpt-4.1-mini"
	)
	puts completion.response

	response = client.responses("Say hello.", model: "gpt-4.1-mini")
	puts response.output_text
end
```

Both generation methods accept the API's remaining request parameters as keyword arguments. Their representations expose the decoded response through `value` as well as convenience methods such as `response`, `output_text`, `choices`, and `usage`.

Please see the [project documentation](https://socketry.github.io/async-openai/) for more details.

## Contributing

Install the development dependencies with `bundle install`, then run `bundle exec sus`.

### Agent Guidance

Enable the maintenance dependencies, then install the Socketry project guidance and skills:

``` bash
bundle config set --local with maintenance
bundle install
bundle exec bake agent:context:install --gem socketry
bundle exec bake agent:skills:install --gem socketry
```

The context includes guidance for creating Ruby gems, and the skills include the Socketry GitHub repository workflow.

## Releases

Please see the [project releases](https://socketry.github.io/async-openai/releases/index) for all releases.
