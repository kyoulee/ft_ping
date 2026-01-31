## 쉘 `case` 구문의 다양한 패턴과 흐름 제어: 깊이 있는 이해

쉘 스크립트에서 조건부 로직을 구현하는 강력한 도구 중 하나인 `case` 구문은 다양한 패턴 매칭 기능을 제공합니다. 특히 복잡한 문자열 비교나 값의 종류에 따른 분기를 처리할 때 유용하게 활용됩니다. 이번 글에서는 `case` 구문에서 사용될 수 있는 주요 패턴과 흐름 제어 방식에 대해 예시 코드와 함께 자세히 알아보겠습니다.

### 1. 기본적인 패턴 매칭

가장 기본적인 형태는 특정 값과 정확히 일치하는 패턴입니다.

```bash
#!/bin/bash

option="$1"

case "$option" in
  "start")
    echo "Starting the process..."
    ;;
  "stop")
    echo "Stopping the process..."
    ;;
  "restart")
    echo "Restarting the process..."
    ;;
  *)
    echo "Invalid option: $option"
    exit 1
    ;;
esac
```

### 2\. 와일드카드 활용: `?` (임의의 단일 문자)

`?` 패턴은 임의의 단일 문자와 매치됩니다.

```bash
#!/bin/bash

input="$1"

case "$input" in
  "v?")
    echo "Input starts with 'v' followed by one character: $input"
    ;;
  *)
    echo "Input does not match the pattern."
    ;;
esac
```

### 3\. 와일드카드 활용: `*` (0개 이상의 모든 문자)

`*` 패턴은 0개 이상의 모든 문자열과 매치되는 기본 패턴으로 주로 마지막에 사용됩니다.

```bash
#!/bin/bash

file="$1"

case "$file" in
  *.txt)
    echo "Text file: $file"
    ;;
  *.jpg|*.png)
    echo "Image file: $file"
    ;;
  *)
    echo "Other file type: $file"
    ;;
esac
```

### 4\. OR 조건: `|`

여러 패턴 중 하나라도 일치하면 해당 명령을 실행할 수 있습니다.

```bash
#!/bin/bash

command="$1"

case "$command" in
  "help" | "-h" | "--help")
    echo "Displaying help information..."
    ;;
  *)
    echo "Unknown command: $command"
    ;;
esac
```

### 5\. 문자 집합: `[]`

대괄호 `[]` 안에 명시된 문자 집합 중 하나와 일치합니다. 범위를 지정할 수도 있습니다.

```bash
#!/bin/bash

letter="$1"

case "$letter" in
  [aeiouAEIOU])
    echo "Vowel: $letter"
    ;;
  [a-zA-Z])
    echo "Alphabet: $letter"
    ;;
  [0-9])
    echo "Digit: $letter"
    ;;
  *)
    echo "Other character: $letter"
    ;;
esac
```

### 6\. 부정 문자 집합: `[! ]`

대괄호 안에 `!`를 사용하면 명시된 문자 집합에 없는 임의의 단일 문자와 일치합니다.

```bash
#!/bin/bash

char="$1"

case "$char" in
  [!0-9])
    echo "Not a digit: $char"
    ;;
  *)
    echo "Digit: $char"
    ;;
esac
```

### 7\. 흐름 제어: 종료자 (`;;`, `;&`, `;|`)

`case` 구문 내에서 패턴 매칭 후 실행되는 명령 블록의 흐름을 제어하는 종료자들이 있습니다.

  * **`;;` (Double Semicolon):** 가장 일반적인 종료자로, 현재 패턴과 일치하는 명령 블록을 실행한 후 `case` 구문을 **종료**합니다. 앞선 예시들에서 사용되었습니다.

  * **`;&` (Semicolon Ampersand - Fallthrough):** 현재 패턴과 일치하는 명령 블록을 실행한 후, **다음 패턴의 명령 블록도 이어서 실행**합니다.

    ```bash
    #!/bin/bash

    value="$1"

    case "$value" in
      "1")
        echo "Value is one."
        ;&
      "1" | "2")
        echo "Value is one or two."
        ;;
      *)
        echo "Value is something else."
        ;;
    esac
    ```

    위 예시에서 입력이 `"1"`이면 "Value is one."과 "Value is one or two."가 모두 출력됩니다.

  * **`;|` (Semicolon Pipe - Fallthrough to Next Pattern):** 현재 패턴과 일치하는 명령 블록을 실행하지 않고, **바로 다음 패턴의 명령 블록으로 이동하여 실행**합니다.

    ```bash
    #!/bin/bash

    value="$1"

    case "$value" in
      "one")
        echo "First case."
        ;|
      "one" | "two")
        echo "Second case."
        ;;
      *)
        echo "Default case."
        ;;
    esac
    ```

    위 예시에서 입력이 `"one"`이면 "First case."는 출력되지 않고 바로 "Second case."가 출력됩니다.

쉘 `case` 구문은 다양한 패턴 매칭 기능과 흐름 제어 옵션을 통해 강력하고 유연한 조건부 처리를 가능하게 합니다. 스크립트 작성 시 적절한 패턴과 종료자를 활용하여 효율적이고 명확한 로직을 구현할 수 있습니다.

### 주요 쉘 `case` 패턴

| 패턴      | 의미                                     | 예시      |
|-----------|------------------------------------------|-----------|
| `?)`       | 임의의 단일 문자                          | `a`, `1`  |
| `*)`       | 0개 이상의 모든 문자 (기본)             | `abc`, `` |
| `pattern)` | 특정 패턴 일치                           | `start)`  |
| `a \| b)`  | `a` 또는 `b` 일치                       | `help \| -h)` |
| `[abc])`  | `a`, `b`, `c` 중 하나                    | `[a-z])`  |
| `[!abc])` | `a`, `b`, `c` 제외한 단일 문자            | `[!0-9])` |

### 주요 흐름 제어 종료자

| 종료자 | 의미                                     |
|--------|------------------------------------------|
| `;;`   | 현재 패턴 명령 실행 후 `case` 종료        |
| `;&`   | 현재 패턴 명령 실행 후 다음 패턴 명령 실행 |
| `;\|`   | 현재 패턴 명령 건너뛰고 다음 패턴 명령 실행 |

더 자세한 내용은 이전 답변을 참고해주세요.