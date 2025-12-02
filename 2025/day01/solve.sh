#!/bin/sh
# Advent of Code 2025 - Day 01: Secret Entrance
# Usage: ./solve.sh input.txt

INPUT_FILE="${1:-input.txt}"

awk '
BEGIN { v = 50; count = 0 }
{
    dir = substr($0, 1, 1)
    num = substr($0, 2) + 0
    if (dir == "L") v -= num
    else v += num
    v = ((v % 100) + 100) % 100
    if (v == 0) count++
}
END { print "Part 1:", count }
' "$INPUT_FILE"
