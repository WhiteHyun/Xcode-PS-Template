#!/usr/bin/env bash

# Extract the problem name from the BOJ URL
function extract_problem_number() {
  local url="$1"
  echo "$url" | grep -oE "[0-9]+$"
}

# Create the Swift code snippet
function create_swift_code_snippet() {
  local question_id="$1"

  local swift_code="
  func solution(<#parameters#>) -> <#return type#> {
    <#function body#>
  }
"
  echo "$swift_code"
}

# Send a GET request to the solved.ac API
function request() {
  local problem_number="$1"
  local response
  response=$(curl --request GET \
    --url "https://solved.ac/api/v3/search/problem?query=${problem_number}&page=1&sort=id&direction=asc" \
    --header 'Content-Type: application/json' | jq ".items | .[0]")
  echo "$response"
}

# Create a Swift file for the BOJ problem
function create_swift_file() {
  local json_data="$1"
  local question_id
  local title
  local difficulty
  local swift_code
  local file_name
  local content
  local unit_test_content

  question_id=$(echo "$json_data" | jq ".problemId")
  title=$(echo "$json_data" | jq ".titleKo")
  title=${title#\"}
  title=${title%\"}
  difficulty=$(echo "$json_data" | jq ".level")

  # difficulty must be a number.
  if [ -z "$difficulty" ] || [ "$difficulty" -ne "$difficulty" ] 2>/dev/null; then
    echo "difficulty must be a number."
    exit 1
  fi

  case $(((difficulty - 1) / 5)) in
  0) rank="Bronze" ;;
  1) rank="Silver" ;;
  2) rank="Gold" ;;
  3) rank="Platinum" ;;
  4) rank="Diamond" ;;
  *) rank="Unknown" ;;
  esac

  # Translate Korean to English if the API key is provided.
  if [ -n "$DEEPL_API_KEY_PATH" ] && [ -f "$DEEPL_API_KEY_PATH" ]; then
    title=$(translate_file_name "$title")
  fi

  # Generate the code snippet
  swift_code=$(create_swift_code_snippet "$question_id")
  file_name="${question_id}. ${title}"

  # Generate the entire Swift code
  content=$(make_solution_code "$question_id" "$title" "https://www.acmicpc.net/problem/$question_id" "BOJ" "$swift_code")
  unit_test_content=$(make_unit_test_code "$question_id" "BOJ")

  # Link to the xcodeproj
  add_to_xcode_project "$XCODE_MAIN_FOLDER" "$file_name" "BOJ" "$rank"
  add_to_xcode_project "$XCODE_UNIT_TEST_FOLDER" "BOJ${question_id}Tests" "BOJ"

  # Save the files
  save_swift_file "$file_name" "BOJ" "$XCODE_MAIN_FOLDER" "$content" "$rank"
  save_swift_file "BOJ${question_id}Tests" "BOJ" "$XCODE_UNIT_TEST_FOLDER" "$unit_test_content"
}
