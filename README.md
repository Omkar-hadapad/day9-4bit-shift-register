# Day 9 --- 4-bit Shift Register: Asynchronous vs Synchronous Reset

```{=html}
<p align="center">
```
`<b>`{=html}Digital VLSI • Verilog RTL • Sequential Logic • Functional
Verification • Cadence Genus`</b>`{=html}
```{=html}
</p>
```
```{=html}
<p align="center">
```
`<code>`{=html}Specification → Architecture → RTL → Simulation →
Synthesis → Technology Mapping → Timing → Power → PPA`</code>`{=html}
```{=html}
</p>
```

------------------------------------------------------------------------

# 1. Project Information

  -----------------------------------------------------------------------
  Parameter                           Details
  ----------------------------------- -----------------------------------
  **Project**                         Day 9 --- 4-bit Shift Register

  **Domain**                          Digital VLSI / RTL Design

  **Design Type**                     Sequential Logic

  **HDL**                             Verilog HDL

  **Target Technology**               TSMC 180 nm

  **Library**                         `tsmc18`

  **Synthesis Tool**                  Cadence Genus 21.14-s082_1

  **Operating Condition**             `slow (balanced_tree)`

  **Wireload Mode**                   `enclosed`

  **Clocking**                        Positive-edge triggered

  **Reset Implementations**           Asynchronous Reset and Synchronous
                                      Reset

  **Register Width**                  4 bits

  **Main Function**                   Serial-in, parallel-out 4-bit shift
                                      register

  **Analysis**                        Functional Simulation, Hierarchy,
                                      Area, Power, Timing, PPA

  **Status**                          RTL, simulation, synthesis and PPA
                                      analysis completed with a
                                      synchronous-reset verification gap
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 2. Project Overview

A **shift register** is a sequential digital circuit used to store and
shift binary data from one flip-flop to another on a clock edge.

This Day-9 project implements two 4-bit shift-register architectures:

1.  `shift_register_4bit_async` --- 4-bit shift register with
    asynchronous reset.
2.  `shift_register_4bit_sync` --- 4-bit shift register with synchronous
    reset.

Both implementations are placed inside:

``` text
shift_register_4bit_top
```

The project compares the reset behavior and synthesized implementation
of the two architectures.

The design is taken through:

``` text
RTL
 ↓
Simulation
 ↓
Verification
 ↓
Synthesis
 ↓
Technology Mapping
 ↓
Area
 ↓
Timing
 ↓
Power
 ↓
PPA
```

------------------------------------------------------------------------

# 3. Objective

The main objectives are:

1.  Understand 4-bit sequential storage.
2.  Understand serial shifting.
3.  Understand positive-edge-triggered operation.
4.  Understand asynchronous reset.
5.  Understand synchronous reset.
6.  Compare asynchronous and synchronous reset behavior.
7.  Write synthesizable Verilog RTL.
8.  Verify the design using simulation and waveforms.
9.  Analyze the synthesized hierarchy.
10. Analyze technology-mapped standard cells.
11. Analyze area.
12. Analyze power.
13. Analyze timing slack.
14. Understand the relationship between RTL and synthesized hardware.
15. Build an industry-style RTL-to-PPA project.

------------------------------------------------------------------------

# 4. Shift Register Concept

A 4-bit shift register contains four storage elements.

Conceptually:

``` text
Serial In
   │
   ▼
+------+    +------+    +------+    +------+
| DFF3 | -> | DFF2 | -> | DFF1 | -> | DFF0 |
+------+    +------+    +------+    +------+
   │           │           │           │
   └───────────┴───────────┴───────────┴──> Q[3:0]
```

On each active clock edge, the stored bits move by one position and the
new serial input enters the register.

For the implemented shift direction:

``` text
Q(next) = {serial_in, Q[3:1]}
```

The exact RTL expression should be interpreted according to the
implemented source code and port ordering.

------------------------------------------------------------------------

# 5. Hardware View

The conceptual hardware is:

