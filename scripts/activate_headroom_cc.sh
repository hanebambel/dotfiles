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

export HEADROOM_EMBEDDER_RUNTIME=pytorch_mps
export HEADROOM_OUTPUT_SHAPER=1
headroom proxy --port 8787 --code-graph --memory &
sleep 2
export ANTHROPIC_BASE_URL="http://127.0.0.1:8787"