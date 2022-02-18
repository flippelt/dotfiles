# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lippelt/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/lippelt/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/lippelt/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/lippelt/.fzf/shell/key-bindings.zsh"
