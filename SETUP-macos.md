# Setup — macOS (MacBook Pro 2020 · macOS Tahoe 26.5.1)

Guia de configuração destes dotfiles num MacBook Pro 2020 rodando macOS Tahoe
26.5.1, com o tema **Cinza + Verde Neon** legível em fundo escuro.

Os dotfiles são **cross-platform**: detectam o SO (`uname`) e se adaptam ao
macOS (Homebrew, `pbcopy`, `ls -G`/coreutils) sem quebrar no Linux.

> **Intel vs Apple Silicon** — o MacBook Pro 2020 13" existe em duas versões: a
> de início de 2020 é **Intel** (Homebrew em `/usr/local`), a de fim de 2020 é
> **M1/Apple Silicon** (Homebrew em `/opt/homebrew`). O `.zshrc` cobre os dois
> automaticamente — você não precisa escolher.

---

## 1. Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ao terminar, ele mostra um comando `eval "$(.../brew shellenv)"`. Não precisa
copiar manualmente — o `.zshrc`/`.bashrc` já fazem esse `shellenv` no boot.

## 2. Pacotes

> ⚠️ **Cole as linhas SEM comentário** (nada de `#` na mesma linha). O zsh
> padrão do macOS não tem `interactive_comments` ligado até o `.zshrc` novo
> carregar — comentário colado vira erro (`command not found`, `too many
> arguments` ou `unknown sort specifier`).

Prompt + plugins de shell:

```sh
brew install powerlevel10k zsh-autosuggestions zsh-syntax-highlighting
```

Ferramentas de linha de comando:

```sh
brew install fzf bat lsd git coreutils
```

Key-bindings e auto-completion do fzf:

```sh
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
```

- `coreutils` traz o `gls`/`gdircolors` (GNU) — o `.zshrc` usa `gls` se existir
  pra `ls` colorido idêntico ao do Linux; sem ele, cai no `ls -G` (BSD) que
  também respeita o tema.
- `bat` e `lsd` são opcionais (o `.zshrc` só usa se estiverem instalados).

## 3. Fonte (ícones do Powerlevel10k)

O prompt usa ícones Nerd Font. Instale a fonte recomendada:

```sh
brew install --cask font-meslo-lg-nerd-font
```

Depois selecione **MesloLGS NF** como fonte do seu terminal (passo 6).

## 4. Instalar os dotfiles

Entre na pasta onde você clonou os dotfiles (ajuste o caminho ao seu clone —
sem comentário na linha):

```sh
cd ~/Documents/Code/dotfiles
```

Crie um backup dos seus dotfiles atuais (se existirem) antes de sobrescrever:

```sh
for f in .zshrc .bashrc .profile .gitconfig .fzf.zsh .fzf.bash; do [ -e "$HOME/$f" ] && ! [ -L "$HOME/$f" ] && cp "$HOME/$f" "$HOME/$f.bak"; done
```

Crie os links simbólicos no `$HOME`:

```sh
for f in .zshrc .bashrc .profile .gitconfig .fzf.zsh .fzf.bash; do ln -sf "$PWD/$f" "$HOME/$f"; done
```

Linke o tema (o `.zshrc` procura tanto em `~` quanto em `~/.config`):

```sh
mkdir -p ~/.config
ln -sf "$PWD/neon-theme.zsh" "$HOME/.config/neon-theme.zsh"
```

> Se preferir copiar em vez de linkar, troque `ln -sf` por `cp`. Linkar é melhor
> pra puxar atualizações com `git pull` sem recopiar.

Recarregue: `exec zsh` (ou feche e reabra o terminal). A partir daqui o
`interactive_comments` está ligado e comentários colados não dão mais erro.

## 5. Git — credenciais

O `.gitconfig` usa `credential.helper = osxkeychain` (Keychain do macOS, nativo,
mais seguro que cache em disco). Nada a instalar. Confirme:

```sh
git config --get credential.helper
```

Deve imprimir `osxkeychain`. (No Linux, troque pra `helper = cache --timeout=3600`.)

## 6. Terminal — cores e truecolor

O tema usa cores **truecolor** (hex `#39ff14` etc.). Funciona melhor no
**iTerm2**; o Terminal.app recente também serve.

```sh
brew install --cask iterm2
```

(opcional, mas recomendado)

**Fundo escuro é obrigatório** pro tema ser legível. Configure no terminal:

| Item | Valor |
|---|---|
| Fonte | MesloLGS NF, 13–14pt |
| Background | `#121212` (quase preto) |
| Foreground | `#c8c8c8` (cinza claro) |
| Cursor | `#39ff14` (verde neon) |
| Selection | `#2a2a2a` |

Paleta ANSI sugerida (16 cores) — mantém o visual cinza + verde neon:

| ANSI | Cor | Hex |
|---|---|---|
| 0 black / 8 br-black | cinzas | `#1c1c1c` / `#6e6e6e` |
| 1 red / 9 br-red | perigo | `#ff5f5f` |
| 2 green / 10 br-green | **verde neon** | `#39ff14` / `#5cff8f` |
| 3 yellow / 11 br-yellow | âmbar | `#ffb000` |
| 4 blue / 12 br-blue | cinza-azulado | `#7c8a99` |
| 5 magenta / 13 | magenta suave | `#b585d0` |
| 6 cyan / 14 | verde-água | `#3ad6a0` |
| 7 white / 15 br-white | cinza claro / branco | `#c8c8c8` / `#ffffff` |

> No iTerm2: **Settings → Profiles → Colors** (ajuste manual) e **Text** pra
> fonte. No Terminal.app: **Settings → Profiles**, duplique um perfil escuro
> (ex.: "Pro") e ajuste background/fonte.

## 7. Verificação

Abra um terminal novo e rode (uma de cada vez):

```sh
uname -s
brew --prefix
ls
echo $FZF_DEFAULT_OPTS
```

Esperado:

- `uname -s` → `Darwin`
- `brew --prefix` → `/opt/homebrew` (Apple Silicon) ou `/usr/local` (Intel)
- `ls` → diretórios em verde neon
- `echo $FZF_DEFAULT_OPTS` → contém as cores `#39ff14`
- Prompt em duas linhas com bordas verde-neon e segmentos cinza escuro ✓
- `Ctrl-R` abre o histórico no fzf com destaque verde neon ✓
- `man ls` com títulos em verde neon ✓

## 8. Troubleshooting

- **Ícones quebrados (□) no prompt** → a fonte do terminal não é a Nerd Font.
  Selecione MesloLGS NF (passo 3/6).
- **`ZSH ... not installed`** no boot → o plugin não foi achado. Confirme
  `brew list | grep zsh-` e que o `brew shellenv` rodou (abra terminal novo).
- **Cores "lavadas"/erradas** → terminal sem truecolor. Use iTerm2, ou aceite o
  fallback de 256 cores (ainda legível).
- **`ls` reclama de `--color`** → você está sem `coreutils` E o branch BSD não
  pegou; rode `brew install coreutils` ou confirme que está no `.zshrc` novo.
- **Powerlevel10k não aparece** → `brew install powerlevel10k` e reabra o
  terminal. O `.zshrc` resolve o caminho do tema via `brew --prefix`.

## Notas

- `~/.p10k.zsh` (no repo) é um config antigo do assistente do p10k e **não** é
  carregado por este `.zshrc` (que configura o prompt inline + `neon-theme.zsh`).
  Deixe quieto, ou rode `p10k configure` se quiser regerar do zero.
- O tema é isolado em `neon-theme.zsh` — pra desligar, comente as linhas de
  `source` no fim do `.zshrc`.
