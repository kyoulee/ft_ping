#!/bin/bash

# 입력으로 폴더 이름을 받음
folder_name_with_prefix="$1"

# 폴더 이름이 제공되지 않았을 경우 에러 메시지 출력 후 종료
if [ -z "$folder_name_with_prefix" ]; then
  echo "사용법: $0 <폴더 이름>"
  exit 1
fi

# 앞의 숫자와 하이픈 제거
folder_name="${folder_name_with_prefix#*-}"

# 현재 시간 가져오기 (ISO 8601 형식)
current_datetime=$(date +'%Y-%m-%dT%H:%M:%S%z')

# 최상위 폴더 생성
mkdir -p "$folder_name_with_prefix"

# assets 폴더 생성
mkdir -p "$folder_name_with_prefix/assets/images"
mkdir -p "$folder_name_with_prefix/assets/files"

# blog-write-memo.md 파일 내용
markdown_content="---
title: '$folder_name'
description: |-
	내용입력
date: $current_datetime
preview: /image/defualt-image.png
draft: false
tags:
  - 테그없음
categories:
  - 카테고리없음
---
"

# blog-write-memo.md 파일 생성 및 내용 기록
echo "$markdown_content" > "$folder_name_with_prefix/$folder_name.md"

echo "폴더 '$folder_name_with_prefix' 및 필요한 파일들이 생성되었으며, 제목은 '$folder_name'으로 설정되었습니다."