#!/usr/bin/env bash

source scripts/common.bash
source scripts/boj_helper.bash

function main() {
  # Check if required commands are installed
  check_command "jq"
  # Check if the problem number or URL is provided
  if [ "$#" -eq 1 ]; then
    input="$1"
    if [[ "$input" == *"https://www.acmicpc.net/problem/"* ]]; then
      # If the input is a BOJ URL
      problem_number=$(extract_problem_number "$input")
    elif [[ "$input" =~ ^[0-9]+$ ]]; then
      # If the input is already a Number
      problem_number="$input"
    fi
  else
    echo "Please provide the BOJ problem number or URL."
    exit 1
  fi

  echo "Problem Number: $problem_number"

  response=$(request "$problem_number")

  if ! echo "$response" | jq -e '.titleKo' >/dev/null 2>&1; then
    echo "Failed to receive a valid response from the solved.ac API. Exiting the script."
    exit 1
  fi

  echo "Received problem details response from solved.ac."

  # Create the Swift file
  create_swift_file "$response"

  echo "Opening Xcode project..."
  open_xcode_project
}

load_env_vars

# Call the main function
main "$@"
