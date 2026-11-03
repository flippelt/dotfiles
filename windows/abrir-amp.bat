@echo off
REM Abre o painel do AMP no navegador padrao.
REM Requer Tailscale instalado e logado (para o nome "homeserver" resolver).
start "" "http://homeserver:8080"
