# Xcode-Algorithm-Template

백준, Programmers, LeetCode 문제를 풀 때 일일히 입력해야하는 코드를 자동으로 완성시켜주는 템플릿입니다.
Shell script와 ruby 코드를 곁들여서 작성했습니다.

## 사용법

`.env` 파일을 들어가면 5가지의 세팅값이 존재합니다.

```
NICKNAME=your_nickname
# DEEPL_API_KEY_PATH=path/to/deepl_api_key.txt
XCODE_PROJECT_NAME=your_xcode_project_name
XCODE_MAIN_FOLDER=your_xcode_main_folder
XCODE_UNIT_TEST_FOLDER=your_xcode_unit_test_folder
```

1. NICKNAME: 자신이 사용할 닉네임입니다. Xcode에서 파일을 만들 때 사용자의 `Created by` 다음으로 해당 닉네임 값이 들어갑니다.
2. DEEPL_API_KEY_PATH: 만약 DeepL API 값이 있으면 백준이나 프로그래머스 문제의 이름을 영문으로 번역해서 Xcode 파일로 만듭니다.
   > 가끔씩 한국어로 되어있는 파일명을 `pbxproj`에 넣었을 때 가끔씩 Xcode 자체가 열리지 않는 버그가 생겨서 만들어 두었습니다. 😅
3. XCODE_MAIN_FOLDER: Xcode CommandLine 메인 폴더입니다. 메인 타겟은 메인 폴더와 이름이 동일해야합니다.
4. XCODE_UNIT_TEST_FOLDER: Xcode Unit Test 폴더입니다. Unit Test 타겟과 동일해야합니다.
