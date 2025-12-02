# Day 02: Gift Shop - Strategy Benchmark

## System Information

| Property | Value |
|----------|-------|
| OS | FreeBSD 14.3-RELEASE |
| Host | nexus |
| CPU | Intel(R) N95 |
| Cores | 4 |
| RAM | 15GB |
| Ruby | 3.3.8 [amd64-freebsd14] |
| Date | 2025-12-02 04:50:00 -0500 |

## Strategies Tested

| Strategy | Complexity | Description |
|----------|------------|-------------|
| `brute_force` | O(n) | Single-threaded, string split check |
| `string_check` | O(n) | Single-threaded, regex backreference |
| `multiplier` | O(log n) | Mathematical: `pattern * (10^d + 1)` |
| `parallel_brute` | O(n/p) | Multi-process via `parallel` gem |
| `ractor_brute` | O(n/p) | Ruby 3 Ractors (experimental) |

---

## Scenario Results

### Tiny (600 numbers)

**Ranges:** `10-110`, `1,000-1,500`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | 0.000231s | |
| string_check | 0.000292s | |
| multiplier | **0.000024s** | ⚡ Fastest |
| parallel_brute | 0.018451s | Process overhead dominates |
| ractor_brute | 0.002472s | |

**Result:** 6,555 ✓

---

### Small (30,000 numbers)

**Ranges:** `0-10,000`, `100,000-110,000`, `1,000,000-1,010,000`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | 0.010968s | |
| string_check | 0.012315s | |
| multiplier | **0.000026s** | ⚡ 420x faster |
| parallel_brute | 0.021274s | Overhead still dominates |
| ractor_brute | 0.009560s | |

**Result:** 1,541,945 ✓

---

### Medium (300,000 numbers)

**Ranges:** `0-100,000`, `1,000,000-1,100,000`, `10,000,000-10,100,000`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | 0.085377s | |
| string_check | 0.111320s | Regex slower |
| multiplier | **0.000036s** | ⚡ 2,400x faster |
| parallel_brute | 0.060403s | Starting to help |
| ractor_brute | 0.070977s | |

**Result:** 100,955,945 ✓

---

### Large (3,000,000 numbers)

**Ranges:** `0-1,000,000`, `10,000,000-11,000,000`, `100,000,000-101,000,000`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | 1.065879s | |
| string_check | 1.472605s | |
| multiplier | **0.000037s** | ⚡ 29,000x faster |
| parallel_brute | 0.465667s | 2.3x speedup |
| ractor_brute | 1.033273s | Overhead hurts |

**Result:** 1,545,145,400 ✓

---

### Huge (20,000,000 numbers)

**Ranges:** `0-10,000,000`, `1,000,000,000-1,010,000,000`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | 7.010930s | |
| string_check | 10.569443s | |
| multiplier | **0.000036s** | ⚡ 195,000x faster |
| parallel_brute | 3.410415s | 2.1x speedup |
| ractor_brute | 5.427417s | GVL issues |

**Result:** 100,991,545,400 ✓

---

### Extreme (200,000,000 numbers)

**Ranges:** `0-100,000,000`, `1,000,000,000,000-1,000,100,000,000`

| Strategy | Real Time | Notes |
|----------|-----------|-------|
| brute_force | ⏭️ skipped | Too slow |
| string_check | ⏭️ skipped | Too slow |
| multiplier | **0.000032s** | ⚡ Instant |
| parallel_brute | 28.647148s | |
| ractor_brute | ⏭️ skipped | Overhead too high |

**Result:** 495,500,035,950 ✓

---

## Multiplier Strategy Scaling

The mathematical approach maintains constant time regardless of input size:

| Range Size | Time (seconds) | Invalid IDs Found |
|------------|----------------|-------------------|
| 1,000 | 0.000040 | 495 |
| 10,000 | 0.000013 | 495,900 |
| 100,000 | 0.000011 | 495,900 |
| 1,000,000 | 0.000011 | 495,540,450 |
| 10,000,000 | 0.000011 | 495,540,450 |
| 100,000,000 | 0.000010 | 495,500,035,950 |
| 1,000,000,000 | 0.000013 | 495,500,035,950 |

> **Note:** The multiplier strategy is O(log n) - time barely increases with range size.

---

## Parallel Scaling (20M numbers)

| Strategy | Time (s) | Speedup vs brute |
|----------|----------|------------------|
| brute_force | 7.022 | 1.0x |
| parallel_brute | 3.521 | **2.0x** |
| multiplier | 0.00005 | **151,335x** |

---

## Key Insights

1. **Mathematical wins**: The `multiplier` strategy is 150,000x faster than brute force by avoiding iteration entirely.

2. **Parallel overhead**: For inputs < 100K, parallelism overhead exceeds the computation time.

3. **Ractor limitations**: Ruby's experimental Ractors have significant overhead and don't outperform the `parallel` gem.

4. **Regex is slower**: The backreference regex `^(.+)\1$` is slower than simple string slicing.

5. **Sweet spot for parallel**: The `parallel` gem provides ~2x speedup on 4 cores for inputs > 1M numbers.

## The Algorithm

Invalid IDs are numbers where a digit sequence repeats exactly twice (e.g., `6464 = 64 × 101`).

Instead of checking every number, we use:

```ruby
# For d-digit patterns, multiplier = 10^d + 1
# Example: 2-digit patterns use 101
#          64 × 101 = 6464

(1..max_digits).each do |d|
  mult = 10 ** d + 1
  # Sum patterns in range using arithmetic series
  pattern_sum = count * (lo + hi) / 2
  total += pattern_sum * mult
end
```

This reduces O(n) iteration to O(log n) arithmetic.
