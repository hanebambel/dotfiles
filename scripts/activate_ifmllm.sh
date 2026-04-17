#!/bin/bash
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Run: source $(basename "${BASH_SOURCE[0]}")"
    exit 1
fi
FOUNDRY_KEY_FILE="${FOUNDRY_KEY_FILE:-$HOME/.anthropic_foundry_api_key}"
if [ ! -f "$FOUNDRY_KEY_FILE" ]; then
    echo "Error: API key file not found at $FOUNDRY_KEY_FILE"
    echo "Set FOUNDRY_KEY_FILE to point to your key file."
    return 1
fi
export ANTHROPIC_FOUNDRY_API_KEY="$(cat "$FOUNDRY_KEY_FILE")"
export ANTHROPIC_FOUNDRY_BASE_URL="${ANTHROPIC_FOUNDRY_BASE_URL:-https://llm.infomotion.de}"
export ANTHROPIC_DEFAULT_OPUS_MODEL="${ANTHROPIC_DEFAULT_OPUS_MODEL:-azure_ai/claude-opus-4-6[1m]}"
export ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-azure_ai/claude-sonnet-4-6[1m]}"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL:-azure_ai/claude-haiku-4-5}"
export CLAUDE_CODE_USE_FOUNDRY="1"