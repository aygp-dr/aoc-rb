# Makefile for Advent of Code Ruby Repository
# Detect shell path for FreeBSD/Linux compatibility
SHELL := $(shell command -v bash 2>/dev/null || echo /bin/sh)

# Tools
EMACS ?= emacs
RUBY ?= ruby
BUNDLE ?= $(RUBY) -S bundle
RSPEC ?= rspec
DIRENV ?= direnv

# Directories
BIN_DIR := bin
LIB_DIR := lib
SPEC_DIR := spec
TEMPLATES_DIR := templates

# Files
ORG_FILES := setup.org

.PHONY: all deps check-deps tangle install test lint clean help repl irb console

all: check-deps tangle install

## Dependency Management

deps: check-deps  ## Check all dependencies

check-deps:  ## Verify all required tools are installed
	@echo "Checking dependencies..."
	@echo ""
	@echo "=== Required Tools ==="
	@command -v $(EMACS) >/dev/null 2>&1 || { echo "❌ emacs not found"; exit 1; }
	@echo "✓ emacs: $$($(EMACS) --version | head -1)"
	@command -v $(RUBY) >/dev/null 2>&1 || { echo "❌ ruby not found"; exit 1; }
	@echo "✓ ruby: $$($(RUBY) --version)"
	@$(RUBY) -e "require 'bundler'" 2>/dev/null || { echo "❌ bundler not found - run: gem install bundler"; exit 1; }
	@echo "✓ bundler: $$($(RUBY) -e "require 'bundler'; puts Bundler::VERSION")"
	@command -v $(DIRENV) >/dev/null 2>&1 || { echo "❌ direnv not found"; exit 1; }
	@echo "✓ direnv: $$($(DIRENV) --version)"
	@command -v git >/dev/null 2>&1 || { echo "❌ git not found"; exit 1; }
	@echo "✓ git: $$(git --version)"
	@command -v gmake >/dev/null 2>&1 || { echo "❌ gmake not found"; exit 1; }
	@echo "✓ gmake: $$(gmake --version | head -1)"
	@echo ""
	@echo "=== Ruby Version Manager ==="
	@command -v rbenv >/dev/null 2>&1 && echo "✓ rbenv: $$(rbenv --version)" || \
		(command -v rvm >/dev/null 2>&1 && echo "✓ rvm: $$(rvm --version | head -1)" || \
		(command -v asdf >/dev/null 2>&1 && echo "✓ asdf: $$(asdf --version)" || \
		echo "⚠ No Ruby version manager detected (rbenv/rvm/asdf)"))
	@echo ""
	@echo "=== Optional Tools ==="
	@command -v jj >/dev/null 2>&1 && echo "✓ jj: $$(jj --version)" || echo "○ jj not found (optional)"
	@command -v gh >/dev/null 2>&1 && echo "✓ gh: $$(gh --version | head -1)" || echo "○ gh not found (optional)"
	@command -v rg >/dev/null 2>&1 && echo "✓ ripgrep: $$(rg --version | head -1)" || echo "○ ripgrep not found (optional)"
	@echo ""
	@echo "All required dependencies satisfied!"

## Org-mode Tangling

tangle: $(ORG_FILES)  ## Tangle all org files to generate source
	@echo "Tangling $(ORG_FILES)..."
	$(EMACS) --batch \
		--eval "(require 'org)" \
		--eval "(setq org-confirm-babel-evaluate nil)" \
		--eval "(dolist (file '(\"setup.org\")) (find-file file) (org-babel-tangle) (kill-buffer))"
	@chmod +x $(BIN_DIR)/*.sh $(BIN_DIR)/*.rb 2>/dev/null || true
	@echo "Tangle complete!"

## Ruby Setup

install: Gemfile  ## Install Ruby dependencies
	$(BUNDLE) config set --local path 'vendor/bundle'
	$(BUNDLE) install

Gemfile: tangle  ## Ensure Gemfile exists from tangle

## Testing

test:  ## Run all tests
	$(BUNDLE) exec $(RSPEC)

test-year:  ## Run tests for a specific year (YEAR=2024)
	$(BUNDLE) exec $(RSPEC) $(YEAR)/

test-day:  ## Run tests for a specific day (YEAR=2024 DAY=01)
	$(BUNDLE) exec $(RSPEC) $(YEAR)/day$(DAY)/spec/

## Linting

lint:  ## Run RuboCop linter
	$(BUNDLE) exec rubocop

lint-fix:  ## Run RuboCop with auto-fix
	$(BUNDLE) exec rubocop -a

## Project Setup

setup-year:  ## Generate directory structure for a year (YEAR=2024)
	$(RUBY) $(BIN_DIR)/setup_year.rb $(YEAR)

fetch-input:  ## Fetch puzzle input (YEAR=2024 DAY=1)
	$(RUBY) $(BIN_DIR)/fetch_input.rb $(YEAR) $(DAY)

## Direnv

direnv-allow:  ## Allow direnv for this directory
	$(DIRENV) allow

## Cleanup

clean:  ## Remove generated files
	rm -rf .bundle vendor
	rm -f Gemfile.lock
	rm -f spec/examples.txt

distclean: clean  ## Remove all generated files including tangled output
	rm -rf $(BIN_DIR) $(LIB_DIR) $(SPEC_DIR) $(TEMPLATES_DIR)
	rm -f .ruby-version Gemfile

## REPL / Console

repl: irb  ## Start Ruby REPL with AoC utilities loaded (alias for irb)

irb:  ## Start IRB with AoC utilities loaded
	@echo "Starting IRB with AoC utilities..."
	@$(RUBY) -I$(LIB_DIR) -r aoc_utils -r aoc_debug -r repl_helpers -r irb -e "IRB.start"

console:  ## Start Pry with AoC utilities (requires pry gem)
	@echo "Starting Pry console with AoC utilities..."
	@$(BUNDLE) exec pry -I$(LIB_DIR) -r aoc_utils -r aoc_debug

## Help

help:  ## Show this help message
	@echo "Advent of Code Ruby - Available targets:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*## .*' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  gmake                    # Check deps, tangle, install"
	@echo "  gmake tangle             # Tangle org files"
	@echo "  gmake test               # Run all tests"
	@echo "  gmake test-year YEAR=2024"
	@echo "  gmake test-day YEAR=2024 DAY=01"
	@echo "  gmake setup-year YEAR=2015"
