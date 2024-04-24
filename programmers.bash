#!/usr/bin/env bash

source common.bash
source programmers_helper.bash

# 메인 함수
function main() {
    local problem_number
    local problem_info

    if [ "$#" -eq 0 ]; then
        echo -n "프로그래머스 문제 번호 또는 URL: "
        read -r problem_info
    elif [ "$#" -eq 1 ]; then
        problem_info="$1"
    else
        echo "Please provide the Programmers problem number or URL."
        exit 1
    fi

    problem_number=$(extract_problem_number "$problem_info")
    if [ -z "$problem_number" ]; then
        echo "문제 번호를 찾을 수가 없습니다"
        exit 1
    fi

    echo "Problem Number: $problem_number"

    create_swift_file "$problem_number"

    echo "Xcode 프로젝트 여는 중..."
    open "$XCODE_PROJECT_NAME.xcodeproj"
}

load_env_vars

# Call the main function
main "$@"
