# ft_ping
# inetutils-2.0 ping 분석을 통한 미러링 코딩 과정 

## 목적

본 문서는 inetutils-2.0에 포함된 `ping` 유틸리티의 소스 코드를 분석하며 `ping`의 동작 원리를 이해하고, 네트워크 프로그래밍의 기초를 다지는 데 목표를 두었습니다.

## 프로젝트 개요

`ft_ping`은 `ping` 명령어의 기능을 재구현한 프로그램으로, 네트워크 패킷 전송 및 응답을 처리하는 과정을 학습하기 위해 제작되었습니다.

## 참고 자료

* inetutils-2.0 소스 코드 ([https://ftp.gnu.org/](https://ftp.gnu.org/gnu/inetutils/))
* RFC 792 - Internet Control Message Protocol ([https://datatracker.ietf.org/](https://datatracker.ietf.org/doc/html/rfc792))
* Beej's Guide to Network Programming ([https://beej.us/guide/](https://beej.us/guide/))