;;; aoc-ruby.el --- Emacs support for Advent of Code Ruby development -*- lexical-binding: t -*-

;; Author: Jason Walsh
;; Version: 1.0
;; Package-Requires: ((emacs "29.1") (inf-ruby "2.5.0") (rspec-mode "1.11"))
;; Keywords: languages, ruby, advent-of-code

;;; Commentary:
;;
;; This package provides Emacs support for developing Advent of Code
;; solutions in Ruby.  It includes:
;;
;; - Interactive console with utilities preloaded
;; - Quick navigation between days/years
;; - Test running integration
;; - Input fetching (requires session cookie)
;;
;; Usage:
;;   Load this file in your Emacs config:
;;   (load-file "/path/to/aoc-rb/emacs/aoc-ruby.el")
;;
;;   Or add to load-path and require:
;;   (add-to-list 'load-path "/path/to/aoc-rb/emacs")
;;   (require 'aoc-ruby)

;;; Code:

(require 'inf-ruby nil t)
(require 'compile)

(defgroup aoc-ruby nil
  "Advent of Code Ruby development support."
  :group 'ruby
  :prefix "aoc-ruby-")

(defcustom aoc-ruby-project-root nil
  "Root directory of the AoC Ruby project.
If nil, will be detected automatically."
  :type '(choice (const nil) directory)
  :group 'aoc-ruby)

(defcustom aoc-ruby-years '(2015 2016 2017 2018 2019 2020 2021 2022 2023 2024)
  "Available Advent of Code years."
  :type '(repeat integer)
  :group 'aoc-ruby)

(defvar aoc-ruby-current-year nil
  "Currently selected year.")

(defvar aoc-ruby-current-day nil
  "Currently selected day.")

;;; Utility Functions

(defun aoc-ruby--project-root ()
  "Get the AoC Ruby project root."
  (or aoc-ruby-project-root
      (locate-dominating-file default-directory "setup.org")
      (locate-dominating-file default-directory "Gemfile")))

(defun aoc-ruby--day-dir (year day)
  "Get directory for YEAR and DAY."
  (let ((root (aoc-ruby--project-root)))
    (when root
      (expand-file-name (format "%d/day%02d" year day) root))))

(defun aoc-ruby--solution-file (year day)
  "Get solution file path for YEAR and DAY."
  (let ((dir (aoc-ruby--day-dir year day)))
    (when dir
      (expand-file-name "solution.rb" dir))))

(defun aoc-ruby--spec-file (year day)
  "Get spec file path for YEAR and DAY."
  (let ((dir (aoc-ruby--day-dir year day)))
    (when dir
      (expand-file-name "spec/solution_spec.rb" dir))))

(defun aoc-ruby--input-file (year day)
  "Get input file path for YEAR and DAY."
  (let ((dir (aoc-ruby--day-dir year day)))
    (when dir
      (expand-file-name "input.txt" dir))))

;;; Interactive Commands

;;;###autoload
(defun aoc-ruby-console ()
  "Start the AoC Ruby interactive console."
  (interactive)
  (let ((default-directory (aoc-ruby--project-root)))
    (if (fboundp 'inf-ruby)
        (inf-ruby-console-run "ruby bin/console" "aoc-console")
      (compile "ruby bin/console"))))

;;;###autoload
(defun aoc-ruby-open-day (year day)
  "Open solution for YEAR and DAY."
  (interactive
   (list (read-number "Year: " (or aoc-ruby-current-year 2024))
         (read-number "Day: " (or aoc-ruby-current-day 1))))
  (setq aoc-ruby-current-year year
        aoc-ruby-current-day day)
  (let ((solution (aoc-ruby--solution-file year day)))
    (if (and solution (file-exists-p solution))
        (find-file solution)
      (message "Solution not found: %s" solution))))

;;;###autoload
(defun aoc-ruby-open-spec ()
  "Open spec file for current day."
  (interactive)
  (when (and aoc-ruby-current-year aoc-ruby-current-day)
    (let ((spec (aoc-ruby--spec-file aoc-ruby-current-year aoc-ruby-current-day)))
      (if (and spec (file-exists-p spec))
          (find-file spec)
        (message "Spec not found: %s" spec)))))

;;;###autoload
(defun aoc-ruby-open-input ()
  "Open input file for current day."
  (interactive)
  (when (and aoc-ruby-current-year aoc-ruby-current-day)
    (let ((input (aoc-ruby--input-file aoc-ruby-current-year aoc-ruby-current-day)))
      (if input
          (find-file input)
        (message "Input file not found")))))

;;;###autoload
(defun aoc-ruby-run-solution ()
  "Run the current day's solution."
  (interactive)
  (when (and aoc-ruby-current-year aoc-ruby-current-day)
    (let ((default-directory (aoc-ruby--project-root))
          (solution (aoc-ruby--solution-file aoc-ruby-current-year aoc-ruby-current-day)))
      (compile (format "ruby %s" solution)))))

;;;###autoload
(defun aoc-ruby-run-tests ()
  "Run tests for current day."
  (interactive)
  (when (and aoc-ruby-current-year aoc-ruby-current-day)
    (let ((default-directory (aoc-ruby--project-root)))
      (compile (format "bundle exec rspec %d/day%02d/spec/"
                       aoc-ruby-current-year aoc-ruby-current-day)))))

;;;###autoload
(defun aoc-ruby-fetch-input ()
  "Fetch input for current day."
  (interactive)
  (when (and aoc-ruby-current-year aoc-ruby-current-day)
    (let ((default-directory (aoc-ruby--project-root)))
      (compile (format "ruby bin/fetch_input.rb %d %d"
                       aoc-ruby-current-year aoc-ruby-current-day)))))

;;;###autoload
(defun aoc-ruby-setup-year (year)
  "Generate directory structure for YEAR."
  (interactive "nYear: ")
  (let ((default-directory (aoc-ruby--project-root)))
    (compile (format "ruby bin/setup_year.rb %d" year))))

;;;###autoload
(defun aoc-ruby-next-day ()
  "Go to next day."
  (interactive)
  (when aoc-ruby-current-day
    (let ((next-day (1+ aoc-ruby-current-day)))
      (if (<= next-day 25)
          (aoc-ruby-open-day aoc-ruby-current-year next-day)
        (message "Already at day 25")))))

;;;###autoload
(defun aoc-ruby-prev-day ()
  "Go to previous day."
  (interactive)
  (when aoc-ruby-current-day
    (let ((prev-day (1- aoc-ruby-current-day)))
      (if (>= prev-day 1)
          (aoc-ruby-open-day aoc-ruby-current-year prev-day)
        (message "Already at day 1")))))

;;; Keymap

(defvar aoc-ruby-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c a c") #'aoc-ruby-console)
    (define-key map (kbd "C-c a o") #'aoc-ruby-open-day)
    (define-key map (kbd "C-c a s") #'aoc-ruby-open-spec)
    (define-key map (kbd "C-c a i") #'aoc-ruby-open-input)
    (define-key map (kbd "C-c a r") #'aoc-ruby-run-solution)
    (define-key map (kbd "C-c a t") #'aoc-ruby-run-tests)
    (define-key map (kbd "C-c a f") #'aoc-ruby-fetch-input)
    (define-key map (kbd "C-c a n") #'aoc-ruby-next-day)
    (define-key map (kbd "C-c a p") #'aoc-ruby-prev-day)
    map)
  "Keymap for AoC Ruby commands.")

;;;###autoload
(define-minor-mode aoc-ruby-mode
  "Minor mode for Advent of Code Ruby development.

\\{aoc-ruby-mode-map}"
  :lighter " AoC"
  :keymap aoc-ruby-mode-map
  :group 'aoc-ruby)

;;;###autoload
(defun aoc-ruby-mode-maybe ()
  "Enable `aoc-ruby-mode' if in an AoC Ruby project."
  (when (aoc-ruby--project-root)
    (aoc-ruby-mode 1)
    ;; Try to detect current year/day from file path
    (when buffer-file-name
      (let ((path (file-name-directory buffer-file-name)))
        (when (string-match "/\\([0-9]\\{4\\}\\)/day\\([0-9]\\{2\\}\\)/" path)
          (setq aoc-ruby-current-year (string-to-number (match-string 1 path))
                aoc-ruby-current-day (string-to-number (match-string 2 path))))))))

;; Hook into ruby-mode
(add-hook 'ruby-mode-hook #'aoc-ruby-mode-maybe)
(add-hook 'ruby-ts-mode-hook #'aoc-ruby-mode-maybe)

(provide 'aoc-ruby)

;;; aoc-ruby.el ends here
