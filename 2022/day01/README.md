# Day 1: Calorie Counting

[Advent of Code 2022 - Day 1](https://adventofcode.com/2022/day/1)

## Problem

The Elves are taking inventory of their food supplies. Each Elf carries food items with various calorie counts. The inventory is formatted as:
- One calorie value per line
- Blank lines separate each Elf's inventory

## Example Input

```
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
```

This represents 5 Elves:
1. Elf 1: 1000 + 2000 + 3000 = **6,000** Calories
2. Elf 2: 4000 = **4,000** Calories
3. Elf 3: 5000 + 6000 = **11,000** Calories
4. Elf 4: 7000 + 8000 + 9000 = **24,000** Calories
5. Elf 5: 10000 = **10,000** Calories

## Part 1

**Task:** Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

**Example Answer:** 24,000 (carried by Elf 4)

## Part 2

**Task:** Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?

**Example Answer:** 24,000 + 11,000 + 10,000 = **45,000**

## Solution Approach

### Parsing
1. Split input by double newlines to get each Elf's section
2. Parse each section as a list of integers

### Part 1
Sum each Elf's calories, find the maximum.

### Part 2
Sum each Elf's calories, sort descending, take top 3, sum again.

## Running

```bash
ruby solution.rb
```

## Testing

```bash
rspec spec/
```
