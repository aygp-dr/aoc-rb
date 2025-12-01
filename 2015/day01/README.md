# Day 1: Not Quite Lisp

[Advent of Code 2015 - Day 1](https://adventofcode.com/2015/day/1)

## Problem

Santa is trying to deliver presents in a large apartment building, but he can't find the right floor. The instructions he has are a sequence of parentheses:

- `(` means go **up** one floor
- `)` means go **down** one floor

Santa starts on the ground floor (floor 0).

## Part 1

**Task:** What floor do the instructions take Santa?

### Examples

| Input | Result |
|-------|--------|
| `(())` | 0 |
| `()()` | 0 |
| `(((` | 3 |
| `(()(()(` | 3 |
| `))(((((` | 3 |
| `())` | -1 |
| `))(` | -1 |
| `)))` | -3 |
| `)())())` | -3 |

## Part 2

**Task:** Find the position of the character that causes Santa to first enter the basement (floor -1). Positions are 1-indexed.

### Examples

| Input | Result |
|-------|--------|
| `)` | 1 |
| `()())` | 5 |

## Solution Approach

### Part 1
Simple character counting: count `(` as +1 and `)` as -1, sum all values.

### Part 2
Iterate through characters tracking floor level. Return the 1-indexed position when floor first becomes -1.

## Running

```bash
ruby solution.rb
```

## Testing

```bash
rspec spec/
```
