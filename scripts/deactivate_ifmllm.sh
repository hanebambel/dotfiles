#!/bin/zsh
if [[ "${(%):-%x}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed."
    echo "Run: source $(basename "${(%):-%x}")"
    exit 1
fi
unset ANTHROPIC_FOUNDRY_API_KEY
unset ANTHROPIC_FOUNDRY_BASE_URL
unset ANTHROPIC_DEFAULT_OPUS_MODEL
unset ANTHROPIC_DEFAULT_SONNET_MODEL
unset ANTHROPIC_DEFAULT_HAIKU_MODEL
unset CLAUDE_CODE_USE_FOUNDRY
