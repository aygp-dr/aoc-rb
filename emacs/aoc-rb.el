;;; aoc-rb.el --- Complete Emacs setup for AoC Ruby development -*- lexical-binding: t -*-

;; Author: Jason Walsh
;; Version: 2.0
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages, ruby, advent-of-code, org-mode

;;; Commentary:
;;
;; This file provides complete Emacs setup for Advent of Code Ruby development.
;; It handles:
;;   - Org Babel language configuration (Ruby, Shell, Elisp, Python)
;;   - Ruby debugging integration (inf-ruby, debug gem)
;;   - Profiling and benchmarking support
;;   - Navigation between AoC days/years
;;
;; USAGE:
;;   Add to your init.el:
;;     (load-file "/path/to/aoc-rb/emacs/aoc-rb.el")
;;
;;   Or with use-package:
;;     (use-package aoc-rb
;;       :load-path "/path/to/aoc-rb/emacs")
;;
;;   Then run: M-x aoc-rb-setup RET

;;; Code:

(require 'org)
(require 'ob)
(require 'compile)

;;;; ============================================================
;;;; Org Babel Configuration
;;;; ============================================================

(defun aoc-rb-setup-babel ()
  "Configure Org Babel for Ruby, Shell, and Elisp execution.
This fixes the 'No org-babel-execute function for ruby!' error."
  (interactive)

  ;; Load language support
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ruby . t)
     (shell . t)
     (python . t)
     (awk . t)
     (sed . t)
     (calc . t)
     (C . t)))

  ;; Don't ask before executing (for trusted project files)
  (setq org-confirm-babel-evaluate nil)

  ;; Better source block editing
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-preserve-indentation t)
  (setq org-edit-src-content-indentation 0)

  ;; Default header arguments for Ruby
  (setq org-babel-default-header-args:ruby
        '((:results . "output")
          (:exports . "both")
          (:wrap . "example")))

  ;; Default header arguments for shell
  (setq org-babel-default-header-args:sh
        '((:results . "output")
          (:exports . "both")))

  (message "Org Babel configured for Ruby, Shell, Elisp, Python"))

;;;; ============================================================
;;;; Ruby Debugging Support
;;;; ============================================================

(defun aoc-rb-setup-ruby-debug ()
  "Configure Ruby debugging support.
Integrates with the debug gem (Ruby 3.1+)."
  (interactive)

  ;; inf-ruby for REPL
  (when (require 'inf-ruby nil t)
    (setq inf-ruby-default-implementation "ruby")
    (setq inf-ruby-console-environment "development"))

  ;; Compilation mode for Ruby output
  (add-to-list 'compilation-error-regexp-alist-alist
               '(ruby-error
                 "^\\s-*\\(?:from \\)?\\([^:\n]+\\):\\([0-9]+\\):?\\(?:in \\|:in `\\)" 1 2))
  (add-to-list 'compilation-error-regexp-alist 'ruby-error)

  ;; RSpec error patterns
  (add-to-list 'compilation-error-regexp-alist-alist
               '(rspec-error
                 "^\\s-+# \\([^:]+\\):\\([0-9]+\\)" 1 2))
  (add-to-list 'compilation-error-regexp-alist 'rspec-error)

  (message "Ruby debugging support configured"))

(defun aoc-rb-debug-file (file)
  "Run FILE with Ruby debug gem."
  (interactive "fRuby file to debug: ")
  (let ((default-directory (file-name-directory file)))
    (compile (format "ruby -r debug %s" (shell-quote-argument file)))))

(defun aoc-rb-debug-current ()
  "Debug the current Ruby file."
  (interactive)
  (if buffer-file-name
      (aoc-rb-debug-file buffer-file-name)
    (message "Buffer is not visiting a file")))

;;;; ============================================================
;;;; Profiling and Benchmarking
;;;; ============================================================

(defvar aoc-rb-profile-output-buffer "*Ruby Profile*"
  "Buffer name for profiling output.")

(defun aoc-rb-profile-file (file)
  "Profile Ruby FILE using ruby-prof or Benchmark."
  (interactive "fRuby file to profile: ")
  (let ((default-directory (file-name-directory file)))
    (compile
     (format "ruby -r benchmark -e 'puts Benchmark.measure { load \"%s\" }'"
             (shell-quote-argument file)))))

