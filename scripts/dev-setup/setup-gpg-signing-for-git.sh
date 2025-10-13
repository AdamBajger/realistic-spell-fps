#!/bin/sh
set -e

HELP=false
GLOBAL=false
DRYRUN=false
KEYID=""

show_help() {
    cat <<EOF
Usage: $0 --keyid <KEY_ID> [--global] [--dry-run] [--help]

Parameters:
    --keyid   (Required) The GPG key ID to use for signing commits.
    --global  (Optional) Apply the configuration globally. If not specified, configuration is applied locally.
    --dry-run (Optional) Show the configuration values that would be used without applying them.
    --help    (Optional) Display this help message.
EOF
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --help|-h)
            HELP=true
            shift
            ;;
        --keyid=*)
            KEYID="${1#*=}"
            shift
            ;;
        --keyid)
            KEYID="$2"
            shift 2
            ;;
        --global)
            GLOBAL=true
            shift
            ;;
        --dry-run)
            DRYRUN=true
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            show_help
            exit 1
            ;;
    esac
done

# Show help if requested
if [ "$HELP" = "true" ]; then
    show_help
    exit 0
fi

# Ensure KEYID is provided
if [ -z "$KEYID" ]; then
    echo "Error: --keyid is required."
    show_help
    exit 1
fi

# Determine git config scope
if [ "$GLOBAL" = "true" ]; then
    SCOPE="--global"
else
    SCOPE="--local"
fi

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed."
    exit 1
fi

# Locate gpg
if ! GPG_PATH=$(command -v gpg); then
    echo "Error: gpg is not installed or not found in PATH."
    exit 1
fi

# Retrieve email associated with the GPG key
EMAIL=$(gpg --list-keys --with-colons "$KEYID" 2>/dev/null \
    | awk -F: '/^uid/ {print $10; exit}' \
    | sed -n 's/.*<\(.*\)>.*/\1/p')

if [ -z "$EMAIL" ]; then
    echo "Error: No email address found for key ID $KEYID."
    exit 1
fi

# Variables for git config
USER_SIGNINGKEY="$KEYID!"
USER_EMAIL="$EMAIL"
COMMIT_GPGSIGN=true
GPG_PROGRAM="$GPG_PATH"

# Dry run
if [ "$DRYRUN" = "true" ]; then
    echo "Dry Run: The following configurations would be applied:"
    echo "user.signingkey $USER_SIGNINGKEY"
    echo "user.email $USER_EMAIL"
    echo "commit.gpgSign $COMMIT_GPGSIGN"
    echo "gpg.program $GPG_PROGRAM"
    exit 0
fi

# Apply git configuration
git config $SCOPE user.signingkey "$USER_SIGNINGKEY"
git config $SCOPE user.email "$USER_EMAIL"
git config $SCOPE commit.gpgSign "$COMMIT_GPGSIGN"
git config $SCOPE gpg.program "$GPG_PROGRAM"

echo "GPG signing configured with key ID $KEYID and email $EMAIL ($SCOPE)."
