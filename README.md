# ~/.dotfiles

My personal configuration files (zsh, bash, git, fzf, Powerlevel10k).

**Cross-platform**: detect the OS via `uname` and adapt — Homebrew + `pbcopy` +
`ls -G`/coreutils on macOS, `/usr/share` + `xclip` + `ls --color` on Linux.

## Theme — Gray + Neon Green (dark background)

The shell, prompt, `fzf`, `ls`, `man` pages and `git` output share a **gray +
neon green** palette tuned for **dark terminals**: neon green (`#39ff14`) for
accents, light gray (`#c8c8c8`) for text, dark gray segment backgrounds. It
lives isolated in [`neon-theme.zsh`](neon-theme.zsh) (sourced last in `.zshrc`,
so it overrides everything) — comment the `source` lines to disable.

## Setup

- **macOS** (MacBook Pro 2020 / macOS Tahoe): see [`SETUP-macos.md`](SETUP-macos.md).
- **Linux**: symlink the dotfiles into `$HOME`; install `zsh-autosuggestions`,
  `zsh-syntax-highlighting`, `powerlevel10k` (oh-my-zsh custom or distro pkg),
  `fzf`. Switch `git`'s `credential.helper` to `cache --timeout=3600`.

## Files

| File | What |
|---|---|
| `.zshrc` | main zsh config (aliases, history, completion, plugins, prompt) |
| `.bashrc` | bash equivalent |
| `.profile` | login-shell PATH + (Linux) xrandr modes, guarded per-OS |
| `.gitconfig` | user, colored output (gray+neon theme), editor |
| `.fzf.zsh` / `.fzf.bash` | fzf loader (Homebrew / `~/.fzf` / distro) |
| `neon-theme.zsh` | the Gray + Neon Green color theme |
| `.p10k.zsh` | Powerlevel10k prompt (classic powerline), recolored to the neon theme — sourced by `.zshrc` |
| `tools/recolor-p10k.mjs` | remaps `.p10k.zsh` colors to the Gray + Neon Green palette |
