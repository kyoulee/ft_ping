---
title: 빌드 프로세스의 심층 분석
description: |-
  오픈 소스 소프트웨어 빌드 과정에 대한
date: 
preview: /images/build-process-preview.png
draft: false
tags:
  - 빌드
  - configure
  - makefile
  - autoconf
  - automake
categories:
  - 개발
  - 빌드/배포
---

## `awk`를 활용한 중복 제거: `make` 규칙에서 유용한 텍스트 처리

`make` 파일을 작성하다 보면 여러 파일 목록이나 설정 값들을 처리해야 하는 경우가 많습니다. 이때 중복된 항목을 제거하고 고유한 값들만 얻고 싶을 때, 강력한 텍스트 처리 유틸리티인 `awk`를 활용하면 매우 효과적입니다. 이번 글에서는 `make` 규칙 내에서 자주 사용되는 `awk` 스크립트 조각을 분석하고, 그 활용 방법을 예시와 함께 설명합니다.

### 분석: 중복 제거 `awk` 스크립트

다음은 `make` 파일에서 흔히 볼 수 있는 `awk` 스크립트 조각입니다.

```makefile
$(AWK) '\
  BEGIN { nonempty = 0; } \
  { items[$$0] = 1; nonempty = 1; } \
  END { if (nonempty) { for (i in items) print i; }; } \
'
```

**각 부분별 설명:**

* **`$(AWK) '...'`**: `$(...)`는 쉘의 명령 치환으로, `AWK` 변수에 정의된 `awk` 실행 파일을 사용하여 따옴표 안의 `awk` 스크립트를 실행하고 그 결과를 현재 위치에 삽입합니다.
* **`BEGIN { nonempty = 0; }`**: `BEGIN` 블록은 `awk` 스크립트 시작 시 단 한 번 실행됩니다. `nonempty` 변수를 `0`으로 초기화하여 입력이 있었는지 여부를 추적합니다.
* **`{ items[$$0] = 1; nonempty = 1; }`**: 이 블록은 입력의 각 행에 대해 실행됩니다.
    * `$$0`: 현재 처리 중인 전체 입력 행을 나타냅니다.
    * `items[$$0] = 1;`: 현재 입력 행을 연관 배열 `items`의 키로 저장합니다. 값 `1`은 단순히 키의 존재를 표시하는 데 사용됩니다. 중복된 행은 동일한 키로 덮어쓰여 중복이 제거됩니다.
    * `nonempty = 1;`: 입력이 있었다는 것을 표시합니다.
* **`END { if (nonempty) { for (i in items) print i; }; }`**: `END` 블록은 모든 입력 처리 후 단 한 번 실행됩니다.
    * `if (nonempty) { ... };`: 입력이 하나 이상 있었을 경우에만 실행됩니다.
    * `for (i in items) print i;`: 연관 배열 `items`의 모든 키 (고유한 입력 행)를 출력합니다.

**핵심 아이디어:** `awk`의 연관 배열은 키의 중복을 허용하지 않는다는 점을 이용하여 입력 행을 키로 저장하고, 최종적으로 키만 출력함으로써 중복된 행을 효율적으로 제거합니다.

### `make` 규칙에서의 활용 예시

다음은 `make` 규칙에서 위 `awk` 스크립트를 활용하여 중복된 소스 파일 목록을 제거하는 예시입니다.

```makefile
SOURCES := src/file1.c src/utils/file1.c src/file2.c src/file1.c

UNIQUE_SOURCES := $(shell echo "$(SOURCES)" | $(AWK) 'BEGIN { nonempty = 0; } { items[$$0] = 1; nonempty = 1; } END { if (nonempty) { for (i in items) print i; }; }')

all:
	@echo "Unique sources: $(UNIQUE_SOURCES)"
```

**설명:**

1.  `SOURCES` 변수에는 중복된 `src/file1.c`를 포함한 소스 파일 목록이 정의되어 있습니다.
2.  `$(shell echo "$(SOURCES)" | ...)` 부분은 `SOURCES` 변수의 내용을 파이프를 통해 `awk` 스크립트의 표준 입력으로 전달합니다.
3.  `awk` 스크립트는 중복된 파일 이름을 제거하고 고유한 목록만 표준 출력으로 내보냅니다.
4.  `UNIQUE_SOURCES` 변수는 쉘 명령의 결과를 할당받아 고유한 소스 파일 목록을 저장하게 됩니다.
5.  `all` 타겟에서는 `UNIQUE_SOURCES` 변수의 내용을 출력합니다.

이처럼 `awk`를 활용하면 `make` 파일 내에서 복잡한 텍스트 처리를 간결하고 효율적으로 수행할 수 있으며, 특히 중복 제거와 같은 작업에서 그 강력함을 확인할 수 있습니다.