# Day 10: Elves Look, Elves Say

[Advent of Code 2015 - Day 10](https://adventofcode.com/2015/day/10)

## Problem

The Elves are playing a game called "look-and-say." The rules are simple:

1. Read the previous sequence aloud
2. The reading becomes the next sequence

For each run of identical digits, output:
- The count of consecutive digits
- Followed by the digit itself

## Examples

| Step | Sequence | Description |
|------|----------|-------------|
| 0 | `1` | Starting value |
| 1 | `11` | "one 1" |
| 2 | `21` | "two 1s" |
| 3 | `1211` | "one 2, one 1" |
| 4 | `111221` | "one 1, one 2, two 1s" |
| 5 | `312211` | "three 1s, two 2s, one 1" |

## Part 1

**Task:** Starting with your puzzle input, apply the look-and-say process 40 times. What is the **length** of the result?

## Part 2

**Task:** Apply the process 50 times. What is the **length** of the result?

## Solution Approach

### Algorithm
1. Iterate through the sequence
2. For each position, count consecutive identical digits
3. Append the count and the digit to the result
4. Repeat for the required number of iterations

### Complexity
- The sequence grows roughly by Conway's constant (~1.303577...) each iteration
- After 40 iterations, expect ~300,000+ characters
- After 50 iterations, expect ~4,000,000+ characters

### Ruby Implementation
Uses simple string iteration with run-length encoding. The `look_and_say` method:
1. Tracks the current digit and its count
2. When the digit changes, appends count + digit to result
3. Returns the new sequence

## Running

```bash
ruby solution.rb
```

## Testing

```bash
rspec spec/
```

## Mathematical Background

This is related to the [Look-and-say sequence](https://en.wikipedia.org/wiki/Look-and-say_sequence), first analyzed by John Conway. The sequence has interesting properties:
- Never contains a digit greater than 3 (for most starting values)
- Growth rate converges to Conway's constant λ ≈ 1.303577
- Related to the "audioactive decay" process in combinatorics
