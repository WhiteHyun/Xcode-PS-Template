#!/usr/bin/env bash

# Extract the problem name from the Programmers URL
function extract_problem_number() {
  local problem_info=$1
  if [[ $problem_info =~ ^[0-9]+$ ]]; then
    echo "$problem_info"
  elif [[ $problem_info =~ ^https://school.programmers.co.kr/learn/courses/30/lessons/[0-9]+ ]]; then
    echo "$problem_info" | sed -n "s/^.*https:\/\/school\.programmers\.co\.kr\/learn\/courses\/30\/lessons\/\([0-9]*\).*$/\1/p"
  else
    echo "문제 번호 또는 링크가 필요합니다!" >&2
    return 1
  fi
}

# Create the Swift code snippet
function create_swift_code_snippet() {
  local problem_link=$1
  local problem_info
  local problem_name
  local swift_code
  problem_info=$(curl -s -N "$problem_link")
  problem_name=$(echo "$problem_info" | sed -n "s/^.*<title>코딩테스트 연습 - \(.*\) \| 프로그래머스 스쿨<\/title>.*$/\1/p")
  swift_code=$(echo "$problem_info" | sed -n '/<textarea hidden id="code" name="code">/,/<\/textarea>/p' | sed 's/<textarea hidden id="code" name="code">//;s/<\/textarea>//')
  swift_code=$(echo "$swift_code" | sed 's/&gt;/>/g;s/&lt;/</g;s/&quot;/"/g;s/&#39;/'"'"'/g;s/&amp;/\&/g')
  swift_code=$(echo "$swift_code" | sed '/import Foundation/d')
  swift_code="${swift_code//  /}"

  echo "$problem_name"
  echo "$swift_code"
}

# Function to create a solution file for a Programmers problem
function create_swift_file() {
  local problem_number=$1
  local problem_name
  local swift_code
  local problem_link="https://school.programmers.co.kr/learn/courses/30/lessons/$problem_number?language=swift"
  local file_name
  local content
  local unit_test_content

  # Generate code snippets and get the problem name
  IFS=$'\n' read -r -d '' problem_name swift_code < <(create_swift_code_snippet "$problem_link")

  # Translate Korean to English if the API key is provided.
  if [ -n "$DEEPL_API_KEY_PATH" ] && [ -f "$DEEPL_API_KEY_PATH" ]; then
    problem_name=$(translate_file_name "$problem_name")
  fi

  file_name="$problem_number. $problem_name"

  # Generate the entire Swift code
  content=$(make_solution_code "$problem_number" "$problem_name" "$problem_link" "Programmers" "$swift_code")
  unit_test_content=$(make_unit_test_code "$problem_number" "Programmers")

  # Link to the xcodeproj
  add_to_xcode_project "$XCODE_MAIN_FOLDER" "$file_name" "Programmers"
  add_to_xcode_project "$XCODE_UNIT_TEST_FOLDER" "Programmers${problem_number}Tests" "Programmers"

  # Save the files
  save_swift_file "$file_name" "Programmers" "$XCODE_MAIN_FOLDER" "$content"
  save_swift_file "Programmers${problem_number}Tests" "Programmers" "$XCODE_UNIT_TEST_FOLDER" "$unit_test_content"
}
