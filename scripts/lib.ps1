Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$Script:ScriptsRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Info {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[INFO] $Message"
}

function Write-Pass {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[PASS] $Message"
}

function Write-Fail {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host "[FAIL] $Message"
    exit 1
}

function Require-Tool {
    param([Parameter(Mandatory = $true)][string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Fail "$Name is required but was not found on PATH"
    }
    Write-Pass "$Name is available"
}

function Get-RepoRoot {
    return (Resolve-Path (Join-Path $Script:ScriptsRoot "..")).Path
}

function Get-JavaMajorVersion {
    $versionOutput = (cmd /c "java -version 2>&1") -join [Environment]::NewLine
    if ($versionOutput -match 'version "([0-9]+)') {
        return [int]$Matches[1]
    }
    if ($versionOutput -match 'version "1\.([0-9]+)') {
        return [int]$Matches[1]
    }
    return 0
}