``` text
                  CLK
                   │
          ┌────────┼────────┬────────┬────────┐
          ▼        ▼        ▼        ▼
Serial → DFF3 →    DFF2 →   DFF1 →   DFF0
          │         │         │         │
          ▼         ▼         ▼         ▼
         Q[3]      Q[2]      Q[1]      Q[0]
```

Each DFF stores one bit.

Therefore:

``` text
4-bit shift register
        ↓
4 sequential storage elements
```

Because the top-level design contains both implementations:

``` text
shift_register_4bit_top
│
├── ASYNC_SHIFT
│   └── 4 DFFs
│
└── SYNC_SHIFT
    └── 4 DFFs
```

the top-level synthesized design contains eight logical sequential
storage elements.

------------------------------------------------------------------------

# 6. Asynchronous vs Synchronous Reset

## Asynchronous Reset

An asynchronous reset affects the register independently of the clock.

Conceptually:

``` text
RESET ───────────────► Q = 0000
                         │
                         │ no clock edge required
                         ▼
```

When reset is asserted, the output can change immediately.

### Key property

``` text
Reset assertion → immediate state initialization
```

------------------------------------------------------------------------

## Synchronous Reset

A synchronous reset is sampled on the active clock edge.

Conceptually:

``` text
RESET = 1
    │
    │
    ▼
Rising CLK edge
    │
    ▼
Q = 0000
```

If reset changes between clock edges, the stored state does not change
immediately.

### Key property

``` text
Reset assertion → wait for active clock edge → state changes
```

------------------------------------------------------------------------

# 7. Reset Comparison

  -----------------------------------------------------------------------
  Feature                 Asynchronous Reset      Synchronous Reset
  ----------------------- ----------------------- -----------------------
  Requires clock edge for No                      Yes
  reset assertion                                 

  Reset can change state  Yes                     No
  immediately                                     

  Reset sampled by clock  No                      Yes

  Main advantage          Fast initialization     Clock-controlled reset
                                                  behavior

  Main verification point Reset without clock     Reset across active
                                                  clock edge
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 8. Functional Specification

## Inputs

  Signal          Description
  --------------- -------------------------------
  `clk`           Positive-edge-triggered clock
  `reset_async`   Asynchronous reset control
  `reset_sync`    Synchronous reset control
  `serial_in`     Serial data input

## Outputs

  Signal           Description
  ---------------- ---------------------------------------------
  `q_async[3:0]`   Output of asynchronous-reset shift register
  `q_sync[3:0]`    Output of synchronous-reset shift register

------------------------------------------------------------------------

# 9. Functional Behavior

## Normal Shift

At every rising edge of `clk`:

``` text
serial_in
    ↓
new register bit
    ↓
previous register bits shift
```

Example sequence:

``` text
Initial:
0000

serial_in = 1
→ 1000

serial_in = 0
→ 0100

serial_in = 1
→ 1010

serial_in = 1
→ 1101
```

The simulation results confirm this sequence for the known data portion.

------------------------------------------------------------------------

# 10. Reset Behavior

## Asynchronous Reset

When:

``` text
reset_async = 1
```

the register is cleared immediately:

``` text
q_async = 0000
```

This does not require a clock edge.

------------------------------------------------------------------------

## Synchronous Reset

When:

``` text
reset_sync = 1
```

the output remains unchanged until the active clock edge.

The reset must remain asserted through a rising clock edge to
demonstrate:

``` text
q_sync = 0000
```

------------------------------------------------------------------------

# 11. Logical Hierarchy

Genus reported the following hierarchy:

``` text
shift_register_4bit_top
│
├── ASYNC_SHIFT (shift_register_4bit_async)
│   ├── DFF0
│   ├── DFF1
│   ├── DFF2
│   └── DFF3
│
└── SYNC_SHIFT (shift_register_4bit_sync)
    ├── DFF0
    ├── DFF1
    ├── DFF2
    └── DFF3
```

The top-level design therefore contains:

``` text
4 async-reset storage elements
+
4 sync-reset storage elements
=
8 logical sequential elements
```

------------------------------------------------------------------------

