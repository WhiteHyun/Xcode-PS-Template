#!/bin/bash

# Load environment variables from .env file
function load_env_vars() {
  if [ -f .env ]; then
    # shellcheck disable=SC2046
    export echo $(sed <.env 's/#.*//g' | xargs | envsubst)
  fi
}

# Check if a command is installed
function check_command() {
  local command="$1"
  if ! command -v "$command" &>/dev/null; then
    echo "The $command command is not installed."
    read -r -p "Do you want to install $command? (Y/n): " install_command
    case "$install_command" in
    [nN] | [nN][oO])
      echo "Installation of $command has been rejected. Exiting the script."
      exit 1
      ;;
    *)
      echo "Proceeding with the installation of $command..."
      brew install "$command"
      ;;
    esac
  fi
}

# Translate the file name to English using DeepL API
function translate_file_name() {
  local text
  local auth_key
  local translated_title

  text="$1"

  if [ -n "$DEEPL_API_KEY_PATH" ] && [ -f "$DEEPL_API_KEY_PATH" ]; then
    auth_key=$(cat "$DEEPL_API_KEY_PATH")
    translated_title=$(curl -s -X POST 'https://api-free.deepl.com/v2/translate' \
      --header "Authorization: DeepL-Auth-Key $auth_key" \
      --header 'Content-Type: application/json' \
      --data "{
        \"text\": [
          \"$text\"
        ],
        \"target_lang\": \"EN\"
      }" | jq -r '.translations[0].text')

    echo "$translated_title"
  else
    echo "$text"
  fi
}

# Add the Swift file to Xcode project
function add_to_xcode_project() {
  local solution_file="$1"
  local ps_folder_name="$2"
  local difficulty="$3"

  if [ -n "$difficulty" ]; then
    ./add_to_xcode_project.rb "$solution_file" "$ps_folder_name" "$difficulty"
  else
    ./add_to_xcode_project.rb "$solution_file" "$ps_folder_name"
  fi
  echo "Adding Swift file to Xcode project completed: $solution_file"
}
