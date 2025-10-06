# build-rust-msvc.ps1
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("client","server")]
    [string]$Crate
)

$vsTools = 'C:\BuildTools'
$vcvarsPath = Join-Path $vsTools 'VC\Auxiliary\Build\vcvarsall.bat'

if (-Not (Test-Path $vcvarsPath)) {
    throw "VC environment script not found: $vcvarsPath"
}

Write-Host "Initializing MSVC environment from $vcvarsPath"
# Call vcvarsall.bat in the current session
& $vcvarsPath 'x64'

Write-Host "Building Rust crate '$Crate' in release mode..."
cargo build --release -p $Crate --no-default-features

Write-Host "Build finished for '$Crate'."
