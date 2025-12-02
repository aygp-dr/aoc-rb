#!/bin/sh
# Advent of Code 2025 - Day 1: Pure Shell Solutions
#
# Problem: Circular dial (0-99) starts at 50
#          L# = subtract, R# = add, wrap with modulo 100
#          Count how many times we land on 0

INPUT_FILE="${1:-input.txt}"

echo "=== Day 01 Shell Solutions ==="
echo "Input: $INPUT_FILE"
echo

# -----------------------------------------------------------------------------
# Solution 1: POSIX sh + bc (most portable)
# -----------------------------------------------------------------------------
echo "--- Solution 1: POSIX sh + bc ---"
solution1() {
    V=50
    COUNT=0
    while read -r LINE; do
        # Extract direction and number
        DIR=$(echo "$LINE" | cut -c1)
        NUM=$(echo "$LINE" | cut -c2-)

        if [ "$DIR" = "L" ]; then
            V=$(echo "($V - $NUM) % 100" | bc)
        else
            V=$(echo "($V + $NUM) % 100" | bc)
        fi

        # bc may return negative, fix it
        if [ "$V" -lt 0 ]; then
            V=$(echo "$V + 100" | bc)
        fi

        if [ "$V" -eq 0 ]; then
            COUNT=$((COUNT + 1))
        fi
    done < "$INPUT_FILE"
    echo "Zero count: $COUNT"
}
solution1
echo

# -----------------------------------------------------------------------------
# Solution 2: Pure sh arithmetic (no bc needed)
# -----------------------------------------------------------------------------
echo "--- Solution 2: Pure sh arithmetic ---"
solution2() {
    V=50
    COUNT=0
    while read -r LINE; do
        DIR=${LINE%${LINE#?}}      # First character
        NUM=${LINE#?}              # Rest of string

        case "$DIR" in
            L) V=$((V - NUM)) ;;
            R) V=$((V + NUM)) ;;
        esac

        # Modulo with wrap for negative
        V=$((V % 100))
        [ "$V" -lt 0 ] && V=$((V + 100))

        [ "$V" -eq 0 ] && COUNT=$((COUNT + 1))
    done < "$INPUT_FILE"
    echo "Zero count: $COUNT"
}
solution2
echo

# -----------------------------------------------------------------------------
# Solution 3: awk one-liner
# -----------------------------------------------------------------------------
echo "--- Solution 3: awk ---"
awk '
BEGIN { v = 50; count = 0 }
{
    dir = substr($0, 1, 1)
    num = substr($0, 2) + 0
    if (dir == "L") v -= num
    else v += num
    v = ((v % 100) + 100) % 100  # Handle negative modulo
    if (v == 0) count++
}
END { print "Zero count:", count }
' "$INPUT_FILE"
echo

# -----------------------------------------------------------------------------
# Solution 4: sed + bc pipeline (transform then calculate)
# -----------------------------------------------------------------------------
echo "--- Solution 4: sed + bc pipeline ---"
# Transform L to - and R to +, then sum
sed 's/^L/-/; s/^R/+/' "$INPUT_FILE" | \
    tr '\n' ' ' | \
    sed 's/^/50 /' | \
    { read expr; echo "($expr) % 100" | bc; }
# Note: This only gives final position, not zero count
echo "(Shows final position only)"
echo

# -----------------------------------------------------------------------------
# Solution 5: Your original approach (fixed)
# -----------------------------------------------------------------------------
echo "--- Solution 5: for loop (bash/zsh) ---"
# The fix: semicolon before 'do' or use newlines
V=50
COUNT=0
for I in $(cat "$INPUT_FILE" | sed 's/^L/-/; s/^R/+/'); do
    V=$((V + I))
    V=$(( ((V % 100) + 100) % 100 ))
    [ "$V" -eq 0 ] && COUNT=$((COUNT + 1))
done
echo "Zero count: $COUNT"
echo

# -----------------------------------------------------------------------------
# Solution 6: Perl one-liner
# -----------------------------------------------------------------------------
echo "--- Solution 6: perl ---"
perl -ne '
    BEGIN { $v = 50; $count = 0 }
    /([LR])(\d+)/;
    $v += ($1 eq "L" ? -$2 : $2);
    $v = (($v % 100) + 100) % 100;
    $count++ if $v == 0;
    END { print "Zero count: $count\n" }
' "$INPUT_FILE"
echo

# -----------------------------------------------------------------------------
# Solution 7: Ruby one-liner (for comparison)
# -----------------------------------------------------------------------------
echo "--- Solution 7: ruby one-liner ---"
ruby -ne '
    BEGIN { $v = 50; $count = 0 }
    dir, num = $_.match(/([LR])(\d+)/).captures
    $v += (dir == "L" ? -num.to_i : num.to_i)
    $v = $v % 100
    $count += 1 if $v == 0
    END { puts "Zero count: #{$count}" }
' "$INPUT_FILE"