# 12. Simulation and Waveform

The simulation was performed using Cadence NC-Sim/SimVision.

Signals observed:

``` text
clk
reset_sync
reset_async
serial_in
q_sync[3:0]
q_async[3:0]
```

The waveform is stored in the project as:

``` text
images/day9_waveform.png
```

Recommended repository evidence:

``` text
images/
└── day9_waveform.png
```

------------------------------------------------------------------------

# 13. Simulation Results

The simulation completed successfully:

``` text
Simulation complete via $finish(1) at time 71 ns
```

### Normal shifting

Observed sequence:

``` text
Q_ASYNC:
0000 → 1000 → 0100 → 1010 → 1101
```

The synchronous output initially contains unknown bits because its state
has not yet been initialized by a synchronous reset edge.

Observed progression:

``` text
1xxx
 ↓
01xx
 ↓
101x
 ↓
1101
```

The unknown bits are progressively replaced by known serial data.

------------------------------------------------------------------------

# 14. Asynchronous Reset Verification

The asynchronous reset test demonstrates:

``` text
TIME = 45 ns
ASYNC_RST = 1
Q_ASYNC = 0000
```

The clock does not need to transition for the asynchronous reset to
clear the register.

The testbench explicitly checks:

``` text
ASYNC RESET ASSERTED WITHOUT CLOCK
Q_ASYNC = 0000
```

### Result

``` text
PASS
```

------------------------------------------------------------------------

# 15. Synchronous Reset Verification

The synchronous reset test demonstrates that asserting the reset does
not immediately modify the register.

Observed:

``` text
SYNC_RST = 1
Q_SYNC = 1111
```

before the required active clock edge.

However, in the supplied test sequence, `SYNC_RST` was released before
the next rising clock edge.

Therefore, the testbench did not fully demonstrate:

``` text
SYNC_RST = 1
        ↓
Rising CLK edge
        ↓
Q_SYNC = 0000
```

### Result

``` text
PARTIAL PASS
```

This is a **testbench verification gap**, not evidence of an RTL
failure.

------------------------------------------------------------------------

# 16. Verification Summary

  Test                               Result
  ---------------------------------- ------------------------
  Clock generation                   PASS
  Serial input stimulus              PASS
  Asynchronous reset                 PASS
  Asynchronous shift operation       PASS
  Synchronous shift operation        PASS
  Initial unknown-state behavior     Expected
  Async reset without clock          PASS
  Sync reset without clock           PASS
  Sync reset clears on rising edge   Not fully demonstrated
  Simulation completion              PASS

### Overall verification status

``` text
PASS WITH ONE VERIFICATION GAP
```

------------------------------------------------------------------------

# 17. Waveform Interpretation

The main waveform behavior is:

``` text
             RESET
               │
       ┌───────┴────────┐
       ▼                ▼
  ASYNC RESET       SYNC RESET
       │                │
       ▼                ▼
Q changes          Q waits for
immediately        clock edge
```

The waveform therefore provides direct visual evidence of the
fundamental difference between asynchronous and synchronous reset.

------------------------------------------------------------------------

# 18. Synthesis Flow

The project follows:

``` text
                  RTL
                   │
                   ▼
             Elaboration
                   │
                   ▼
            Generic Logic
                   │
                   ▼
             Optimization
                   │
                   ▼
          Technology Mapping
                   │
                   ▼
             TSMC18 Cells
                   │
          ┌────────┼────────┐
          ▼        ▼        ▼
        Area     Timing   Power
```

Cadence Genus 21.14-s082_1 was used for synthesis.

------------------------------------------------------------------------

# 19. Technology Mapping

The synthesized top-level design contains the following mapped cells:

``` text
DFFRHQX1   × 2
DFFRHQXL   × 2
DFFTRXL    × 4
INVX1      × 4
INVXL      × 4
```

Total:

``` text
16 mapped standard-cell instances
```

The eight sequential cells correspond to the eight logical storage
elements, while the eight inverter cells represent additional
synthesized support logic.

------------------------------------------------------------------------

