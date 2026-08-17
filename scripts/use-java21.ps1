Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Search the repo-managed JDK location first, then common system install paths.
$possibleRoots = @(
    (Join-Path $env:USERPROFILE ".sonali-intellect-tools\jdk-21"),
    "C:\Program Files\Eclipse Adoptium",
    "C:\Program Files\Java"
)

foreach ($root in $possibleRoots) {
    # Skip locations that do not exist on this laptop.
    if (-not (Test-Path -LiteralPath $root)) {
        continue
    }

    # Find the first Java 21 directory that contains a runnable java.exe.
    $jdk = Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match "21" -and (Test-Path -LiteralPath (Join-Path $_.FullName "bin\java.exe")) } |
        Sort-Object Name -Descending |
        Select-Object -First 1

    if ($jdk) {
        # Put Java 21 first on PATH for this PowerShell session.
        $javaBin = Join-Path $jdk.FullName "bin"
        $env:JAVA_HOME = $jdk.FullName
        $env:Path = "$javaBin;$env:Path"
        Write-Host "[INFO] Using Java 21 from $($jdk.FullName) for this PowerShell session"
        return
    }
}

Write-Host "[INFO] Java 21 was not found in the standard training locations."
