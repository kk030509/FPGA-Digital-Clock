# 🕒 FPGA 디지털 시계 (Digital Clock with Calendar)

## 📌 프로젝트 소개

Verilog HDL을 이용하여 Basys3 FPGA 보드에서 동작하는 디지털 시계 및 달력 시스템입니다.

실시간 시계, 날짜 관리, 요일 계산, 12/24시간 표시, 수동 시간 및 날짜 설정 기능을 제공합니다.

프로젝트는 기능별 모듈화(Modular Design)를 적용하여 유지보수성과 재사용성을 높였습니다.

---

## ⚙️ 개발 환경

- Language : Verilog HDL
- FPGA Board : Digilent Basys3
- FPGA : Xilinx Artix-7 XC7A35T
- Tool : Vivado

---

## ✨ 주요 기능

- ⏰ 실시간 시계(HH:MM)
- 📅 날짜 표시(YYYY.MM.DD)
- 📆 자동 날짜 갱신
- 📊 요일 자동 계산
- 🔁 12시간 / 24시간 표시
- 🎛 시간 및 날짜 수동 설정
- 💡 LED를 이용한 요일 표시
- ✨ 1Hz DP 점멸

---

## 🖥 시스템 구조

```
100MHz Clock
      │
      ▼
Clock Divider
      │
      ▼
Second Counter
      │
      ▼
Time Counter
      │
      ├─────────────┐
      ▼             ▼
Date Counter   Display Controller
      │             │
      ▼             ▼
Weekday Calc     FND Controller
      │             │
      └──────┬──────┘
             ▼
      7-Segment Display
```

---

## 📂 프로젝트 구조

```text
src/
├── basys3_hhmm_clock_top.v
├── btn_edge_detect.v
├── mode_decoder.v
├── clock_divider_1s.v
├── second_counter_60.v
├── clock_counter_hhmm.v
├── hour_format_conv.v
├── date_counter.v
├── calendar_utils.v
├── weekday_calc.v
├── year_to_bcd.v
├── display_mux_select.v
├── fnd_scan_counter.v
├── fnd_mux_4digit.v
├── fnd_decoder.v
├── dp_blink_1hz.v
└── status_led_driver.v
```

---

## 🧩 모듈 구성

| 모듈 | 기능 |
|------|------|
| basys3_hhmm_clock_top | 최상위 모듈 |
| btn_edge_detect | 버튼 입력 Edge 검출 |
| mode_decoder | 동작 모드 판별 |
| clock_divider_1s | 100MHz → 1Hz 분주 |
| second_counter_60 | 초 카운터 |
| clock_counter_hhmm | 시/분 카운터 |
| hour_format_conv | 12/24시간 변환 |
| date_counter | 날짜 관리 |
| calendar_utils | 윤년 및 마지막 날짜 계산 |
| weekday_calc | 요일 계산 |
| year_to_bcd | 연도 BCD 변환 |
| display_mux_select | 표시 데이터 선택 |
| fnd_scan_counter | FND 자리 선택 |
| fnd_mux_4digit | 표시 숫자 선택 |
| fnd_decoder | BCD → 7-Segment 변환 |
| dp_blink_1hz | DP 점멸 |
| status_led_driver | LED 상태 출력 |

---

## 🎮 스위치 기능

| 스위치 | 기능 |
|------|------|
| SW0 | 시계 동작 |
| SW1 | 날짜 표시 |
| SW2 | 연도 표시 |
| SW3 | 설정 모드 |
| SW4 | 12시간 / 24시간 표시 |

---

## 🎮 버튼 기능

### ⏰ 시간 설정 모드

- BTN U : 시간 증가
- BTN D : 분 감소
- BTN L : 시간 감소
- BTN R : 분 증가

### 📅 날짜 설정 모드

- BTN U : 월 증가
- BTN D : 일 감소
- BTN L : 월 감소
- BTN R : 일 증가

### 📆 연도 설정 모드

- BTN U : 연도 증가
- BTN D : 연도 감소

---

## 📅 날짜 및 요일 계산

- 윤년을 고려하여 2월의 날짜를 계산합니다.
- 월별 마지막 날짜를 자동으로 판별합니다.
- Zeller's Congruence를 이용하여 현재 날짜의 요일을 계산합니다.
- 날짜를 수동으로 변경해도 요일이 자동으로 갱신됩니다.

---

## 🚀 향후 개선 사항

- 알람 기능
- 타이머
- 스톱워치
- 부저 알림
- 공휴일 표시
- UI 개선

---

## 👨‍💻 개발 환경

Verilog HDL / Digilent Basys3 / Vivado
