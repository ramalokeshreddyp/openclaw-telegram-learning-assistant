#!/bin/bash

# Wait for Ollama to be ready
echo "Waiting for Ollama service to be ready..."
until curl -s http://ollama:11434/api/tags > /dev/null; do
  echo "Ollama not ready yet, waiting..."
  sleep 5
done

echo "Ollama is ready!"

# Pull the model if not already available
echo "Ensuring Ollama model is available..."
if ! curl -s http://ollama:11434/api/tags | grep -q "llama3:8b"; then
  echo "Pulling llama3:8b model..."
  curl -X POST http://ollama:11434/api/pull -d '{"name":"llama3:8b"}' &
  PULL_PID=$!
  wait $PULL_PID
fi

echo "Starting OpenClaw Gateway..."
exec "$@"