# 20. Area Analysis

## Top-Level Area

``` text
Total Cell Area = 558.835
```

The report gives:

``` text
Cell Count = 16
Cell Area  = 558.835
Net Area   = 0
Total Area = 558.835
```

This is **synthesis cell area**, not physical post-layout area.

------------------------------------------------------------------------

# 21. Area Distribution

  Cell Type          Instances          Area     Area %
  ---------------- ----------- ------------- ----------
  Sequential                 8       505.613      90.5%
  Inverter                   8        53.222       9.5%
  Physical cells             0         0.000       0.0%
  **Total**             **16**   **558.835**   **100%**

### Observation

Sequential logic dominates the area:

``` text
Sequential area ≈ 90.5%
```

This is expected for a design whose primary function is storage and
shifting.

------------------------------------------------------------------------

# 22. Async vs Sync Area

The hierarchy/area report gives:

  Block               Cell Area
  --------------- -------------
  `ASYNC_SHIFT`         306.029
  `SYNC_SHIFT`          252.806
  **Top-level**     **558.835**

Difference:

``` text
306.029 - 252.806
= 53.223
```

Relative to the synchronous implementation:

``` text
(306.029 - 252.806) / 252.806 × 100
≈ 21.05%
```

Therefore, for this specific library and synthesis configuration:

``` text
ASYNC_SHIFT area ≈ 21.05% higher than SYNC_SHIFT area
```

This comparison is specific to the reported synthesis result and should
not be generalized to all technologies or libraries.

------------------------------------------------------------------------

# 23. Power Analysis

The Genus power report gives:

``` text
Power Unit = W
PDB Frame  = /stim#0/frame#0
```

Total reported power:

``` text
5.38157 × 10⁻⁵ W
```

Therefore:

``` text
Total Power = 53.8157 µW
```

This value corresponds to the reported power-analysis frame and
conditions.

------------------------------------------------------------------------

# 24. Power Breakdown

  Category         Total Power   Percentage
  ----------- ---------------- ------------
  Register          47.8529 µW       88.92%
  Logic             1.02891 µW        1.91%
  Clock             4.93387 µW        9.17%
  Memory                     0           0%
  Latch                      0           0%
  Pad                        0           0%
  **Total**     **53.8157 µW**     **100%**

### Observation

Register power dominates:

``` text
Register Power = 47.8529 µW
Register Power ≈ 88.92%
```

This agrees with the area result where sequential hardware also
dominates the design.

------------------------------------------------------------------------

# 25. Internal, Switching and Leakage Power

  Power Component              Value   Percentage
  ----------------- ---------------- ------------
  Leakage                  0.0151 µW        0.03%
  Internal                48.0322 µW       89.25%
  Switching                5.7684 µW       10.72%
  **Total**           **53.8157 µW**     **100%**

The reported power is therefore dominated by internal power.

------------------------------------------------------------------------

# 26. Timing Analysis

The supplied Genus timing report contains:

``` text
Slack = +7721 ps
```

Therefore:

``` text
Slack = +7.721 ns
```

The reported path is an input-to-register setup path:

``` text
Startpoint:
reset_sync

Endpoint:
SYNC_SHIFT/DFF3/q_reg/D
```

The path includes an inverter before the register D input.

### Timing status

``` text
MET
```

Positive slack indicates that this reported setup constraint is
satisfied.

------------------------------------------------------------------------

# 27. Timing Limitation

The reported timing path is:

``` text
reset_sync → INVX1 → DFF3/D
```

It is an **input-to-register path**, not a normal register-to-register
critical path.

Therefore:

``` text
+7.721 ns slack
```

should **not** be used alone to claim:

``` text
Maximum operating frequency
```

or:

``` text
Critical path of the shift register
```

A proper functional performance analysis should obtain a path such as:

``` text
Register Q
    ↓
Combinational logic
    ↓
Register D
```

and use that path to evaluate the actual functional critical path and
maximum frequency.

------------------------------------------------------------------------

# 28. PPA Summary

PPA means:

