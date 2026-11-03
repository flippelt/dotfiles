@echo off
title homeserver
REM Conecta via SSH ao homeserver (pelo Tailscale, de qualquer lugar).
REM Requer: Tailscale logado + chave SSH deste PC autorizada no servidor.
ssh lippelt@homeserver
echo.
echo (Sessao encerrada. Feche a janela ou pressione uma tecla.)
pause >nul
