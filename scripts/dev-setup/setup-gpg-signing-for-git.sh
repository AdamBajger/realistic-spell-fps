#!/bin/sh
set -e

HELP=false
GLOBAL=false
DRYRUN=false
KEYID=""
EMAIL=""

show_help() {
    cat <<EOF
Usage: $0 --keyid <KEY_ID> [--email <EMAIL>] [--global] [--dry-run] [--help]

Parameters:
    --keyid   (Required) The GPG key ID to use for signing commits.
    --email   (Optional) The email to use. If not specified, will infer from GPG key or git config.
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
        --email=*)
            EMAIL="${1#*=}"
            shift
            ;;
        --email)
            EMAIL="$2"
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

# Show help
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

# Check if gpg is installed
if ! GPG_PATH=$(command -v gpg); then
    echo "Error: gpg is not installed or not found in PATH."
    exit 1
fi

# Get all emails for the key
emails_in_key=$(gpg --list-keys --with-colons "$KEYID" 2>/dev/null | awk -F: '/^uid/ {print $10}')
emails_in_key_list=$(echo "$emails_in_key" | sed -n 's/.*<\(.*\)>.*/\1/p')

if [ -z "$emails_in_key_list" ]; then
    echo "Error: No emails found for key $KEYID."
    exit 1
fi

# Determine email to use
if [ -n "$EMAIL" ]; then
    # Check if user-specified email exists in key
    found=false
    for e in $emails_in_key_list; do
        if [ "$e" = "$EMAIL" ]; then
            found=true
            break
        fi
    done
    if [ "$found" != "true" ]; then
        echo "Error: The specified email '$EMAIL' is not listed in the GPG key."
        exit 1
    fi
    EMAIL_TO_USE="$EMAIL"
else
    # No email specified
    count=$(echo "$emails_in_key_list" | wc -w)
    if [ "$count" -eq 1 ]; then
        EMAIL_TO_USE=$(echo "$emails_in_key_list")
    else
        # Try to infer from git config
        git_email=$(git config $SCOPE user.email || true)
        found=false
        for e in $emails_in_key_list; do
            if [ "$e" = "$git_email" ]; then
                found=true
                break
            fi
        done
        if [ "$found" = "true" ]; then
            EMAIL_TO_USE="$git_email"
        else
            echo "Error: Multiple emails found in key $KEYID. Please specify the email to use with --email."
            echo "Available emails: $emails_in_key_list"
            exit 1
        fi
    fi
fi

# Git config variables
USER_SIGNINGKEY="$KEYID!"
# USER_EMAIL="$EMAIL_TO_USE"
# COMMIT_GPGSIGN=true
# GPG_PROGRAM="$GPG_PATH"

# Dry run
if [ "$DRYRUN" = "true" ]; then
    echo "Dry Run: The following configurations would be applied:"
    echo "user.signingkey $USER_SIGNINGKEY"
    echo "user.email $EMAIL_TO_USE"
    echo "commit.gpgSign true"
    echo "gpg.program $GPG_PATH"
    exit 0
fi

# Apply git configuration
git config $SCOPE user.signingkey "$USER_SIGNINGKEY"
git config $SCOPE user.email "$EMAIL_TO_USE"
git config $SCOPE commit.gpgSign true
git config $SCOPE gpg.program "$GPG_PATH"

echo "GPG signing configured with key ID $KEYID and email $EMAIL_TO_USE ($SCOPE)."
