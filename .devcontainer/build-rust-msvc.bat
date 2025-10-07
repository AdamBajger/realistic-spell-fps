@echo off
REM build-rust-msvc.bat client|server

if "%~1"=="" (
  echo Usage: build-rust-msvc.bat client^|server
  exit /b 1
)
set "CRATE=%~1"

set "VSTOOLS=C:\BuildTools"
set "VCVARS=%VSTOOLS%\VC\Auxiliary\Build\vcvarsall.bat"

if not exist "%VCVARS%" (
  echo ERROR: vcvarsall.bat not found at "%VCVARS%"
  exit /b 1
)

echo Initializing MSVC environment from "%VCVARS%"
call "%VCVARS%" x64
if %errorlevel% neq 0 (
  echo ERROR: vcvarsall.bat failed
  exit /b 1
)

echo Building Rust crate %CRATE% (release)...
cargo build --release -p %CRATE% --no-default-features
if %errorlevel% neq 0 (
  echo ERROR: cargo build failed for %CRATE%
  exit /b 1
)

echo Build finished successfully for %CRATE%.
exit /b 0
