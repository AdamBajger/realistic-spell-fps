param (
    [Parameter(Mandatory=$false)]
    [switch]$Help,

    [Parameter(Mandatory=$false)]
    [string]$KeyID,

    [Parameter(Mandatory=$false)]
    [string]$Email,

    [Parameter(Mandatory=$false)]
    [switch]$Global,

    [Parameter(Mandatory=$false)]
    [switch]$DryRun
)

function Show-Help {
    Write-Output @"
Usage: .\setup-gpg-signing.ps1 -KeyID <KEY_ID> [-Email <EMAIL>] [-Global] [-DryRun] [-Help]

Parameters:
    -KeyID   (Required) The GPG key ID to use for signing commits.
    -Email   (Optional) The email to use. If not specified, will infer from GPG key or git config.
    -Global  (Optional) Apply the configuration globally. If not specified, configuration is applied locally.
    -DryRun  (Optional) Show the configuration values that would be used without applying them.
    -Help    (Optional) Display this help message.
"@
}

if ($Help) { Show-Help; exit 0 }

if (-not $KeyID) {
    Write-Error "KeyID is required unless --help is specified."
    exit 1
}

$scope = if ($Global.IsPresent) { "--global" } else { "--local" }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not in PATH."
    exit 1
}

try {
    $gpgPath = & where.exe gpg | Select-Object -First 1
    if (-not $gpgPath) { throw "GPG not found in PATH." }
} catch {
    Write-Error "Error locating gpg.exe: $_"
    exit 1
}

# --- Extract emails from GPG key ---
try {
    $uids = gpg --list-keys --with-colons $KeyID | Select-String '^uid' | ForEach-Object { $_.ToString().Split(':')[9] }

    $emailsInKey = @()
    foreach ($uid in $uids) {
        # Extract email using regex
        $emailMatch = [regex]::Match($uid, '<([^>]+)>')
        if ($emailMatch.Success) {
            $emailsInKey += $emailMatch.Groups[1].Value
        } else {
            Write-Output "No email found in UID: ${uid}"
        }
    }

    if ($emailsInKey.Count -eq 0) {
        throw "No emails found for key $KeyID."
    }

    Write-Output "$($emailsInKey.Count) emails associated with key ${KeyID}: $($emailsInKey -join ', ')"
} catch {
    Write-Error "Error retrieving emails for key ${KeyID}: $_"
    exit 1
}

# --- Determine which email to use ---
$emailToUse = $null

if ($Email) {
    if ($emailsInKey -notcontains $Email) {
        Write-Error "The specified email '$Email' is not listed in the GPG key. Available emails: $($emailsInKey -join ', ')"
        exit 1
    }
    $emailToUse = $Email
} else {
    if ($emailsInKey.Count -eq 1) {
        $emailToUse = $emailsInKey[0]
        Write-Output "Using the only email listed for this key: $emailToUse"
    } else {
        try {
            $gitEmail = git config user.email
        } catch {
            $gitEmail = $null
        }

        if ($gitEmail -and ($emailsInKey -contains $gitEmail)) {
            $emailToUse = $gitEmail
        } else {
            Write-Error "Multiple emails found in key $KeyID. Please specify the email to use with -Email."
            Write-Output "Available emails: $($emailsInKey -join ', ')"
            exit 1
        }
    }
}

# --- Prepare config commands ---
$userSigningKeyConfig = "user.signingkey ${KeyID}!"
$userEmailConfig = "user.email ${emailToUse}"
$commitGpgSignConfig = "commit.gpgSign true"
$gpgProgramConfig = "gpg.program ${gpgPath}"

if ($DryRun) {
    Write-Output "Dry Run: The following configurations would be applied:"
    Write-Output "  $userSigningKeyConfig"
    Write-Output "  $userEmailConfig"
    Write-Output "  $commitGpgSignConfig"
    Write-Output "  $gpgProgramConfig"
    exit 0
}

# --- Apply configuration ---
try {
    git config $scope user.signingkey "${KeyID}!"
    git config $scope user.email "$emailToUse"
    git config $scope commit.gpgSign true
    git config $scope gpg.program "$gpgPath"

    Write-Output "GPG signing configured with:"
    Write-Output "   Key ID : ${KeyID}"
    Write-Output "   Email  : ${emailToUse}"
    Write-Output "   Scope  : ${scope}"
} catch {
    Write-Error "Error configuring Git: $_"
    exit 1
}
