
# Configure color-scheme
COLOR_SCHEME=dark # dark/light

# Detecta o SO (macos/linux).
case "$(uname -s)" in
	Darwin) _OS=macos ;;
	*)      _OS=linux ;;
esac

# macOS / Homebrew — Apple Silicon (/opt/homebrew) ou Intel (/usr/local).
if [ "$_OS" = macos ]; then
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

# --------------------------------- ALIASES -----------------------------------
alias ..='cd ..'
alias cp='cp -v'
alias rm='rm -I'
alias mv='mv -iv'
# `ln -r` (symlink relativo) é só GNU. No macOS (ln BSD) usa gln se houver
# coreutils, senão cai pra `ln -siv` (sem -r).
if command -v gln > /dev/null; then
	alias ln='gln -sriv'
elif [ "$_OS" = macos ]; then
	alias ln='ln -siv'
else
	alias ln='ln -sriv'
fi
command -v vim > /dev/null && alias vi='vim'

### Clipboard (cross-platform)
if [ "$_OS" = macos ]; then
	alias clip='pbcopy'; alias paste='pbpaste'; alias xclip='pbcopy'
elif command -v xclip > /dev/null; then
	alias clip='xclip -selection clipboard'; alias xclip='xclip -selection c'
fi

### Colorize commands (GNU usa --color; BSD/macOS usa -G + CLICOLOR)
if [ "$_OS" = macos ] && command -v gls > /dev/null; then
	alias ls='gls --color=auto --group-directories-first'
elif [ "$_OS" = macos ]; then
	export CLICOLOR=1
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
[ "$_OS" = linux ] && alias diff='diff --color=auto'
[ "$_OS" = linux ] && command -v ip > /dev/null && alias ip='ip --color=auto'
command -v pacman > /dev/null && alias pacman='pacman --color=auto'

### LS & TREE
alias ll='ls -la'
alias la='ls -A'
alias l='ls -F'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && \
	alias tree='lsd --tree'
command -v colorls > /dev/null && alias ls='colorls --sd --gs' && \
	alias tree='colorls --tree'

### CAT & LESS
command -v bat > /dev/null && \
	alias bat='bat --theme=ansi' && \
	alias cat='bat --pager=never' && \
	alias less='bat'
# in debian the command is batcat
command -v batcat > /dev/null && \
	alias batcat='batcat --theme=ansi' && \
	alias cat='batcat --pager=never' && \
	alias less='batcat'

### TOP
command -v htop > /dev/null && alias top='htop'
command -v gotop > /dev/null && alias top='gotop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v ytop > /dev/null && alias top='ytop -p $([ "$COLOR_SCHEME" = "light" ] && echo "-c default-dark")'
command -v btm > /dev/null && alias top='btm $([ "$COLOR_SCHEME" = "light" ] && echo "--color default-light")'
# themes for light/dark color-schemes inside ~/.config/bashtop; Press ESC to open the menu and change the theme
command -v bashtop > /dev/null && alias top='bashtop'
command -v bpytop > /dev/null && alias top='bpytop'

# --------------------------------- SETTINGS ----------------------------------
shopt -s globstar
shopt -s histappend
shopt -s checkwinsize

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=~/.bash_history

# Bash Completion
if [ -f /usr/share/bash-completion/bash_completion ]
then
	source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]
then
	source /etc/bash_completion
fi

# Add new line before prompt
PROMPT_COMMAND="PROMPT_COMMAND=echo"

# Prompt — tema cinza + verde neon (legível em fundo escuro):
#   bordas/símbolos em verde neon (38;5;46), user@host em cinza claro (38;5;250),
#   caminho em branco-suave.
PS1='\[\033[38;5;46m\]┌──(\[\033[1;38;5;250m\]\u@\h\[\033[0;38;5;46m\])-[\[\033[0;1;38;5;252m\]\w\[\033[0;38;5;46m\]]\n\[\033[38;5;46m\]└─\[\033[1;38;5;46m\]\$\[\033[0m\] '

# ----------------------------------- MISC -----------------------------------
export VISUAL=vim
export EDITOR=$VISUAL

# enable terminal linewrap
setterm -linewrap on 2> /dev/null

