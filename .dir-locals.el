;;; Directory Local Variables for Advent of Code Ruby
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 80)
         (indent-tabs-mode . nil)
         (require-final-newline . t)
         ;; Project root for various tools
         (projectile-project-root . nil)))

 (ruby-mode . ((ruby-indent-level . 2)
               (ruby-insert-encoding-magic-comment . nil)
               (eval . (when (fboundp 'rspec-mode) (rspec-mode 1)))
               (eval . (when (fboundp 'rubocop-mode) (rubocop-mode 1)))
               ;; inf-ruby configuration for REPL
               (eval . (setq-local inf-ruby-default-implementation "pry"))
               (eval . (setq-local inf-ruby-first-prompt-pattern "^\\[AoC\\] [0-9]+> "))
               (eval . (setq-local inf-ruby-prompt-pattern "^\\[AoC\\] [0-9]+[>*] "))))

 (ruby-ts-mode . ((ruby-indent-level . 2)
                  (ruby-insert-encoding-magic-comment . nil)
                  (eval . (when (fboundp 'rspec-mode) (rspec-mode 1)))
                  (eval . (when (fboundp 'rubocop-mode) (rubocop-mode 1)))
                  (eval . (setq-local inf-ruby-default-implementation "pry"))
                  (eval . (setq-local inf-ruby-first-prompt-pattern "^\\[AoC\\] [0-9]+> "))
                  (eval . (setq-local inf-ruby-prompt-pattern "^\\[AoC\\] [0-9]+[>*] "))))

 (org-mode . ((org-confirm-babel-evaluate . nil)
              (org-src-preserve-indentation . t)
              (org-edit-src-content-indentation . 0)
              (eval . (org-babel-do-load-languages
                       'org-babel-load-languages
                       '((ruby . t)
                         (shell . t)
                         (emacs-lisp . t)
                         (mermaid . t))))))

 (makefile-mode . ((indent-tabs-mode . t)))

 (makefile-gmake-mode . ((indent-tabs-mode . t))))
