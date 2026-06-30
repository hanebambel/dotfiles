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

source activate_ifmllm.sh
export ANTHROPIC_BASE_URL="${ANTHROPIC_FOUNDRY_BASE_URL}"
export HEADROOM_EMBEDDER_RUNTIME=pytorch_mps
export HEADROOM_OUTPUT_SHAPER=1
headroom proxy --port 8787 --code-graph --memory --code-aware &
sleep 2
export ANTHROPIC_FOUNDRY_BASE_URL="http://127.0.0.1:8787"
