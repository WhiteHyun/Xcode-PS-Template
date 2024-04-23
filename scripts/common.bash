#!/bin/bash

# Load environment variables from .env file
function load_env_vars() {
  if [ -f .env ]; then
    # shellcheck disable=SC2046
    export echo $(sed <.env 's/#.*//g' | xargs | envsubst)

    # Check if required variables are set and not equal to default values
    if [ "$NICKNAME" = "your_nickname" ] || [ "$XCODE_PROJECT_NAME" = "your_xcode_project_name" ] || [ "$XCODE_MAIN_FOLDER" = "your_xcode_main_folder" ] || [ "$XCODE_UNIT_TEST_FOLDER" = "your_xcode_unit_test_folder" ]; then
      echo "Error: Required environment variables are set to default values."
      echo "Please update NICKNAME, XCODE_PROJECT_NAME, XCODE_MAIN_FOLDER, and XCODE_UNIT_TEST_FOLDER in the .env file with appropriate values."
      exit 1
    fi
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

# Generates the content of a Swift solution file for a given coding problem.
#
# Arguments:
#   $1 - question_id: The unique number of the problem.
#   $2 - question_name: The name or title of the problem.
#   $3 - question_platform: The URL to the problem.
#   $4 - ps_platform: The name of the problem-solving platform.
#   $5 - swift_code: The Swift code to solve the problem.
#
# Returns:
#   The generated content of the Swift solution file.
function make_solution_code() {
  local question_id=$1
  local question_name=$2
  local question_platform=$3
  local ps_platform=$4
  local swift_code=$5
  local nickname
  if [ -n "$NICKNAME" ] && [ -f "$NICKNAME" ]; then
    nickname=$NICKNAME
  else
    nickname=Unknown
  fi
  local content
  content=$(
    cat <<EOF
//
//  $question_id. $question_name.swift
//  $question_platform
//  Algorithm
//
//  Created by $nickname on $(date "+%Y/%m/%d").
//

import Foundation

final class $ps_platform$question_id {
  $swift_code
}

EOF
  )
  echo "$content"
}

# Save the Swift file
function save_swift_file() {
  local file_name="$1"
  local difficulty="$2"
  local ps_platform="$3"
  local content="$4"
  local DIR

  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  local solution_folder="$DIR/$XCODE_MAIN_FOLDER/$ps_platform/$difficulty"
  mkdir -p "$solution_folder"

  local solution_file="$solution_folder/$file_name.swift"
  echo "$content" >"$solution_file"
  echo "Swift 파일 생성 완료: $file_name"
}

# Add the Swift file to Xcode project
function add_to_xcode_project() {
  local solution_file="$1.swift"
  local ps_platform="$2"
  local difficulty="$3"

  if [ -n "$difficulty" ]; then
    ./add_to_xcode_project.rb "$solution_file" "$ps_platform" "$difficulty"
  else
    ./add_to_xcode_project.rb "$solution_file" "$ps_platform"
  fi
  echo "Adding Swift file to Xcode project completed: $solution_file"
}
