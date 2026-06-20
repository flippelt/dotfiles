# Configure color-scheme
COLOR_SCHEME=dark # dark/light

# Detecta o SO uma vez (usado em vários pontos abaixo).
# _OS = 'macos' | 'linux'
case "$(uname -s)" in
	Darwin) _OS=macos ;;
	*)      _OS=linux ;;
esac

# ------------------------------- macOS / Homebrew ----------------------------
# Carrega o Homebrew (resolve PATH/MANPATH). Cobre Apple Silicon (/opt/homebrew)
# e Intel (/usr/local) — o MacBook Pro 2020 13" pode ser qualquer um dos dois.
if [ "$_OS" = macos ]; then
	if [ -x /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [ -x /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi

# --------------------------------- ALIASES -----------------------------------
#alias ..='cd ..'
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

### Clipboard (cross-platform): `clip`/`paste` em qualquer SO
if [ "$_OS" = macos ]; then
	alias clip='pbcopy'
	alias paste='pbpaste'
	alias xclip='pbcopy'           # mantém o hábito do Linux funcionando
elif command -v xclip > /dev/null; then
	alias clip='xclip -selection clipboard'
	alias paste='xclip -selection clipboard -o'
	alias xclip='xclip -selection c'
fi

### Colorize commands (GNU usa --color; BSD/macOS usa -G + CLICOLOR)
if [ "$_OS" = macos ] && command -v gls > /dev/null; then
	# coreutils GNU via Homebrew (brew install coreutils)
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
# `diff --color` e `ip --color` só existem no GNU/Linux.
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
#	alias less='bat'
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

### GIT, GITHUB, HUB
# alias git=hub

# --------------------------------- SETTINGS ----------------------------------
setopt AUTO_CD
setopt BEEP
#setopt CORRECT
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST
setopt NO_NO_MATCH
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PROMPT_SUBST
setopt SHARE_HISTORY

HISTFILE=~/.zsh_history
HIST_STAMPS=mm/dd/yyyy
HISTSIZE=5000
SAVEHIST=5000
ZLE_RPROMPT_INDENT=0
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'


# ZSH completion system
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Key bindings
#bindkey -e
# bindkey '^U' backward-kill-line
# bindkey '^[[2~' overwrite-mode
# bindkey '^[[3~' delete-char
# bindkey '^[[H' beginning-of-line
# bindkey '^[[1~' beginning-of-line
# bindkey '^[[F' end-of-line
# bindkey '^[[4~' end-of-line
# bindkey '^[[1;5C' forward-word
# bindkey '^[[1;5D' backward-word
# bindkey '^[[3;5~' kill-word
# bindkey '^[[5~' beginning-of-buffer-or-history
# bindkey '^[[6~' end-of-buffer-or-history
# bindkey '^[[Z' undo
# bindkey ' ' magic-space

# Prompt
# Prompt de fallback (quando o powerlevel10k não está ativo).
#  = tubo de ensaio (nf-fa-flask) antes do usuário;
#  = casinha (nf-fa-home) no lugar do hostname. Requer Nerd Font.
PROMPT=$'%F{%(#.red.green)}┌──(%B%F{%(#.red.green)} %n %F{%(#.red.green)}%b%F{%(#.red.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.red.green)}]\n└─%B%(#.%F{red}#.%F{green}$)%b%F{reset} '
RPROMPT=$'%(?.. %? %F{red}%Bx%b%F{reset})%(1j. %j %F{yellow}%Bbg %b%F{reset}.)'

# ----------------------------------- MISC -----------------------------------
export VISUAL=vim
export EDITOR=$VISUAL

# enable terminal linewrap
setterm -linewrap on 2> /dev/null

# colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESSHISTFILE=-

# colorize ls
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	precmd() { print -Pnr -- $'\e]0;%n@%m: %~\a' }
	;;
esac

# ------------------------------- ZSH PLUGINS ---------------------------------
# Plugin source helper
_source_plugin() {
	local plugin_name="$1"
	# Homebrew (macOS) instala em $(brew --prefix)/share/<plugin>/<plugin>.zsh;
	# Linux (Arch/Debian) usa /usr/share; oh-my-zsh custom também é coberto.
	local brew_share=""
	command -v brew > /dev/null && brew_share="$(brew --prefix)/share"
	for basedir in ~/.oh-my-zsh/custom/plugins "$brew_share" /usr/share /opt/homebrew/share /usr/local/share
	do
		[ -z "$basedir" ] && continue
		plugin="$basedir/$plugin_name/$plugin_name.zsh"
		[ -f "$plugin" ] && source "$plugin" && return 0
	done
	echo "\033[33m[ ! ]\033[0m ZSH ${plugin_name#zsh-} not installed"
	return 1
}

# ZSH Autosuggestions
_source_plugin zsh-autosuggestions && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'

# ZSH Syntax Highlighting
if _source_plugin zsh-syntax-highlighting
then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
	ZSH_HIGHLIGHT_STYLES[default]=none
	ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
	ZSH_HIGHLIGHT_STYLES[path]=underline
	ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
	ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[command-substitution]=none
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[process-substitution]=none
	ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[assign]=none
	ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
	ZSH_HIGHLIGHT_STYLES[named-fd]=none
	ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
	ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
	ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
	ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
	ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
fi

unset -f _source_plugin

# POWERLEVEL
# Resolve o powerlevel10k em oh-my-zsh (Linux) ou Homebrew (macOS).
_p10k_theme=""
for _cand in \
	~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme \
	"$(command -v brew > /dev/null && echo "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme")" \
	/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme \
	/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
do
	[ -n "$_cand" ] && [ -f "$_cand" ] && _p10k_theme="$_cand" && break
done
if ! [[ $(tty) = /dev/tty* ]]
then
	if [ -n "$_p10k_theme" ] && source "$_p10k_theme" 2> /dev/null
	then
		# Usa a config completa do wizard (~/.p10k.zsh) — layout classic
		# (os_icon, dir, vcs/branch, status, exec time, time, battery, context),
		# recolorida pro tema cinza + verde neon (tools/recolor-p10k.mjs).
		[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
	else
		echo '\033[33m[ ! ]\033[0m ZSH powerlevel10k not installed'
	fi
else
	clear
	echo
	echo
fi


switch_powerlevel_multiline_prompt(){
	[ $POWERLEVEL9K_PROMPT_ON_NEWLINE = true ] \
		&& POWERLEVEL9K_PROMPT_ON_NEWLINE=false \
		|| POWERLEVEL9K_PROMPT_ON_NEWLINE=true

	zle && zle accept-line
}
zle -N switch_powerlevel_multiline_prompt
bindkey ^P switch_powerlevel_multiline_prompt


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
				break
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

export NVM_DIR="$HOME/.nvm"
# nvm manual (~/.nvm) ou via Homebrew ($(brew --prefix nvm)).
if [ -s "$NVM_DIR/nvm.sh" ]; then
	\. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
elif command -v brew > /dev/null && [ -s "$(brew --prefix nvm 2>/dev/null)/nvm.sh" ]; then
	\. "$(brew --prefix nvm)/nvm.sh"
fi

# Linuxbrew (só Linux) — no macOS o Homebrew já foi carregado no topo via shellenv.
if [ "$_OS" = linux ] && [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Tema "Cinza + Verde Neon" — por último pra sobrescrever cores anteriores.
[ -f ~/.config/neon-theme.zsh ] && source ~/.config/neon-theme.zsh
[ -f ~/neon-theme.zsh ] && source ~/neon-theme.zsh

unset _OS _p10k_theme _cand 2> /dev/null