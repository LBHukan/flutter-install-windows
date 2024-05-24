# Verifique se o PowerShell é executado como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Error "Por favor, execute este script como administrador."
    exit
}

# Instale o Chocolatey (se ainda não estiver instalado)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
}

# Instale dependências
choco install -y git vscode

# Baixe o SDK do Flutter
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.22.1-stable.zip"
$flutterZipPath = "$env:TEMP\flutter_windows_3.10.5-stable.zip"
Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZipPath

# Extraia o SDK
Expand-Archive -Path $flutterZipPath -DestinationPath "C:\src\flutter"

# Adicione o Flutter ao PATH
[System.Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", [System.EnvironmentVariableTarget]::Machine)

# Verifique a instalação do Flutter
C:\src\flutter\bin\flutter doctor

Write-Output "Flutter instalado com sucesso."
