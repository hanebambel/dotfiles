#!/bin/zsh
source "$(dirname "$0")/lib/common.sh"
load_config

BREW_SUDOLESS_DIR="$HOME/.local/Homebrew"
BREW_SUDOLESS_BIN="$HOME/.local/Homebrew/bin/brew"
BREW_STANDARD_BIN_ARM="/opt/homebrew/bin/brew"
BREW_STANDARD_BIN_X86="/usr/local/bin/brew"
ZSHRC_LOCAL="$HOME/.zshrc_local"
BREWFILE="$(dirname "$0")/Brewfile"

DEPRECATED_TAPS=(
    homebrew/cask-fonts
    homebrew/cask-versions
    homebrew/command-not-found
    homebrew/bundle
    homebrew/services
    nejckorasa/tap
)

# ── idempotency: skip install if brew already exists ─────────────────────────

for candidate in "$BREW_SUDOLESS_BIN" "$BREW_STANDARD_BIN_ARM" "$BREW_STANDARD_BIN_X86"; do
    if [[ -x "$candidate" ]]; then
        step "Homebrew already installed at $candidate"
        BREW_BIN="$candidate"
        break
    fi
done

# ── install if needed ─────────────────────────────────────────────────────────

if [[ -z "$BREW_BIN" ]]; then
    step "Checking sudo availability..."

    if sudo -n true 2>/dev/null; then
        info "Passwordless sudo detected."
        DEFAULT_MODE=1
    else
        info "sudo requires a password or is not available."
        DEFAULT_MODE=2
    fi

    echo
    echo "Select Homebrew installation mode:"
    echo "  [1] Standard  - installs to /opt/homebrew  (requires sudo)"
    echo "  [2] Sudoless  - installs to ~/.local/Homebrew  (no sudo needed)"
    echo
    printf "Enter choice [default: $DEFAULT_MODE]: "
    read CHOICE
    CHOICE=${CHOICE:-$DEFAULT_MODE}

    case "$CHOICE" in
        1)
            step "Running standard Homebrew installer..."
            if [[ "$DEFAULT_MODE" == 1 ]]; then
                NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            else
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            if [[ -x "$BREW_STANDARD_BIN_ARM" ]]; then
                BREW_BIN="$BREW_STANDARD_BIN_ARM"
            else
                BREW_BIN="$BREW_STANDARD_BIN_X86"
            fi
            ;;
        2)
            step "Installing Homebrew to ~/.local/Homebrew (no sudo)..."
            mkdir -p "$BREW_SUDOLESS_DIR"
            curl -L https://github.com/Homebrew/brew/tarball/main | tar xz --strip-components 1 -C "$BREW_SUDOLESS_DIR"
            mkdir -p "$HOME/.local/bin"
            ln -sf "$BREW_SUDOLESS_BIN" "$HOME/.local/bin/brew"
            BREW_BIN="$BREW_SUDOLESS_BIN"
            ;;
        *)
            die "Invalid choice."
            ;;
    esac
fi

# ── PATH configuration for sudoless install ───────────────────────────────────

if [[ "$BREW_BIN" == "$BREW_SUDOLESS_BIN" ]]; then
    export HOMEBREW_PREFIX="$HOME/.local"
    export HOMEBREW_CELLAR="$HOME/.local/Cellar"
    export HOMEBREW_REPOSITORY="$HOME/.local/Homebrew"
    export PATH="$HOME/.local/bin:$HOME/.local/sbin${PATH+:$PATH}"

    mkdir -p "$HOME/Applications"
    export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"

    # Persist to ~/.zshrc_local, rewriting any prior block in place.
    BEGIN_MARK='# >>> homebrew sudoless >>>'
    END_MARK='# <<< homebrew sudoless <<<'

    if [[ -f "$ZSHRC_LOCAL" ]] && grep -qF "$BEGIN_MARK" "$ZSHRC_LOCAL"; then
        step "Rewriting Homebrew sudoless block in $ZSHRC_LOCAL..."
        # awk-based in-place rewrite: drop lines between markers (inclusive), append fresh block.
        awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
            $0 == b {skip=1; next}
            $0 == e {skip=0; next}
            !skip {print}
        ' "$ZSHRC_LOCAL" > "$ZSHRC_LOCAL.tmp" && mv "$ZSHRC_LOCAL.tmp" "$ZSHRC_LOCAL"
    else
        step "Adding Homebrew sudoless block to $ZSHRC_LOCAL..."
    fi

    cat >> "$ZSHRC_LOCAL" <<EOF

$BEGIN_MARK
export HOMEBREW_PREFIX="\$HOME/.local"
export HOMEBREW_CELLAR="\$HOME/.local/Cellar"
export HOMEBREW_REPOSITORY="\$HOME/.local/Homebrew"
export PATH="\$HOME/.local/bin:\$HOME/.local/sbin\${PATH+:\$PATH}"
export HOMEBREW_CASK_OPTS="--appdir=\$HOME/Applications"
$END_MARK
EOF
    info "Written. Run: source $ZSHRC_LOCAL  (or open a new terminal)"
fi

# ── untap deprecated official taps (Homebrew 4.3.0/4.5.0 cleanup) ────────────

step "Checking for deprecated taps..."
TAPPED="$("$BREW_BIN" tap 2>/dev/null)"
for tap in "${DEPRECATED_TAPS[@]}"; do
    if grep -qx "$tap" <<< "$TAPPED"; then
        info "Untapping deprecated $tap"
        "$BREW_BIN" untap "$tap" 2>/dev/null || warn "untap $tap failed"
    fi
done

# ── post-install ──────────────────────────────────────────────────────────────

step "Updating Homebrew..."
"$BREW_BIN" update

step "Upgrading installed packages..."
"$BREW_BIN" upgrade

if [[ -f "$BREWFILE" ]]; then
    step "Installing packages from Brewfile..."
    if [[ "$BREW_BIN" == "$BREW_SUDOLESS_BIN" ]]; then
        warn "Sudoless mode: .app casks install to ~/Applications. pkg-based casks may still fail."
        HOMEBREW_NO_BUILD_FROM_SOURCE=1 "$BREW_BIN" bundle --file="$BREWFILE"
    else
        "$BREW_BIN" bundle --file="$BREWFILE"
    fi
else
    warn "Brewfile not found at $BREWFILE, skipping bundle."
fi

step "Done."
