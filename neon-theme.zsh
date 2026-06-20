# ============================================================================
# Tema "Cinza + Verde Neon" — pensado pra FUNDO ESCURO (dark terminal).
# ============================================================================
# Sourced no fim do ~/.zshrc, então sobrescreve qualquer cor definida antes.
#
# Princípios de legibilidade em fundo escuro:
#  - Verde-neon (#39ff14) só em destaque/acento (alto contraste no escuro).
#  - Texto cinza CLARO (#c8c8c8) — nunca cinza escuro sobre fundo escuro.
#  - Fundos de segmento em cinza ESCURO (#2a2a2a / #1f1f1f), texto claro/neon.
#  - Sem combinação escuro-sobre-escuro.
#
# Requer terminal truecolor (iTerm2, ou Terminal.app recente). Em terminal de
# 256 cores os hex caem no tom aproximado mais próximo — ainda legível.

# Paleta -----------------------------------------------------------------------
_NEON='#39ff14'      # verde neon — acento principal
_NEON_DIM='#2bcc10'  # verde neon mais fechado (estados secundários)
_FG='#c8c8c8'        # cinza claro — texto padrão (legível no escuro)
_FG_DIM='#8a8a8a'    # cinza médio — texto secundário/dim
_BG1='#2a2a2a'       # cinza escuro — fundo de segmento
_BG2='#1f1f1f'       # cinza mais escuro — fundo de segmento alternativo
_WARN='#ffb000'      # âmbar — avisos (modificado/untracked), legível no escuro
_DANGER='#ff5f5f'    # vermelho claro — perigo (root/erro), legível no escuro

# ---------------------------------------------------------------------------
# Powerlevel10k: as cores do prompt vêm do ~/.p10k.zsh (já recolorido pro
# tema cinza + verde neon por tools/recolor-p10k.mjs). Nada de override aqui
# pra não conflitar com aquele arquivo.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Prompt de fallback (TTY puro / sem powerlevel10k) — mantém verde neon
# ---------------------------------------------------------------------------
if [[ $(tty) = /dev/tty* ]]; then
	PROMPT=$'%F{%(#.red.green)}┌──(%B%F{%(#.red.green)}%n@%m%b%F{green})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n└─%B%(#.%F{red}#.%F{green}$)%b%F{reset} '
fi

# ---------------------------------------------------------------------------
# zsh-autosuggestions — sugestão em cinza médio (dim, mas ainda visível)
# ---------------------------------------------------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$_FG_DIM"

# ---------------------------------------------------------------------------
# zsh-syntax-highlighting — acentos em verde neon, base em cinza claro
# (só sobrescreve se o highlighter já tiver sido carregado)
# ---------------------------------------------------------------------------
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
	ZSH_HIGHLIGHT_STYLES[default]="fg=$_FG"
	ZSH_HIGHLIGHT_STYLES[arg0]="fg=$_NEON"
	ZSH_HIGHLIGHT_STYLES[precommand]="fg=$_NEON,underline"
	ZSH_HIGHLIGHT_STYLES[autodirectory]="fg=$_NEON,underline"
	ZSH_HIGHLIGHT_STYLES[suffix-alias]="fg=$_NEON,underline"
	ZSH_HIGHLIGHT_STYLES[precommand]="fg=$_NEON,underline"
	ZSH_HIGHLIGHT_STYLES[path]="fg=$_FG,underline"
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=$_WARN"
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=$_WARN"
	ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]="fg=$_NEON_DIM"
	ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$_DANGER,bold"
fi

# ---------------------------------------------------------------------------
# Cores de `ls`
#   GNU (gls / Linux): LS_COLORS — diretórios em verde neon-ish.
#   BSD (macOS `ls -G`): LSCOLORS — 'C' = verde bold; fundo default.
# ---------------------------------------------------------------------------
export LS_COLORS="di=1;38;5;46:ln=1;38;5;48:ex=38;5;46:fi=0:*.tar=38;5;208:*.zip=38;5;208"
# BSD: di=verde-bold(C), ln=verde-bold(C), so/pi/etc. neutros, ex=verde-bold(C)
export LSCOLORS="CxCxxxxxxxxxxxxxCxCx"

# ---------------------------------------------------------------------------
# fzf — fundo transparente, destaques em verde neon, texto cinza claro
# ---------------------------------------------------------------------------
export FZF_DEFAULT_OPTS="
  --color=bg+:$_BG2,bg:-1,fg:$_FG,fg+:#ffffff,hl:$_NEON,hl+:$_NEON
  --color=info:$_FG_DIM,prompt:$_NEON,pointer:$_NEON,marker:$_NEON,spinner:$_NEON_DIM,header:$_FG_DIM,border:#3a3a3a
  --height=40% --layout=reverse --border"

# ---------------------------------------------------------------------------
# man pages coloridas — títulos em verde neon, ênfase em cinza claro
# ---------------------------------------------------------------------------
export LESS_TERMCAP_mb=$'\e[1;38;5;46m'   # início de piscar → verde neon
export LESS_TERMCAP_md=$'\e[1;38;5;46m'   # negrito → verde neon
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;38;5;240;48;5;236m'  # status bar: cinza
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;38;5;250m'  # sublinhado → cinza claro

unset _NEON _NEON_DIM _FG _FG_DIM _BG1 _BG2 _WARN _DANGER
