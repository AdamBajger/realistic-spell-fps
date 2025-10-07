@echo off
setlocal enabledelayedexpansion

set CRATE=%1
if "%CRATE%"=="" (
    echo Usage: build-rust-msvc.bat [client|server]
    exit /b 1
)

set VSTOOLS=C:\BuildTools
set VCVARS=%VSTOOLS%\VC\Auxiliary\Build\vcvarsall.bat

if not exist "%VCVARS%" (
    echo ERROR: vcvarsall.bat not found at %VCVARS%
    exit /b 1
)

echo Initializing MSVC environment from "%VCVARS%"
call "%VCVARS%" x64

rem --- Ensure Windows SDK lib path is visible to linker ---
for /d %%D in ("C:\Program Files (x86)\Windows Kits\10\Lib\*") do (
    if exist "%%D\um\x64\kernel32.lib" (
        set "SDK_LIB=%%D\um\x64"
        set "SDK_UCRT=%%D\ucrt\x64"
    )
)

if not defined SDK_LIB (
    echo ERROR: Could not find Windows 10 SDK libraries (kernel32.lib missing)
    dir "C:\Program Files (x86)\Windows Kits\10\Lib"
    exit /b 1
)

set "LIB=%SDK_LIB%;%SDK_UCRT%;%LIB%"
echo Using SDK LIB path: %SDK_LIB%

rem --- Build the crate ---
echo Building Rust crate %CRATE% (release)...
cargo build --release -p %CRATE% --no-default-features

if %errorlevel% neq 0 (
    echo ERROR: cargo build failed for %CRATE%
    exit /b 1
)

echo Build finished successfully for %CRATE%.
endlocal
