Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Resolve the directory that contains the shared script library.
$Script:ScriptsRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Info {
    param([Parameter(Mandatory = $true)][string]$Message)
    # Print an informational progress message in a consistent format.
    Write-Host "[INFO] $Message"
}

function Write-Pass {
    param([Parameter(Mandatory = $true)][string]$Message)
    # Print a successful check result in a consistent format.
    Write-Host "[PASS] $Message"
}

function Write-Fail {
    param([Parameter(Mandatory = $true)][string]$Message)
    # Print a failure result and stop the current script.
    Write-Host "[FAIL] $Message"
    exit 1
}

function Require-Tool {
    param([Parameter(Mandatory = $true)][string]$Name)
    # Check whether the requested command is available on PATH.
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        Write-Fail "$Name is required but was not found on PATH"
    }
    Write-Pass "$Name is available"
}

function Invoke-CheckedCommand {
    param(
        [Parameter(Mandatory = $true)][string]$FailureMessage,
        [Parameter(Mandatory = $true)][scriptblock]$Command
    )
    # Run a native command and fail if Windows PowerShell leaves a non-zero exit code.
    & $Command
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "$FailureMessage (exit code $LASTEXITCODE)"
    }
}

function Get-RepoRoot {
    # Resolve the repository root from the scripts directory.
    return (Resolve-Path (Join-Path $Script:ScriptsRoot "..")).Path
}

function Get-JavaMajorVersion {
    # Capture Java's version output, which is written to stderr by the JVM.
    $versionOutput = (cmd /c "java -version 2>&1") -join [Environment]::NewLine
    # Parse modern Java version strings such as "21.0.11".
    if ($versionOutput -match 'version "([0-9]+)') {
        return [int]$Matches[1]
    }
    # Parse legacy Java version strings such as "1.8.0".
    if ($versionOutput -match 'version "1\.([0-9]+)') {
        return [int]$Matches[1]
    }
    return 0
}
