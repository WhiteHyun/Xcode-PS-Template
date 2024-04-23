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
    echo "$command 명령어가 설치되어 있지 않습니다."
    read -r -p "$command을 설치하시겠습니까? (Y/n): " install_command
    case "$install_command" in
    [nN] | [nN][oO])
      echo "$command 설치가 거부되었습니다. 스크립트를 종료합니다."
      exit 1
      ;;
    *)
      echo "$command 설치를 진행합니다..."
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
  echo "Xcode 프로젝트에 Swift 파일 추가 완료: $solution_file"
}

echo "$DEEPL_API_KEY_PATH"
load_env_vars
echo "$DEEPL_API_KEY_PATH"
