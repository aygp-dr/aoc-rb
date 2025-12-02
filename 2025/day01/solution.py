#!/usr/bin/env python3
"""Advent of Code 2025 - Day 01: Secret Entrance"""
import sys

def solve(input_text: str) -> int:
    """Count how many times the dial lands on 0."""
    position = 50
    zero_count = 0

    for line in input_text.strip().split('\n'):
        line = line.strip()
        if not line:
            continue

        direction = line[0]
        amount = int(line[1:])

        if direction == 'L':
            position = (position - amount) % 100
        else:
            position = (position + amount) % 100

        if position == 0:
            zero_count += 1

    return zero_count

if __name__ == '__main__':
    input_file = sys.argv[1] if len(sys.argv) > 1 else 'input.txt'
    with open(input_file) as f:
        result = solve(f.read())
    print(f"Part 1: {result}")
