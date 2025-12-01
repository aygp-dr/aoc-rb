# Day 1: Historian Hysteria

[Advent of Code 2024 - Day 1](https://adventofcode.com/2024/day/1)

## Problem

The Chief Historian is missing! While searching for clues, the Historians have compiled two lists of location IDs, but the lists don't quite match up.

### Input Format
Two columns of numbers separated by whitespace:
```
3   4
4   3
2   5
1   3
3   9
3   3
```

## Part 1: Total Distance

**Task:** Calculate the total distance between the two lists.

**Algorithm:**
1. Sort both lists in ascending order
2. Pair up: smallest with smallest, second-smallest with second-smallest, etc.
3. Calculate absolute difference for each pair
4. Sum all differences

**Example:**
- Sorted left:  `[1, 2, 3, 3, 3, 4]`
- Sorted right: `[3, 3, 3, 4, 5, 9]`
- Distances: `|1-3| + |2-3| + |3-3| + |3-4| + |3-5| + |4-9|`
- = `2 + 1 + 0 + 1 + 2 + 5 = 11`

## Part 2: Similarity Score

**Task:** Calculate a similarity score based on how often each number from the left list appears in the right list.

**Algorithm:**
1. Count frequency of each number in the right list
2. For each number in the left list, multiply it by its count in the right list
3. Sum all products

**Example:**
- Left list: `[3, 4, 2, 1, 3, 3]`
- Right list counts: `{3: 3, 4: 1, 5: 1, 9: 1}`
- Calculations:
  - `3 * 3 = 9` (3 appears 3 times)
  - `4 * 1 = 4` (4 appears 1 time)
  - `2 * 0 = 0` (2 doesn't appear)
  - `1 * 0 = 0` (1 doesn't appear)
  - `3 * 3 = 9`
  - `3 * 3 = 9`
- Total: `9 + 4 + 0 + 0 + 9 + 9 = 31`

## Solution Approach

### Part 1
```ruby
left_sorted.zip(right_sorted).sum { |l, r| (l - r).abs }
```

### Part 2
```ruby
right_counts = @right.tally
@left.sum { |num| num * right_counts.fetch(num, 0) }
```

## Running

```bash
ruby solution.rb
```

## Testing

```bash
rspec spec/
```
