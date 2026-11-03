# Acesso ao homeserver pelo Windows

Arquivos para acessar o servidor caseiro (`homeserver`, Ubuntu) a partir de um PC Windows.

## Pré-requisito único: Tailscale

Instale o **Tailscale** e faça login com a **mesma conta** usada no servidor e no Mac.

- Download: <https://tailscale.com/download/windows>

Com o Tailscale ligado, o nome `homeserver` passa a funcionar de qualquer lugar (via MagicDNS) — é o que faz `http://homeserver:8080` e `ssh lippelt@homeserver` resolverem.

## Abrir o painel do AMP

- **`abrir-amp.bat`** — abre `http://homeserver:8080` (funciona em qualquer lugar, via Tailscale).
- **`abrir-amp-lan.bat`** — abre `http://192.168.0.100:8080` (só em casa, sem depender do Tailscale).

Ou simplesmente digite o endereço no navegador. O painel do AMP não precisa de chave SSH.

## Acessar por SSH (terminal)

- **`ssh-homeserver.bat`** — conecta via `ssh lippelt@homeserver`.

O SSH do servidor aceita **somente chave** (senha desativada), então este PC precisa ter a chave autorizada, uma vez só:

1. No PowerShell, gere a chave (Enter em tudo):
   ```powershell
   ssh-keygen -t ed25519
   ```
2. Mostre a chave **pública**:
   ```powershell
   type $env:USERPROFILE\.ssh\id_ed25519.pub
   ```
3. Essa chave pública precisa ser adicionada em `~/.ssh/authorized_keys` do servidor (feito a partir do Mac que já tem acesso).

O cliente SSH já vem no Windows 10/11. Para conferir, rode `ssh` no PowerShell.

## Dados do servidor

- Nome (Tailscale/MagicDNS): `homeserver`
- IP Tailscale: `100.125.82.104`
- IP rede local: `192.168.0.100`
- Usuário SSH: `lippelt`
- Painel AMP: porta `8080`
