param(
    [switch]$InstallMissing,
    [switch]$TestAdoptiumMetadata
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

$wingetPackages = @{
    java    = "EclipseAdoptium.Temurin.21.JDK"
    mvn     = "Apache.Maven"
    docker  = "Docker.DockerDesktop"
    kubectl = "Kubernetes.kubectl"
    kind    = "Kubernetes.kind"
}

$chocoPackages = @{
    java    = "temurin21"
    mvn     = "maven"
    docker  = "docker-desktop"
    kubectl = "kubernetes-cli"
    kind    = "kind"
}

function Install-Tool {
    param(
        [Parameter(Mandatory = $true)][string]$ToolName,
        [Parameter(Mandatory = $true)][string]$PackageKey
    )

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        $packageId = $wingetPackages[$PackageKey]
        Write-Info "Installing $ToolName using winget package $packageId"
        winget install --id $packageId --exact --accept-package-agreements --accept-source-agreements
        return
    }

    $choco = Get-Command choco -ErrorAction SilentlyContinue
    if ($choco) {
        if (-not (Test-IsAdministrator)) {
            Write-Fail "Chocolatey installation requires an elevated PowerShell window. Reopen PowerShell with 'Run as Administrator' and rerun .\scripts\prerequisites.ps1 -InstallMissing"
        }

        $packageId = $chocoPackages[$PackageKey]
        Write-Info "Installing $ToolName using Chocolatey package $packageId"
        choco install $packageId -y
        return
    }

    Write-Fail "No supported package manager was found. Install winget from Microsoft App Installer, install Chocolatey, or install $ToolName manually."
}

function Refresh-PathFromRegistry {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Use-Java21IfInstalled {
    $possibleRoots = @(
        (Join-Path $env:USERPROFILE ".sonali-intellect-tools\jdk-21"),
        "C:\Program Files\Eclipse Adoptium",
        "C:\Program Files\Java"
    )

    foreach ($root in $possibleRoots) {
        if (-not (Test-Path -LiteralPath $root)) {
            continue
        }

        $jdk = Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match "21" -and (Test-Path -LiteralPath (Join-Path $_.FullName "bin\java.exe")) } |
            Sort-Object Name -Descending |
            Select-Object -First 1

        if ($jdk) {
            $env:JAVA_HOME = $jdk.FullName
            $env:Path = "$($jdk.FullName)\bin;$env:Path"
            Write-Info "Using Java 21 from $($jdk.FullName) for this PowerShell session"
            return
        }
    }
}

Use-Java21IfInstalled

function Get-AdoptiumJava21Package {
    $metadataUrl = "https://api.adoptium.net/v3/assets/feature_releases/21/ga?architecture=x64&image_type=jdk&jvm_impl=hotspot&os=windows&page=0&page_size=1&project=jdk&vendor=eclipse"

    Write-Info "Reading Java 21 release metadata from official Eclipse Adoptium API"
    $releaseMetadata = Invoke-RestMethod -Uri $metadataUrl
    $release = @($releaseMetadata)[0]
    if (-not $release -or -not $release.binaries -or -not $release.binaries[0].package.link -or -not $release.binaries[0].package.checksum) {
        Write-Fail "Eclipse Adoptium metadata did not include a Windows x64 JDK package link and checksum."
    }

    $package = $release.binaries[0].package
    return [pscustomobject]@{
        Link = [string]$package.link
        Checksum = ([string]$package.checksum).Trim().ToUpperInvariant()
        Release = [string]$release.release_name
    }
}

