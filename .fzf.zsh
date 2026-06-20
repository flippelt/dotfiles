# Setup fzf — cross-platform (macOS via Homebrew, Linux via ~/.fzf ou /usr/share)
# ------------------------------------------------------------------------------
_fzf_base=""
if command -v brew > /dev/null 2>&1 && [ -d "$(brew --prefix)/opt/fzf" ]; then
	_fzf_base="$(brew --prefix)/opt/fzf"          # macOS / Homebrew
elif [ -d "$HOME/.fzf" ]; then
	_fzf_base="$HOME/.fzf"                          # instalação manual (git)
elif [ -d /usr/share/fzf ]; then
	_fzf_base=/usr/share/fzf                        # Linux (pacote distro)
fi

if [ -n "$_fzf_base" ]; then
	[ -d "$_fzf_base/bin" ] && case ":$PATH:" in
		*":$_fzf_base/bin:"*) ;;
		*) export PATH="${PATH:+${PATH}:}$_fzf_base/bin" ;;
	esac

	for c in "$_fzf_base/shell/completion.zsh" "$_fzf_base/completion.zsh"; do
		[[ $- == *i* ]] && [ -f "$c" ] && source "$c" 2> /dev/null && break
	done

	for k in "$_fzf_base/shell/key-bindings.zsh" "$_fzf_base/key-bindings.zsh"; do
		[ -f "$k" ] && source "$k" 2> /dev/null && break
	done
fi
unset _fzf_base
