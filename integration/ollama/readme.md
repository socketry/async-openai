# Ollama Integration

This scenario runs Ollama as an OpenAI-compatible API server and checks model listing, chat completions, and the Responses API through the Async::OpenAI client.

Run it with Docker Compose:

``` bash
bundle exec bake test:integration name=ollama
```

The default model is `qwen3:0.6b`. Override it with `OLLAMA_MODEL` when running the scenario. The model is downloaded into a temporary Compose volume and removed when the integration task tears down the scenario.
