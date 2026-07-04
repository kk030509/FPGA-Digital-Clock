# 🕒 FPGA 디지털 시계 및 달력

## 📌 프로젝트 개요
이 프로젝트는 **Verilog**를 이용하여 **FPGA(Basys3)** 상에서 동작하는 디지털 시계와 달력 시스템을 구현한 것입니다.

실시간 시계 표시, 날짜 관리, 연도 표시, 그리고 LED를 이용한 요일 표시 기능을 제공합니다.

---

## ⚙️ 주요 기능

- ⏰ 실시간 시계 (HH:MM)
- 📅 날짜 표시 (MM.DD)
- 📆 연도 표시 (YYYY)
- 🔁 12시간 / 24시간 모드 지원
- 🎛️ 시간 및 날짜 수동 설정
- 📊 요일 계산
- 💡 LED를 이용한 요일 표시

---

## 🎛️ 스위치 기능

| 스위치 | 기능 |
|--------|------|
| sw[0] | 시계 동작(On/Off) |
| sw[1] | 시간 설정 모드 |
| sw[2] | 12시간 / 24시간 모드 |
| sw[3] | 연도 표시 |
| sw[4] | 날짜 표시 |
| sw[5] | 연도 설정 모드 |
| sw[6] | 날짜 설정 모드 |

---

## 🎮 버튼 기능

### ⏰ 시간 설정 모드 (sw[1])

- btnU → 시간 증가
- btnL → 시간 감소
- btnR → 분 증가
- btnD → 분 감소

### 📆 연도 설정 모드 (sw[5])

- btnU → 연도 증가
- btnD → 연도 감소

### 📅 날짜 설정 모드 (sw[6])

- btnU → 월 증가
- btnL → 월 감소
- btnR → 일 증가
- btnD → 일 감소

---

## 📅 날짜 처리

설계에서는 각 달의 일수(30일/31일)를 관리하며, 월과 연도가 올바르게 넘어가도록 처리합니다.

### 📆 윤년 지원

2월의 날짜를 정확하게 처리하기 위해 윤년을 고려합니다.

```verilog
assign is_leap_year =
    (year % 4 == 0 && year % 100 != 0) ||
    (year % 400 == 0);
```

이를 통해 윤년에는 2월이 29일까지, 평년에는 28일까지 계산됩니다.

---

## 📊 요일 계산

요일을 단순히 하루씩 증가시키는 방식이 아니라, 현재 날짜(연도, 월, 일)를 기반으로 직접 계산합니다.

따라서 날짜를 수동으로 변경하더라도 항상 올바른 요일이 표시됩니다.

구현에는 **젤러의 공식(Zeller's Congruence)** 을 사용했습니다.

```verilog
weekday = (h + 6) % 7;
```

---

## 📊 요일 표현

| 값 | 요일 |
|----|------|
| 0 | 일요일 |
| 1 | 월요일 |
| 2 | 화요일 |
| 3 | 수요일 |
| 4 | 목요일 |
| 5 | 금요일 |
| 6 | 토요일 |

LED 출력은 다음과 같이 구현됩니다.

```verilog
assign led_ext = 7'b0000001 << weekday;
```

---

## 🧠 설계 구조

```text
Clock Divider
      ↓
Second Counter
      ↓
Time Counter
      ↓
Date Counter
      ↓
Weekday Calculation
      ↓
FND Display / LED Output
```

### 설계 특징

- 시간과 날짜를 분리한 모듈형 설계
- 클록 기반의 동기식(Synchronous) 로직
- 버튼 입력은 펄스 신호를 이용하여 처리

---

## 🧪 시뮬레이션

### ✔ 테스트한 모듈

- `date_counter`

### ✔ 검증 내용

- 날짜 증가
- 월 변경(30일/31일 처리)
- 연도 변경
- 날짜 수동 설정
- 요일 계산의 정확성

---

## 📷 결과

### 🔹 시뮬레이션 파형

<img width="1038" height="535" alt="image(95)" src="https://github.com/user-attachments/assets/14a1fee5-9cef-4619-b5c9-ae03e396d1f9" />

### 🔹 FPGA 보드

![board](./images/board.jpg)

---

## 📁 프로젝트 구조

```text
src/
├── clock_counter_hhmm.v
├── dp_blink_1hz.v
├── date_counter.v
├── second_counter_60.v
├── clock_divider_1s.v
├── fnd_decoder.v
├── fnd_mux_4digit.v
├── fnd_scan_counter.v
└── basys3_hhmm_clock_top.v

tb/
└── tb_date_counter.v

constraints/
└── g.xdc
```

---

## 🚀 향후 개선 사항

- 윤년 처리 기능 개선
- 요일 계산 알고리즘 최적화
- 알람 기능 추가
- UI/UX 개선 (선택 항목 깜빡임 표시 등)

---

## 📌 제작자

- FPGA 디지털 시계 프로젝트
- Verilog / Basys3
