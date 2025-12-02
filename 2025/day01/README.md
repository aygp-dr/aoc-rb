# Day 1: Secret Entrance

[Advent of Code 2025 - Day 1](https://adventofcode.com/2025/day/1)

## Problem

You need to open a safe to access the North Pole base. The safe has a circular dial displaying numbers 0-99.

### Dial Mechanics
- **Starting position:** 50
- **Size:** 100 positions (0-99)
- **Circular:** Moving left from 0 reaches 99; moving right from 99 reaches 0

### Rotation Commands
- `L#` - Move left (subtract) by # clicks
- `R#` - Move right (add) by # clicks

## Part 1: Count Zero Landings

**Task:** Count how many times the dial lands on 0 after any rotation in the sequence.

### Example

Starting at 50, with rotations: `L68, L30, R48, L5, R60, L55, L1, L99, R14, L82`

| Rotation | Calculation | Position | Zero? |
|----------|-------------|----------|-------|
| L68 | (50 - 68) % 100 | 82 | |
| L30 | (82 - 30) % 100 | 52 | |
| R48 | (52 + 48) % 100 | **0** | ✓ |
| L5 | (0 - 5) % 100 | 95 | |
| R60 | (95 + 60) % 100 | 55 | |
| L55 | (55 - 55) % 100 | **0** | ✓ |
| L1 | (0 - 1) % 100 | 99 | |
| L99 | (99 - 99) % 100 | **0** | ✓ |
| R14 | (0 + 14) % 100 | 14 | |
| L82 | (14 - 82) % 100 | 32 | |

**Answer:** 3 (the dial landed on 0 three times)

## Part 2

*Unlocks after completing Part 1*

## Solution Approach

```ruby
position = 50
zero_count = 0

rotations.each do |direction, amount|
  if direction == 'L'
    position = (position - amount) % 100
  else
    position = (position + amount) % 100
  end
  zero_count += 1 if position == 0
end
```

The key insight is using modulo arithmetic for the circular dial:
- `(position - amount) % 100` for left rotations
- `(position + amount) % 100` for right rotations

Ruby's modulo operator handles negative numbers correctly (e.g., `-5 % 100 = 95`).

## Running

```bash
ruby solution.rb
```

## Testing

```bash
rspec spec/
```
