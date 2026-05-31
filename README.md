# 🕒 FPGA Digital Clock with Calendar

## 📌 Overview
This project implements a digital clock with calendar functionality using Verilog on FPGA (Basys3).

It supports real-time clock display, date tracking, year display, and weekday indication using LEDs.

---

## ⚙️ Features

- ⏰ Real-time clock (HH:MM)
- 📅 Date display (MM.DD)
- 📆 Year display (YYYY)
- 🔁 12/24 hour mode
- 🎛️ Manual time/date adjustment
- 📊 Weekday calculation
- 💡 LED-based weekday indicator

---

## 🎛️ Switch Mapping

| Switch | Function |
|--------|--------|
| sw[0] | Clock enable |
| sw[1] | Time set mode |
| sw[2] | 12/24 hour mode |
| sw[3] | Year display |
| sw[4] | Date display |
| sw[5] | Year adjustment mode |
| sw[6] | Date adjustment mode |

---

## 🎮 Button Controls

### ⏰ Time Set Mode (sw[1])
- btnU → Hour increase  
- btnL → Hour decrease  
- btnR → Minute increase  
- btnD → Minute decrease  

### Year Set Mode (sw[5])
- btnU → Year increase
- btnD → Year decrease
  
### 📅 Date Set Mode (sw[6])
- btnU → Month increase  
- btnL → Month decrease  
- btnR → Day increase  
- btnD → Day decrease

---

## 📊 Weekday Representation

| Value | Day |
|------|-----|
| 0 | Sunday |
| 1 | Monday |
| 2 | Tuesday |
| 3 | Wednesday |
| 4 | Thursday |
| 5 | Friday |
| 6 | Saturday |

LED output logic:

```verilog
assign led_ext = 7'b0000001 << weekday;
```

---

## 🧠 Design Architecture

```
Clock Divider → Second Counter → Time Counter
                                ↓
                          Date Counter
                                ↓
                          Weekday Calculation
                                ↓
                        FND Display / LED Output
```

- Modular design (time / date separation)
- Synchronous logic based on clock
- Button input handling using pulse signals

---

## 🧪 Simulation

### ✔ Tested Module
- `date_counter`

### ✔ Verified Behavior
- Date increment
- Month rollover (30/31 days)
- Year rollover
- Manual date adjustment
- Weekday correctness

---

## 📷 Results
<img width="1038" height="535" alt="image(95)" src="https://github.com/user-attachments/assets/14a1fee5-9cef-4619-b5c9-ae03e396d1f9" />

### 🔹 Waveform
![Uploading image(95).png…]()


### 🔹 FPGA Board
![board](./images/board.jpg)

---

## 📁 Project Structure

```
src/
├── clock_counter_hhmm.v
├── date_counter.v
├── second_counter_60.v
├── clock_divider_1s.v
├── fnd_decoder.v
├── fnd_mux_4digit.v
├── fnd_scan_counter.v
└── basys3_hhmm_clock_top.v

tb/
└── tb_date_counter.v
```

---

## 🚀 Future Improvements

- Leap year handling
- More accurate weekday calculation
- Alarm function
- UI/UX enhancement (blinking selection)

---

## 📌 Author

- FPGA Digital Clock Project  
- Verilog / Basys3
