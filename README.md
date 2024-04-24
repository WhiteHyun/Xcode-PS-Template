# Xcode-Algorithm-Template

|                                                                        BOJ                                                                        |                                                                    Programmers                                                                    |                                                                     LeetCode                                                                      |
| :-----------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------: |
| ![Screen Recording 2024-04-24 at 1 34 05 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/a9ff5ad7-e9b2-4983-84f6-0923120314f1) | ![Screen Recording 2024-04-24 at 1 32 28 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/3ef39510-4305-4b49-9d6c-68f2190466f4) | ![Screen Recording 2024-04-24 at 1 34 59 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/718a9b75-018d-4dd7-bc10-d61139e0c11b) |

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

### 스크립트 실행 방법

#### LeetCode

URL이나 title-slug를 인자로 넣어주면 됩니다.

```bash
./leetcode.bash [URL]
./leetcode.bash [title-slug]

# e.g.
./leetcode.bash https://leetcode.com/problems/n-th-tribonacci-number/description/
./leetcode.bash n-th-tribonacci-number
```

> 여기서 인자란 아래 사진에서 `n-th-tribonacci-number`와 같이 각 제목마다 띄어쓰기 대신에 `-`가 들어간 것을 의미합니다.
> ![image](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/b0a5e248-6335-42d7-9b64-4f0725492587)

#### 백준(BOJ)

URL이나 문제 번호를 인자로 넣어주시면 됩니다.

```bash
./boj.bash [URL]
./boj.bash [number]

# e.g.
./boj.bash https://www.acmicpc.net/problem/13583
./boj.bash 13583
```

#### 프로그래머스(Programmers)

URL이나 문제 번호를 인자로 넣어주시면 됩니다.

```bash
./programmers.bash [URL]
./programmers.bash [number]

# e.g.
./programmers.bash https://school.programmers.co.kr/learn/courses/30/lessons/258709
./programmers.bash 258709
```

---

## 설치 방법

1. 해당 템플릿을 이용해서 레포지토리를 만들어주세요.
   ![Screenshot 2024-04-24 at 1 17 14 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/d0d7972e-7e45-47d1-bc62-523a20085540)
   ![Screenshot 2024-04-24 at 1 17 22 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/a143922b-f417-4060-984e-89274c5c6cc6)

2. 레포지토리를 클론하고 해당 폴더에 진입하면 아래와 같은 구조가 나타납니다.

```
.
├── LICENSE
├── README.md
├── boj.bash
├── leetcode.bash
├── programmers.bash
└── scripts
    ├── add_to_xcode_project.rb
    ├── boj_helper.bash
    ├── common.bash
    ├── leetcode_helper.bash
    └── programmers_helper.bash
```

3. chmod 설정을 해주세요.

그러지 않으면 `permission denied` 와 같은 오류가 나타납니다.

```bash
chmod +x *.bash scripts/*
```

4. Xcode 프로젝트 중 macOS의 Command Line Tool 프로젝트를 해당 폴더에 생성해주세요.
   ![Screen Recording 2024-04-24 at 1 22 58 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/92449354-293f-4ef5-bcdb-f7352c613fa2)

5. env 파일을 수정하세요.

![Screen Recording 2024-04-24 at 1 26 03 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/3f7dd1ba-f65d-4de3-aaaa-c8ba56453488)

- 예시에서는 프로젝트명을 ProblemSolving으로 지정했기 때문에, `XCODE_PROJECT_NAME`과 `XCODE_MAIN_FOLDER`를 ProblemSolving으로 지정해주었습니다.
  그리고 닉네임은 앞으로 Swift 생성시 나타날 이름이기에 원하는 닉네임으로 작성하시면 됩니다.
- 만약 유닛테스트도 함께 사용하고 싶으시다면, Unit Test Target 생성 후 env에서 `XCODE_UNIT_TEST_FOLDER`주석을 풀어준 뒤 Unit Test Target 이름을 넣어주시면 됩니다.

6. 끝 (유닛테스트는 밑 글을 참조)

이제 풀고자 하는 문제들을 가지고 쉘 스크립트로 편하게 파일을 만들어보세요. 🥳

---

## 번외: Unit Test 사용해보기

매 문제마다 나오는 테스트 케이스를 검증하기 위해 Unit Test 코드를 별도로 추가할 수 있습니다.

우선 영상에서 보이는 것처럼 Unit Test Target을 생성한 뒤에 `.env` 파일에 들어가 `XCODE_UNIT_TEST_FOLDER`주석을 풀어준 후 Unit Test Target 이름을 넣어주세요.

![Screen Recording 2024-04-24 at 1 02 39 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/7fa72c07-013b-49a4-bbb1-7546ac0c5ef6)

그러면 지금처럼 문제를 생성할 때 테스트코드 파일도 같이 생성해줍니다.

![Screen Recording 2024-04-24 at 1 08 43 PM](https://github.com/WhiteHyun/Xcode-PS-Template/assets/57972338/68dc3236-2400-410a-b8f3-fcd3b8fc07a0)
