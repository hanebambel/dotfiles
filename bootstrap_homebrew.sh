#!/bin/zsh

BREW_SUDOLESS_DIR="$HOME/.local/Homebrew"
BREW_SUDOLESS_BIN="$HOME/.local/Homebrew/bin/brew"
BREW_STANDARD_BIN_ARM="/opt/homebrew/bin/brew"
BREW_STANDARD_BIN_X86="/usr/local/bin/brew"
ZSHRC_LOCAL="$HOME/.zshrc_local"
BREWFILE="$(dirname "$0")/Brewfile"

# ── helpers ──────────────────────────────────────────────────────────────────

step()  { echo "\n==> $*"; }
info()  { echo "    $*"; }
warn()  { echo "    [!] $*"; }

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
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Determine which standard bin was created
            if [[ -x "$BREW_STANDARD_BIN_ARM" ]]; then
                BREW_BIN="$BREW_STANDARD_BIN_ARM"
            else
                BREW_BIN="$BREW_STANDARD_BIN_X86"
            fi
            ;;
        2)
            step "Installing Homebrew to ~/.local/Homebrew (no sudo)..."
            mkdir -p "$BREW_SUDOLESS_DIR"
            curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C "$BREW_SUDOLESS_DIR"
            mkdir -p "$HOME/.local/bin"
            ln -sf "$BREW_SUDOLESS_BIN" "$HOME/.local/bin/brew"
            BREW_BIN="$BREW_SUDOLESS_BIN"
            SUDOLESS=1
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi

# ── PATH configuration for sudoless install ───────────────────────────────────

if [[ -n "$SUDOLESS" ]]; then
    # Also detect if we landed here from the idempotency check on a sudoless install
    [[ "$BREW_BIN" == "$BREW_SUDOLESS_BIN" ]] && SUDOLESS=1
fi

if [[ "$BREW_BIN" == "$BREW_SUDOLESS_BIN" ]]; then
    # Configure current shell session immediately
    export HOMEBREW_PREFIX="$HOME/.local"
    export HOMEBREW_CELLAR="$HOME/.local/Cellar"
    export HOMEBREW_REPOSITORY="$HOME/.local/Homebrew"
    export PATH="$HOME/.local/bin:$HOME/.local/sbin${PATH+:$PATH}"

    # Set cask appdir for current session
    mkdir -p "$HOME/Applications"
    export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"

    # Persist to ~/.zshrc_local (guarded against duplicate writes)
    if ! grep -q 'HOMEBREW_PREFIX' "$ZSHRC_LOCAL" 2>/dev/null; then
        step "Adding Homebrew config to $ZSHRC_LOCAL..."
        cat >> "$ZSHRC_LOCAL" <<'EOF'

# Homebrew sudoless install (added by bootstrap_homebrew.sh)
export HOMEBREW_PREFIX="$HOME/.local"
export HOMEBREW_CELLAR="$HOME/.local/Cellar"
export HOMEBREW_REPOSITORY="$HOME/.local/Homebrew"
export PATH="$HOME/.local/bin:$HOME/.local/sbin${PATH+:$PATH}"
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"
EOF
        info "Written. Run: source $ZSHRC_LOCAL  (or open a new terminal)"
    else
        info "Config block already present in $ZSHRC_LOCAL, skipping."
    fi
fi

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