# colorize man pages — tema cinza + verde neon (fundo escuro)
export LESS_TERMCAP_mb=$'\e[1;38;5;46m'   # negrito → verde neon
export LESS_TERMCAP_md=$'\e[1;38;5;46m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;38;5;240;48;5;236m'  # status: cinza
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;38;5;250m'  # sublinhado → cinza claro
export LESSHISTFILE=-

# colorize ls — diretórios em verde neon, legível no escuro
export CLICOLOR=1
export LSCOLORS="CxCxxxxxxxxxxxxxCxCx"                                   # BSD/macOS
export LS_COLORS="di=1;38;5;46:ln=1;38;5;48:ex=38;5;46:fi=0"             # GNU
# dircolors (GNU) sobrescreve LS_COLORS se disponível; gdircolors no macOS.
command -v dircolors > /dev/null && eval "$(dircolors -b)" 2>/dev/null
command -v gdircolors > /dev/null && eval "$(gdircolors -b)" 2>/dev/null

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
	;;
esac

# -------------------------------- FUNCTIONS ---------------------------------
lazygit() {
	USAGE="
lazygit [OPTION]... <msg>

    GIT but lazy

    Options:
        --fixup <commit>        runs 'git commit --fixup <commit> [...]'
        --amend                 runs 'git commit --amend --no-edit [...]'
        -f, --force             runs 'git push --force-with-lease [...]'
        -h, --help              show this help text
"
	while [ $# -gt 0 ]
	do
		key="$1"

		case $key in
			--fixup)
				COMMIT="$2"
				shift # past argument
				shift # past value
				;;
			--amend)
				AMEND=true
				shift # past argument
				;;
			-f|--force)
				FORCE=true
				shift # past argument
				;;
			-h|--help)
				echo "$USAGE"
				EXIT=true
				;;
			*)
				MESSAGE="$1"
				shift # past argument
				;;
		esac
	done
	unset key
	if [ -z "$EXIT" ]
	then
		git status .
		git add .
		if [ -n "$AMEND" ]
		then
			git commit --amend --no-edit
		elif [ -n "$COMMIT" ]
		then
			git commit --fixup "$COMMIT"
			GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "$COMMIT"^
		else
			git commit -m "$MESSAGE"
		fi
		git push origin HEAD $([ -n "$FORCE" ] && echo '--force-with-lease')
	fi
	unset USAGE COMMIT MESSAGE AMEND FORCE
}

glog() {
	setterm -linewrap off 2> /dev/null

	git --no-pager log --all --color=always --graph --abbrev-commit --decorate --date-order \
		--format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' "$@" \
		| sed -E \
			-e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─╮\2/' \
			-e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─╯\x1b\[m/' \
			-e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1╮\2/' \
			-e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├╯\x1b\[m/' \
			-e 's/╮(\x1b\[[0-9;]*m)+\\/╮\1╰╮/' \
			-e 's/╯(\x1b\[[0-9;]*m)+\//╯\1╭╯/' \
			-e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/╰╮\2/' \
			-e 's/(\x1b\[[0-9;]*m)\\/\1╮/g' \
			-e 's/(\x1b\[[0-9;]*m)\//\1╯/g' \
			-e 's/^\*|(\x1b\[m )\*/\1⎬/g' \
			-e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
		| command less -r $([ $# -eq 0 ] && echo "+/[^/]HEAD")

	setterm -linewrap on 2> /dev/null
}

find() {
	if [ $# = 1 ]
	then
		command find . -iname "*$@*"
	else
		command find "$@"
	fi
}
# Firefox Developer — caminho só existe no Linux.
[ -d /opt/firefox-developer/firefox ] && export PATH=/opt/firefox-developer/firefox:$PATH

# fzf (cross-platform)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Tema "Cinza + Verde Neon" — FZF_DEFAULT_OPTS (vale pra bash e zsh)
export FZF_DEFAULT_OPTS="
  --color=bg+:#1f1f1f,bg:-1,fg:#c8c8c8,fg+:#ffffff,hl:#39ff14,hl+:#39ff14
  --color=info:#8a8a8a,prompt:#39ff14,pointer:#39ff14,marker:#39ff14,spinner:#2bcc10,header:#8a8a8a,border:#3a3a3a
  --height=40% --layout=reverse --border"

unset _OS 2> /dev/null
