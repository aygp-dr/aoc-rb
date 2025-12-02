# Advent of Code 2025 - Day 01: Secret Entrance
# Pure Makefile Solution
#
# Usage:
#   make solve INPUT=input.txt
#   make solve-sample
#   make step-by-step INPUT=input.txt
#
# This demonstrates using Make's shell function and recursive variables
# to process the dial rotations.

SHELL := /bin/sh
INPUT ?= input.txt

# Default target
.PHONY: all
all: solve

# -----------------------------------------------------------------------------
# Solution using awk (most portable)
# -----------------------------------------------------------------------------
.PHONY: solve
solve:
	@awk 'BEGIN { v = 50; count = 0 } \
	{ \
		dir = substr($$0, 1, 1); \
		num = substr($$0, 2) + 0; \
		if (dir == "L") v -= num; \
		else v += num; \
		v = ((v % 100) + 100) % 100; \
		if (v == 0) count++; \
	} \
	END { print "Part 1:", count }' $(INPUT)

# -----------------------------------------------------------------------------
# Solution using pure shell
# -----------------------------------------------------------------------------
.PHONY: solve-sh
solve-sh:
	@V=50; COUNT=0; \
	while read -r LINE; do \
		DIR=$$(echo "$$LINE" | cut -c1); \
		NUM=$$(echo "$$LINE" | cut -c2-); \
		if [ "$$DIR" = "L" ]; then \
			V=$$((V - NUM)); \
		else \
			V=$$((V + NUM)); \
		fi; \
		V=$$(( ((V % 100) + 100) % 100 )); \
		[ "$$V" -eq 0 ] && COUNT=$$((COUNT + 1)); \
	done < $(INPUT); \
	echo "Part 1: $$COUNT"

# -----------------------------------------------------------------------------
# Sample input for testing
# -----------------------------------------------------------------------------
SAMPLE := R29\nR6\nL43\nL6\nR28\nL42\nL34\nL32\nL13\nL15

.PHONY: solve-sample
solve-sample:
	@printf '$(SAMPLE)' | awk 'BEGIN { v = 50; count = 0 } \
	{ \
		dir = substr($$0, 1, 1); \
		num = substr($$0, 2) + 0; \
		if (dir == "L") v -= num; \
		else v += num; \
		v = ((v % 100) + 100) % 100; \
		if (v == 0) count++; \
	} \
	END { print "Part 1:", count, "(sample)" }'

# -----------------------------------------------------------------------------
# Step-by-step execution with intermediate state
# -----------------------------------------------------------------------------
.PHONY: step-by-step
step-by-step:
	@echo "Step-by-step execution:"
	@echo "========================"
	@awk 'BEGIN { v = 50; step = 0 } \
	{ \
		step++; \
		dir = substr($$0, 1, 1); \
		num = substr($$0, 2) + 0; \
		old_v = v; \
		if (dir == "L") v -= num; \
		else v += num; \
		v = ((v % 100) + 100) % 100; \
		zero = (v == 0) ? " ← ZERO!" : ""; \
		printf "Step %2d: %s  %2d → %2d%s\n", step, $$0, old_v, v, zero; \
	} \
	END { print "========================"; print "Final position:", v }' $(INPUT)

# -----------------------------------------------------------------------------
# Generate trace file (for piping to other tools)
# -----------------------------------------------------------------------------
.PHONY: trace
trace:
	@awk 'BEGIN { v = 50 } \
	{ \
		dir = substr($$0, 1, 1); \
		num = substr($$0, 2) + 0; \
		if (dir == "L") v -= num; \
		else v += num; \
		v = ((v % 100) + 100) % 100; \
		print v; \
	}' $(INPUT)

# Count zeros from trace
.PHONY: count-zeros
count-zeros:
	@$(MAKE) -s trace INPUT=$(INPUT) | grep -c '^0$$' || echo 0

# -----------------------------------------------------------------------------
# Using Make's recursive expansion for state (advanced)
# This is more of a demonstration than practical
# -----------------------------------------------------------------------------

# Define initial state
STATE_V := 50
STATE_COUNT := 0

# Process a single rotation (called recursively)
define process_rotation
$(eval OLD_V := $(STATE_V))
$(eval DIR := $(shell echo "$(1)" | cut -c1))
$(eval NUM := $(shell echo "$(1)" | cut -c2-))
$(if $(filter L,$(DIR)),\
  $(eval STATE_V := $(shell echo "$$(( (($(STATE_V) - $(NUM)) % 100 + 100) % 100 ))")),\
  $(eval STATE_V := $(shell echo "$$(( (($(STATE_V) + $(NUM)) % 100 + 100) % 100 ))")))
$(if $(filter 0,$(STATE_V)),$(eval STATE_COUNT := $(shell echo "$$(($(STATE_COUNT) + 1))")))
$(info Step: $(1)  $(OLD_V) → $(STATE_V)$(if $(filter 0,$(STATE_V)), ← ZERO!))
endef

# Process all rotations from a variable
.PHONY: solve-make-native
solve-make-native:
	@echo "Using Make's native evaluation (slow but pure Make):"
	$(foreach rot,R29 R6 L43 L6 R28,$(call process_rotation,$(rot)))
	@echo "Final: position=$(STATE_V) zeros=$(STATE_COUNT)"

# -----------------------------------------------------------------------------
# Benchmark different approaches
# -----------------------------------------------------------------------------
.PHONY: benchmark
benchmark:
	@echo "Benchmarking different approaches on $(INPUT):"
	@echo
	@echo "awk:"
	@time -p $(MAKE) -s solve INPUT=$(INPUT) 2>&1
	@echo
	@echo "pure shell:"
	@time -p $(MAKE) -s solve-sh INPUT=$(INPUT) 2>&1

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
.PHONY: help
help:
	@echo "Advent of Code 2025 - Day 01 Makefile"
	@echo
	@echo "Targets:"
	@echo "  solve          - Solve using awk (default)"
	@echo "  solve-sh       - Solve using pure shell"
	@echo "  solve-sample   - Solve with built-in sample input"
	@echo "  step-by-step   - Show each step with state"
	@echo "  trace          - Output position after each step"
	@echo "  count-zeros    - Count zeros from trace"
	@echo "  benchmark      - Compare approaches"
	@echo "  help           - Show this help"
	@echo
	@echo "Variables:"
	@echo "  INPUT=file     - Input file (default: input.txt)"