(defun aoc-rb-memory-profile (file)
  "Profile memory usage of Ruby FILE."
  (interactive "fRuby file to profile: ")
  (let ((default-directory (file-name-directory file)))
    (compile
     (format "ruby -r objspace -e '
before = ObjectSpace.count_objects
load \"%s\"
after = ObjectSpace.count_objects
after.each { |k,v| d = v - before[k]; puts \"#{k}: #{d}\" if d != 0 }
'" (shell-quote-argument file)))))

(defun aoc-rb-disasm-file (file)
  "Show YARV bytecode disassembly for Ruby FILE."
  (interactive "fRuby file to disassemble: ")
  (let ((output-buffer (get-buffer-create "*Ruby Disasm*")))
    (with-current-buffer output-buffer
      (erase-buffer)
      (call-process "ruby" nil t nil
                    "-e"
                    (format "puts RubyVM::InstructionSequence.compile_file('%s').disasm"
                            file))
      (goto-char (point-min))
      (special-mode))
    (display-buffer output-buffer)))

(defun aoc-rb-ast-file (file)
  "Show AST for Ruby FILE using Ripper."
  (interactive "fRuby file to parse: ")
  (let ((output-buffer (get-buffer-create "*Ruby AST*")))
    (with-current-buffer output-buffer
      (erase-buffer)
      (call-process "ruby" nil t nil
                    "-r" "ripper"
                    "-r" "pp"
                    "-e"
                    (format "pp Ripper.sexp(File.read('%s'))" file))
      (goto-char (point-min))
      (ruby-mode))
    (display-buffer output-buffer)))

;;;; ============================================================
;;;; AoC Navigation
;;;; ============================================================

(defvar aoc-rb-project-root nil
  "Root directory of the AoC Ruby project.")

(defvar aoc-rb-current-year nil
  "Currently selected AoC year.")

(defvar aoc-rb-current-day nil
  "Currently selected AoC day.")

(defun aoc-rb--project-root ()
  "Find the AoC Ruby project root."
  (or aoc-rb-project-root
      (locate-dominating-file default-directory "setup.org")
      (locate-dominating-file default-directory "Gemfile")))

(defun aoc-rb-open-day (year day)
  "Open solution for YEAR and DAY."
  (interactive
   (list (read-number "Year: " (or aoc-rb-current-year 2024))
         (read-number "Day: " (or aoc-rb-current-day 1))))
  (setq aoc-rb-current-year year
        aoc-rb-current-day day)
  (let* ((root (aoc-rb--project-root))
         (solution (expand-file-name
                    (format "%d/day%02d/solution.rb" year day)
                    root)))
    (if (file-exists-p solution)
        (find-file solution)
      ;; Try .org file
      (let ((org-solution (replace-regexp-in-string "\\.rb$" ".org" solution)))
        (if (file-exists-p org-solution)
            (find-file org-solution)
          (message "No solution found for %d Day %02d" year day))))))

(defun aoc-rb-run-solution ()
  "Run the current day's solution."
  (interactive)
  (let* ((root (aoc-rb--project-root))
         (file (buffer-file-name)))
    (cond
     ((string-suffix-p ".rb" file)
      (compile (format "ruby %s" (shell-quote-argument file))))
     ((string-suffix-p ".org" file)
      (org-babel-execute-buffer))
     (t
      (message "Not a Ruby or Org file")))))

(defun aoc-rb-run-tests ()
  "Run tests for current day."
  (interactive)
  (let ((default-directory (aoc-rb--project-root)))
    (if (and aoc-rb-current-year aoc-rb-current-day)
        (compile (format "bundle exec rspec %d/day%02d/spec/"
                         aoc-rb-current-year aoc-rb-current-day))
      (compile "bundle exec rspec"))))

;;;; ============================================================
;;;; Org Mode Helpers
;;;; ============================================================

(defun aoc-rb-insert-ruby-block ()
  "Insert a Ruby source block."
  (interactive)
  (insert "#+BEGIN_SRC ruby\n\n#+END_SRC")
  (forward-line -1))

(defun aoc-rb-insert-shell-block ()
  "Insert a shell source block."
  (interactive)
  (insert "#+BEGIN_SRC sh\n\n#+END_SRC")
  (forward-line -1))

(defun aoc-rb-tangle-and-run ()
  "Tangle the current Org file and run the Ruby output."
  (interactive)
  (let ((tangled-file (car (org-babel-tangle))))
    (when tangled-file
      (compile (format "ruby %s" (shell-quote-argument tangled-file))))))

;;;; ============================================================
;;;; FreeBSD-Specific Tools
;;;; ============================================================

(defun aoc-rb-dtrace-profile (file)
  "Profile Ruby FILE with DTrace (FreeBSD/macOS)."
  (interactive "fRuby file to profile: ")
  (let ((script "ruby*:::function-entry { @[copyinstr(arg0), copyinstr(arg1)] = count(); }"))
    (compile
     (format "sudo dtrace -n '%s' -c 'ruby %s' 2>/dev/null"
             script (shell-quote-argument file)))))

(defun aoc-rb-ktrace-file (file)
  "Run Ruby FILE under ktrace (FreeBSD)."
  (interactive "fRuby file to trace: ")
  (let ((trace-file (make-temp-file "ktrace")))
    (compile
     (format "ktrace -i -f %s ruby %s && kdump -f %s | head -100"
             trace-file (shell-quote-argument file) trace-file))))

;;;; ============================================================
;;;; Keymap
;;;; ============================================================

(defvar aoc-rb-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Navigation
    (define-key map (kbd "C-c a o") #'aoc-rb-open-day)
    (define-key map (kbd "C-c a r") #'aoc-rb-run-solution)
    (define-key map (kbd "C-c a t") #'aoc-rb-run-tests)
    ;; Debugging
    (define-key map (kbd "C-c a d") #'aoc-rb-debug-current)
    (define-key map (kbd "C-c a p") #'aoc-rb-profile-file)
    (define-key map (kbd "C-c a m") #'aoc-rb-memory-profile)
    ;; Analysis
    (define-key map (kbd "C-c a D") #'aoc-rb-disasm-file)
    (define-key map (kbd "C-c a A") #'aoc-rb-ast-file)
    ;; Org helpers
    (define-key map (kbd "C-c a b r") #'aoc-rb-insert-ruby-block)
    (define-key map (kbd "C-c a b s") #'aoc-rb-insert-shell-block)
    (define-key map (kbd "C-c a T") #'aoc-rb-tangle-and-run)
    map)
  "Keymap for AoC Ruby commands.")

;;;; ============================================================
;;;; Minor Mode
;;;; ============================================================

;;;###autoload
(define-minor-mode aoc-rb-mode
  "Minor mode for Advent of Code Ruby development.

Provides:
- Org Babel execution for Ruby, Shell, Elisp
- Ruby debugging integration
- Profiling and benchmarking tools
- Navigation between AoC days/years

Key bindings:
\\{aoc-rb-mode-map}"
  :lighter " AoC-RB"
  :keymap aoc-rb-mode-map
  :group 'aoc-rb
  ;; Setup when mode is enabled
  (when aoc-rb-mode
    (aoc-rb-setup-babel)
    (aoc-rb-setup-ruby-debug)
    ;; Detect year/day from path
    (when buffer-file-name
      (when (string-match "/\\([0-9]\\{4\\}\\)/day\\([0-9]\\{2\\}\\)/" buffer-file-name)
        (setq aoc-rb-current-year (string-to-number (match-string 1 buffer-file-name))
              aoc-rb-current-day (string-to-number (match-string 2 buffer-file-name)))))))

;;;###autoload
(defun aoc-rb-setup ()
  "Complete setup for AoC Ruby development.
Run this once to configure Emacs for the project."
  (interactive)
  (aoc-rb-setup-babel)
  (aoc-rb-setup-ruby-debug)
  (aoc-rb-mode 1)
  (message "AoC Ruby setup complete! Try C-c C-c on a Ruby block."))

;;;; ============================================================
;;;; Auto-activation
;;;; ============================================================

(defun aoc-rb-mode-maybe ()
  "Enable `aoc-rb-mode' if in an AoC Ruby project."
  (when (aoc-rb--project-root)
    (aoc-rb-mode 1)))

;; Auto-enable in ruby and org modes within project
(add-hook 'ruby-mode-hook #'aoc-rb-mode-maybe)
(add-hook 'ruby-ts-mode-hook #'aoc-rb-mode-maybe)
(add-hook 'org-mode-hook #'aoc-rb-mode-maybe)

(provide 'aoc-rb)

;;; aoc-rb.el ends here
