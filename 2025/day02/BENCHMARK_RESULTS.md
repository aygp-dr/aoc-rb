Day 02: Gift Shop - Strategy Benchmark
----------------------------------------------------------------------
FreeBSD nexus 14.3-RELEASE FreeBSD 14.3-RELEASE releng/14.3-n271432-8c9ce319fef7 GENERIC amd64
CPU: Intel(R) N95, 4 cores, 15GB RAM
Ruby: 3.3.8 [amd64-freebsd14]
Parallel CPUs: 4
----------------------------------------------------------------------
2025-12-02 04:50:00 -0500


======================================================================
Scenario: tiny
Ranges: 10-110, 1,000-1,500
Total numbers to check (brute force): 600
======================================================================
                         user     system      total        real
brute_force:         0.000235   0.000000   0.000235 (  0.000231)
string_check:        0.000293   0.000000   0.000293 (  0.000292)
multiplier:          0.000025   0.000000   0.000025 (  0.000024)
parallel_brute:      0.013608   0.000000   0.019333 (  0.018451)
ractor_brute:        0.002510   0.000000   0.002510 (  0.002472)

Result: 6,555
✓ All strategies agree

======================================================================
Scenario: small
Ranges: 0-10,000, 100,000-110,000, 1,000,000-1,010,000
Total numbers to check (brute force): 30,000
======================================================================
                         user     system      total        real
brute_force:         0.010973   0.000000   0.010973 (  0.010968)
string_check:        0.012315   0.000000   0.012315 (  0.012315)
multiplier:          0.000027   0.000000   0.000027 (  0.000026)
parallel_brute:      0.000000   0.015238   0.052722 (  0.021274)
ractor_brute:        0.020240   0.000000   0.020240 (  0.009560)

Result: 1,541,945
✓ All strategies agree

======================================================================
Scenario: medium
Ranges: 0-100,000, 1,000,000-1,100,000, 10,000,000-10,100,000
Total numbers to check (brute force): 300,000
======================================================================
                         user     system      total        real
brute_force:         0.085183   0.000000   0.085183 (  0.085377)
string_check:        0.110939   0.000180   0.111119 (  0.111320)
multiplier:          0.000034   0.000002   0.000036 (  0.000036)
parallel_brute:      0.012173   0.014431   0.161611 (  0.060403)
ractor_brute:        0.159750   0.002721   0.162471 (  0.070977)

Result: 100,955,945
✓ All strategies agree

======================================================================
Scenario: large
Ranges: 0-1,000,000, 10,000,000-11,000,000, 100,000,000-101,000,000
Total numbers to check (brute force): 3,000,000
======================================================================
                         user     system      total        real
brute_force:         1.066025   0.000000   1.066025 (  1.065879)
string_check:        1.470655   0.000000   1.470655 (  1.472605)
multiplier:          0.000037   0.000000   0.000037 (  0.000037)
parallel_brute:      0.098705   0.022600   1.342378 (  0.465667)
ractor_brute:        2.401479   0.102212   2.503691 (  1.033273)

Result: 1,545,145,400
✓ All strategies agree

======================================================================
Scenario: huge
Ranges: 0-10,000,000, 1,000,000,000-1,010,000,000
Total numbers to check (brute force): 20,000,000
======================================================================
                         user     system      total        real
brute_force:         6.914292   0.008058   6.922350 (  7.010930)
string_check:       10.478116   0.000000  10.478116 ( 10.569443)
multiplier:          0.000037   0.000000   0.000037 (  0.000036)
parallel_brute:      0.655509   0.094411   7.886937 (  3.410415)
ractor_brute:       11.885368   0.550823  12.436191 (  5.427417)

Result: 100,991,545,400
✓ All strategies agree

======================================================================
Scenario: extreme
Ranges: 0-100,000,000, 1,000,000,000,000-1,000,100,000,000
Total numbers to check (brute force): 200,000,000
======================================================================
                         user     system      total        real
  brute_force        (skipped - single-threaded too slow)
  string_check       (skipped - single-threaded too slow)
multiplier:          0.000032   0.000001   0.000033 (  0.000032)
parallel_brute:      6.684940   0.756327  79.355486 ( 28.647148)
  ractor_brute       (skipped - ractor overhead too high)

Result: 495,500,035,950
✓ All strategies agree


======================================================================
TIMING SUMMARY: multiplier strategy on increasing range sizes
======================================================================

| Range Size      | Time (seconds) | Invalid IDs Found |
|-----------------|----------------|-------------------|
|           1,000 | 4.0e-05        |               495 |
|          10,000 | 1.3e-05        |           495,900 |
|         100,000 | 1.1e-05        |           495,900 |
|       1,000,000 | 1.1e-05        |       495,540,450 |
|      10,000,000 | 1.1e-05        |       495,540,450 |
|     100,000,000 | 1.0e-05        |   495,500,035,950 |
|   1,000,000,000 | 1.3e-05        |   495,500,035,950 |

Note: multiplier strategy is O(log n) - time barely increases with range size


======================================================================
PARALLEL SCALING: comparing single vs multi-core on 20M numbers
======================================================================

| Strategy         | Time (s)  | Speedup vs brute |
|------------------|-----------|------------------|
| brute_force      | 7.022     |             1.0x |
| parallel_brute   | 3.521     |             2.0x |
| multiplier       | 0.0       |        151335.5x |