``` text
P = Power
P = Performance
A = Area
```

Current measured results:

  Metric                               Result
  -------------------------- ----------------
  **Total Area**                  **558.835**
  **Sequential Area**             **505.613**
  **Sequential Area %**             **90.5%**
  **Total Power**              **53.8157 µW**
  **Register Power**           **47.8529 µW**
  **Clock Power**              **4.93387 µW**
  **Logic Power**              **1.02891 µW**
  **Reported Setup Slack**      **+7.721 ns**
  **Mapped Cell Count**                **16**

### Important timing qualification

The reported `+7.721 ns` slack belongs to an input-to-register reset
path.

It does not establish the functional register-to-register critical path
or maximum functional frequency.

------------------------------------------------------------------------

# 29. Main Engineering Observations

### Area

``` text
Sequential hardware → 90.5% of total area
```

### Power

``` text
Register power → 88.92% of total power
```

### Reset comparison

``` text
Async reset:
Immediate response without clock

Sync reset:
Response requires active clock edge
```

### Architecture comparison

``` text
ASYNC_SHIFT = 306.029 area units
SYNC_SHIFT  = 252.806 area units
```

For this synthesis configuration, the asynchronous implementation is
approximately 21.05% larger.

------------------------------------------------------------------------

# 30. Optimization Considerations

## Area

Potential directions:

-   Avoid unnecessary duplicate implementations when only one
    architecture is required.
-   Reduce unnecessary control logic.
-   Select suitable standard-cell implementations.
-   Evaluate reset architecture based on system requirements.

## Power

Potential directions:

-   Reduce unnecessary register switching.
-   Reduce unnecessary clock activity.
-   Use enable-based activity control where appropriate.
-   Evaluate suitable low-power standard cells if available.

## Timing

Potential directions:

-   Obtain the actual register-to-register critical path.
-   Reduce combinational delay.
-   Optimize fanout.
-   Use appropriate cell drive strength.
-   Apply correct clock and I/O constraints.

### PPA trade-off

``` text
Area ↔ Power ↔ Timing
```

An optimization for one metric can affect the others.

------------------------------------------------------------------------

# 31. Common Design Mistakes

1.  Incorrect clock edge.
2.  Incorrect reset sensitivity.
3.  Confusing asynchronous and synchronous reset.
4.  Releasing synchronous reset before a clock edge during verification.
5.  Incorrect shift direction.
6.  Incorrect bit ordering.
7.  Incorrect register width.
8.  Using blocking assignments for sequential state.
9.  Incorrect reset priority.
10. Incorrect testbench sampling around clock edges.
11. Assuming `X` values automatically indicate an RTL bug.
12. Treating a combined top-level area as the area of one submodule.
13. Treating synthesis cell area as physical layout area.
14. Claiming maximum frequency from an input-to-register timing path.
15. Comparing power between async and sync implementations without
    separate power reports.

------------------------------------------------------------------------

# 32. Verification Status

  Verification Stage                    Status
  ------------------------------------- ----------------------------
  Specification                         Completed
  Architecture                          Completed
  RTL                                   Completed
  Simulation                            Completed
  Waveform inspection                   Completed
  Async reset verification              Completed
  Sync reset immediate-response check   Completed
  Sync reset clear-on-clock check       **Not fully demonstrated**
  Hierarchy                             Completed
  Synthesis                             Completed
  Technology Mapping                    Completed
  Area Analysis                         Completed
  Power Analysis                        Completed
  Timing Analysis                       Completed
  Functional critical-path timing       Not established
  Optimization                          Not performed
  Documentation                         Completed

------------------------------------------------------------------------

# 33. Project Evidence

Recommended evidence files:

``` text
✓ RTL source
✓ Testbench
✓ Simulation log
✓ SimVision waveform
✓ Genus hierarchy report
✓ Genus cell report
✓ Genus area report
✓ Genus power report
✓ Genus timing report
```

Recommended repository organization:

``` text
day9-4bit-shift-register/
│
├── README.md
├── rtl/
├── tb/
├── sim/
├── synthesis/
├── constraints/
├── images/
└── docs/
```

