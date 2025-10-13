param (
    [Parameter(Mandatory=$false)]
    [switch]$Help,

    [Parameter(Mandatory=$false)]
    [string]$KeyID,

    [Parameter(Mandatory=$false)]
    [switch]$Global,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

function Show-Help {
    Write-Output @"
Usage: .\setup-gpg-signing.ps1 -KeyID <KEY_ID> [-Global] [-DryRun] [-Help]

Parameters:
    -KeyID   (Required) The GPG key ID to use for signing commits.
    -Global  (Optional) Apply the configuration globally. If not specified, configuration is applied locally.
    -DryRun  (Optional) Show the configuration values that would be used without applying them.
    -Help    (Optional) Display this help message.
"@
}

# Display help message if --help or -h is provided
if ($Help) {
    Show-Help
    exit 0
}

# Ensure KeyID is provided if not displaying help
if (-not $KeyID -and -not $Help) {
    Write-Error "KeyID is required unless --help or -h is specified."
    exit 1
}

# Determine the scope (global or local)
$scope = if ($Global.IsPresent) { "--global" } else { "--local" }

# Check if Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed."
    exit 1
}

# Locate gpg.exe using where.exe command
try {
    $gpgPath = & where.exe gpg | Select-Object -First 1
    if (-not $gpgPath) {
        Write-Error "GPG is not installed or not found in the system PATH."
        exit 1
    }
} catch {
    Write-Error "Error locating gpg.exe: $($_)"
    exit 1
}

# Retrieve the email associated with the GPG key
try {
    $uid = gpg --list-keys --with-colons $KeyID | Select-String -Pattern "^uid" | ForEach-Object { $_.ToString().Split(':')[9] } | Select-Object -First 1
    $email = [regex]::Match($uid, "<(.+?)>").Groups[1].Value
    if (-not $email) {
        Write-Error "No email address found for key ID ${KeyID}."
        exit 1
    }
} catch {
    Write-Error "Error retrieving email address for key ID ${KeyID}: $($_)"
    exit 1
}

# Variables for git config
$userSigningKeyConfig = "user.signingkey ${KeyID}!"
$userEmailConfig = "user.email ${email}"
$commitGpgSignConfig = "commit.gpgSign true"
$gpgProgramConfig = "gpg.program ${gpgPath}"

# Dry run option
if ($DryRun) {
    Write-Output "Dry Run: The following configurations would be applied:"
    Write-Output $userSigningKeyConfig
    Write-Output $userEmailConfig
    Write-Output $commitGpgSignConfig
    Write-Output $gpgProgramConfig
    exit 0
}

# Configure Git for GPG signing
try {
    git config $scope user.signingkey "${KeyID}!"
    git config $scope user.email $email
    git config $scope commit.gpgSign true
    git config $scope gpg.program $gpgPath
    Write-Output "GPG signing configured with key ID ${KeyID} and email ${email} ($scope)."
} catch {
    Write-Error "Error configuring Git for GPG signing: $($_)"
    exit 1
}
