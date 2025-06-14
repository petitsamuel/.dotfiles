#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Define file paths as variables for clarity and to avoid repetition
LANGUAGES_FILE="$SCRIPT_DIR/.tmux-cht-languages"
COMMANDS_FILE="$SCRIPT_DIR/.tmux-cht-command"

# Check if the necessary files exist
if [[ ! -f "$LANGUAGES_FILE" ]] || [[ ! -f "$COMMANDS_FILE" ]]; then
    echo "Error: Missing .tmux-cht-languages or .tmux-cht-command file in $SCRIPT_DIR" >&2
    exit 1
fi

# Combine language and command lists for fzf
selected=$(cat "$LANGUAGES_FILE" "$COMMANDS_FILE" | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

# FIX 1: Check against the SAME file that you sourced the languages from.
# Added '^' and '$' to grep for an exact, full-line match.
if grep -qs "^$selected$" "$LANGUAGES_FILE"; then
    # Prepare query for URL by replacing spaces with '+'
    query_for_url=$(echo "$query" | tr ' ' '+')
    
    # FIX 2: Run curl in the foreground and pipe to `less` for a better user experience.
    # This is more robust and consistent with the `else` block.
    tmux neww bash -c "curl -s cht.sh/$selected/$query_for_url | less"
else
    # This part was already well-written.
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
fi