function Install-Java21FromAdoptium {
    $installRoot = if ($env:SI_TOOLS_HOME) { $env:SI_TOOLS_HOME } else { Join-Path $env:USERPROFILE ".sonali-intellect-tools" }
    $jdkRoot = Join-Path $installRoot "jdk-21"
    $downloadRoot = Join-Path $installRoot "downloads"

    New-Item -ItemType Directory -Force -Path $jdkRoot, $downloadRoot | Out-Null

    $adoptiumPackage = Get-AdoptiumJava21Package
    $downloadUrl = $adoptiumPackage.Link
    $expectedHash = $adoptiumPackage.Checksum
    $archivePath = Join-Path $downloadRoot ([System.IO.Path]::GetFileName(([Uri]$downloadUrl).AbsolutePath))

    Write-Info "Downloading Java 21 archive from Eclipse Adoptium"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath

    Write-Info "Verifying SHA-256 checksum from Eclipse Adoptium metadata"
    $actualHash = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToUpperInvariant()

    if ($actualHash -ne $expectedHash) {
        Remove-Item -LiteralPath $archivePath -Force -ErrorAction SilentlyContinue
        Write-Fail "Downloaded Java archive checksum mismatch. Expected $expectedHash but got $actualHash."
    }
    Write-Pass "Java 21 download checksum verified"

    Write-Info "Extracting Java 21 to $jdkRoot"
    Get-ChildItem -LiteralPath $jdkRoot -Force | Remove-Item -Recurse -Force
    Expand-Archive -LiteralPath $archivePath -DestinationPath $jdkRoot -Force

    $extractedJdk = Get-ChildItem -LiteralPath $jdkRoot -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "bin\java.exe") } |
        Select-Object -First 1

    if (-not $extractedJdk) {
        Write-Fail "Java 21 archive extracted, but bin\java.exe was not found."
    }

    $javaHome = $extractedJdk.FullName
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $javaBin = "$javaHome\bin"
    if (-not (($userPath -split ";") -contains $javaBin)) {
        [Environment]::SetEnvironmentVariable("Path", "$javaBin;$userPath", "User")
    }

    $env:JAVA_HOME = $javaHome
    $env:Path = "$javaBin;$env:Path"
    Write-Pass "Java 21 installed from Eclipse Adoptium at $javaHome"
}

if ($TestAdoptiumMetadata) {
    $adoptiumPackage = Get-AdoptiumJava21Package
    Write-Pass "Adoptium metadata resolved release $($adoptiumPackage.Release)"
    Write-Host "Download: $($adoptiumPackage.Link)"
    Write-Host "SHA256: $($adoptiumPackage.Checksum)"
    exit 0
}

foreach ($tool in @("java", "mvn", "docker", "kubectl", "kind")) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Pass "$tool is available"
        continue
    }

    if (-not $InstallMissing) {
        Write-Fail "$tool is required but was not found on PATH. Re-run with -InstallMissing to install supported tools with winget or Chocolatey."
    }

    if ($tool -eq "java") {
        Install-Java21FromAdoptium
        Use-Java21IfInstalled
    }
    else {
        Install-Tool -ToolName $tool -PackageKey $tool
        Refresh-PathFromRegistry
    }

    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        Write-Pass "$tool is available after installation"
    }
    else {
        Write-Fail "$tool was installed or queued, but is not available in this PowerShell session yet. Open a new PowerShell window and rerun .\scripts\prerequisites.ps1"
    }
}

$javaMajor = Get-JavaMajorVersion
if ($javaMajor -lt 21) {
    if (-not $InstallMissing) {
        Write-Fail "Java 21 or newer is required. Current Java major version is $javaMajor. Re-run with -InstallMissing to download Temurin JDK 21 from the official Eclipse Adoptium API."
    }

    Install-Java21FromAdoptium
    Use-Java21IfInstalled
    $javaMajor = Get-JavaMajorVersion
    if ($javaMajor -lt 21) {
        Write-Fail "Java 21 was installed or queued, but the active Java version is still $javaMajor. Open a new PowerShell window and rerun .\scripts\prerequisites.ps1"
    }
}
Write-Pass "Java $javaMajor is available"

try {
    docker info *> $null
    Write-Pass "Docker daemon is reachable"
}
catch {
    Write-Fail "Docker daemon is not reachable. Start Docker Desktop and retry. If Docker Desktop was just installed, finish its setup first."
}
