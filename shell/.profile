[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -r "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# Added by LM Studio CLI (lms)
[ -d "$HOME/.cache/lm-studio/bin" ] && export PATH="$PATH:$HOME/.cache/lm-studio/bin"