------------------------------------------------------------------------

# 34. Recommended Repository Structure

``` text
day9-4bit-shift-register/
│
├── README.md
│
├── rtl/
│   ├── shift_register_4bit_async.v
│   ├── shift_register_4bit_sync.v
│   └── shift_register_4bit_top.v
│
├── tb/
│   └── day9_tb.v
│
├── sim/
│   ├── waveform/
│   │   └── waves.shm/
│   └── simulation_results/
│       └── simulation.log
│
├── synthesis/
│   ├── reports/
│   │   ├── hierarchy.rpt
│   │   ├── area.rpt
│   │   ├── cells.rpt
│   │   ├── power.rpt
│   │   └── timing.rpt
│   │
│   └── netlist/
│       └── shift_register_4bit_top.v
│
├── constraints/
│   └── constraints_top.sdc
│
├── images/
│   └── day9_waveform.png
│
└── docs/
    └── Day9_4bit_Shift_Register_Report.pdf
```

------------------------------------------------------------------------

# 35. Industry Relevance

Shift registers are fundamental sequential structures used in:

-   Serial-to-parallel conversion
-   Parallel-to-serial conversion
-   Data buffering
-   Communication interfaces
-   Pipeline structures
-   Digital control systems
-   Test and scan structures
-   ASIC and FPGA designs
-   Data-path control
-   Protocol interfaces

Understanding asynchronous and synchronous reset behavior is important
for reliable RTL design and verification.

------------------------------------------------------------------------

# 36. GATE Relevance

This project is directly related to:

### Sequential Circuits

-   Flip-flops
-   Registers
-   Shift registers
-   Clocked state storage

### Timing

-   Clock edge
-   Setup time
-   Reset behavior
-   Timing constraints

### Digital Design

-   Serial data movement
-   State transitions
-   Sequential logic

### Important GATE concept

A synchronous reset changes state only when the reset is sampled at the
active clock edge, whereas an asynchronous reset can affect state
independently of the clock.

------------------------------------------------------------------------

# 37. Interview Questions

## Basic

1.  What is a shift register?
2.  What is the difference between serial and parallel data?
3.  What is a 4-bit shift register?
4.  What is the purpose of a clock?
5.  What is asynchronous reset?
6.  What is synchronous reset?

## RTL

7.  How do you describe a shift register in Verilog?
8.  Why are nonblocking assignments used for sequential logic?
9.  How do you control the shift direction?
10. What happens when the serial input changes?
11. Why can `X` values appear during simulation?
12. How do you verify a synchronous reset?

## Synthesis

13. How many logical flip-flops are present in the top-level
    architecture?
14. Why does the synthesized cell count differ from the logical
    flip-flop count?
15. What is technology mapping?
16. What is synthesis cell area?
17. Why should synthesis area not be called physical layout area?

## Timing

18. What is setup slack?
19. What does positive slack mean?
20. Why is an input-to-register path not sufficient to determine maximum
    frequency?
21. What is a register-to-register critical path?
22. What is the difference between setup and hold timing?

## PPA

23. What is PPA?
24. Why does sequential logic dominate the area?
25. Why does register power dominate this design?
26. What contributes to clock power?
27. How can shift-register power be reduced?
28. What are the area and power trade-offs of different reset
    architectures?

------------------------------------------------------------------------

# 38. Tiny Memory

Remember these points:

``` text
1. A shift register is sequential storage plus controlled data movement.

2. One 4-bit shift register requires four storage elements.

3. Asynchronous reset does not require a clock edge.

4. Synchronous reset requires the active clock edge.

5. X values can propagate until unknown register bits are replaced by known data.

6. Always verify reset behavior at the correct clock boundary.

7. Synthesis cell area is not physical layout area.

8. A valid critical-path timing report is required before claiming maximum frequency.
```

------------------------------------------------------------------------

# 39. Learning Outcome

After completing Day 9, the following concepts are strengthened:

