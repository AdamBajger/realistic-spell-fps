@echo off
REM Windows Container Build Script
REM
REM This script runs inside the Windows base builder container.
REM It builds the binaries and runs tests with the workspace mounted at C:\workspace.
REM
REM Expected environment:
REM   - Workspace mounted at C:\workspace
REM   - Running inside base-builder-windows container
REM   - Outputs binaries to C:\workspace\target\release\
REM

SET RELEASE_DIR=C:\workspace\target\release
SET OUTPUT_DIR=C:\build


echo === Container Build Script for Windows ===
echo Working directory: %CD%
rustc --version
cargo --version
echo.

REM Build server binary
echo === Building server binary ===
cargo build --release -p server --no-default-features --target-dir %OUTPUT_DIR%
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.

REM Build client binary
echo === Building client binary ===
cargo build --release -p client --no-default-features --target-dir %OUTPUT_DIR%
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.

REM Verify binaries exist
echo === Verifying binaries ===
dir target\release\server.exe
dir target\release\client.exe
echo.

REM Run tests
echo === Running tests ===
cargo test --workspace --verbose --no-fail-fast --no-default-features --target-dir %OUTPUT_DIR%
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.

REM Check formatting
echo === Checking formatting ===
cargo fmt --all -- --check
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
echo.

REM Run clippy (continue on error)
echo === Running clippy ===
cargo clippy --workspace --all-targets --no-default-features -- -D warnings
echo.

REM copy build artifacts to release directory
if not exist %RELEASE_DIR% mkdir %RELEASE_DIR%
copy %OUTPUT_DIR%\release\server.exe %RELEASE_DIR%\
copy %OUTPUT_DIR%\release\client.exe %RELEASE_DIR%\

echo === Build complete! ===
echo Binaries available at:
echo   - C:\workspace\target\release\server.exe
echo   - C:\workspace\target\release\client.exe
