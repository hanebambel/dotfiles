#!/bin/zsh
# Source this file (don't execute it) to activate the Anthropic Foundry env.
# This script is standalone -- it does NOT depend on the rest of the dotfiles
# setup, so it can live anywhere on the PATH and be invoked manually.
case "${ZSH_EVAL_CONTEXT-}" in
    *:file*) ;;
    *)
        echo "Error: This script must be sourced, not executed."
        echo "Run: source ${(%):-%x}"
        exit 1
        ;;
esac

FOUNDRY_KEY_FILE="${FOUNDRY_KEY_FILE:-$HOME/.anthropic_foundry_api_key}"
if [[ ! -s "$FOUNDRY_KEY_FILE" ]]; then
    echo "Error: API key file missing or empty at $FOUNDRY_KEY_FILE"
    echo "Set FOUNDRY_KEY_FILE to point to your key file."
    return 1
fi

export ANTHROPIC_FOUNDRY_API_KEY="$(<"$FOUNDRY_KEY_FILE")"
export ANTHROPIC_FOUNDRY_BASE_URL="${ANTHROPIC_FOUNDRY_BASE_URL:-https://llm.infomotion.de}"
export ANTHROPIC_DEFAULT_OPUS_MODEL="${ANTHROPIC_DEFAULT_OPUS_MODEL:-azure_ai/claude-opus-4-7[1m]}"
export ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL:-azure_ai/claude-sonnet-4-6[1m]}"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL:-azure_ai/claude-haiku-4-5}"
export CLAUDE_CODE_USE_FOUNDRY="1"