-   Sequential logic
-   4-bit registers
-   Shift-register architecture
-   Serial data movement
-   Positive-edge clocking
-   Asynchronous reset
-   Synchronous reset
-   Reset verification
-   Verilog sequential RTL
-   SimVision waveform analysis
-   NC-Sim simulation
-   RTL-to-gate synthesis
-   Technology mapping
-   Standard-cell analysis
-   Area analysis
-   Power analysis
-   Timing slack interpretation
-   PPA analysis
-   Testbench debugging
-   ASIC synthesis methodology

------------------------------------------------------------------------

# 40. Project Status

``` text
┌──────────────────────────────────────────────┐
│          DAY 9 PROJECT STATUS                 │
├──────────────────────────────────────────────┤
│ Specification       : COMPLETED              │
│ Architecture        : COMPLETED              │
│ RTL                 : COMPLETED              │
│ Simulation          : COMPLETED              │
│ Waveform Analysis   : COMPLETED              │
│ Async Reset Test    : PASS                   │
│ Sync Reset Test     : PARTIAL                │
│ Hierarchy           : COMPLETED              │
│ Synthesis           : COMPLETED              │
│ Technology Mapping  : COMPLETED              │
│ Area Analysis       : COMPLETED              │
│ Power Analysis      : COMPLETED              │
│ Timing Analysis     : COMPLETED              │
│ Critical Path       : NOT FULLY ESTABLISHED  │
│ Optimization        : NOT STARTED            │
│ Documentation       : COMPLETED              │
└──────────────────────────────────────────────┘
```

------------------------------------------------------------------------

# 41. Final Day-9 Results

## Functional

``` text
Async reset:
PASS

Normal shifting:
PASS

Sync reset immediate behavior:
PASS

Sync reset clear-on-clock verification:
NOT FULLY DEMONSTRATED
```

## Area

``` text
Total mapped instances = 16

Total Cell Area = 558.835
```

## Sequential Area

``` text
Sequential Area = 505.613
Sequential Area = 90.5%
```

## Async vs Sync Area

``` text
ASYNC_SHIFT = 306.029
SYNC_SHIFT  = 252.806

Difference = 53.223

Async area relative to Sync ≈ 21.05% higher
```

## Power

``` text
Total Power = 53.8157 µW

Register = 47.8529 µW
Clock    = 4.93387 µW
Logic    = 1.02891 µW
```

## Timing

``` text
Reported Setup Slack = +7.721 ns
Status = MET
```

### Timing qualification

The reported timing path is:

``` text
reset_sync → inverter → SYNC_SHIFT/DFF3/D
```

It is an input-to-register setup path. It does not establish the
functional register-to-register critical path or maximum functional
frequency.

------------------------------------------------------------------------

# 42. Next Project --- Day 10

## Day 10 --- MOD-10 Counter

The next project moves from a shift register to a counter-based
sequential design.

Conceptually:

``` text
        +----------------+
CLK --->|                |
RESET ->|   MOD-10       |----> COUNT[3:0]
        |    COUNTER     |
        +----------------+
```

The counter will introduce:

``` text
Sequential State
      ↓
Next-State Logic
      ↓
Counter
      ↓
Verification
      ↓
Synthesis
      ↓
Timing
      ↓
Power
      ↓
PPA
```

------------------------------------------------------------------------

# 43. Author

**Omkar Kalmesh Hadapad**

B.E. Electronics & Communication Engineering\
SDM Institute of Technology, Ujire, Karnataka

**Focus Areas:**

``` text
Digital VLSI
RTL Design
Verilog HDL
ASIC Design
Design Verification
Cadence Genus
Cadence Innovus
PPA Optimization
```

------------------------------------------------------------------------

```{=html}
<p align="center">
```
`<b>`{=html}DAY 9 --- 4-BIT SHIFT REGISTER`</b>`{=html}
```{=html}
</p>
```
```{=html}
<p align="center">
```
`<code>`{=html}RTL → Simulation → Synthesis → Mapping → Area → Power →
Timing → PPA`</code>`{=html}
```{=html}
</p>
```
