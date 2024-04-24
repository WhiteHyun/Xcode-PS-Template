#!/usr/bin/env bash

source scripts/common.bash
source scripts/programmers_helper.bash

# 메인 함수
function main() {
    local problem_number
    local problem_info

    if [ "$#" -eq 0 ]; then
        echo -n "Enter the Programmers problem number or URL: "
        read -r problem_info
    elif [ "$#" -eq 1 ]; then
        problem_info="$1"
    else
        echo "Please provide the Programmers problem number or URL."
        exit 1
    fi

    problem_number=$(extract_problem_number "$problem_info")
    if [ -z "$problem_number" ]; then
        echo "Problem number not found."
        exit 1
    fi

    echo "Problem Number: $problem_number"

    create_swift_file "$problem_number"

    echo "Opening Xcode project..."
    open_xcode_project
}

load_env_vars

# Call the main function
main "$@"
