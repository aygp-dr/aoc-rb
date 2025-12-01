;;; Directory Local Variables for Advent of Code Ruby
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((fill-column . 80)
         (indent-tabs-mode . nil)
         (require-final-newline . t)))

 (ruby-mode . ((ruby-indent-level . 2)
               (ruby-insert-encoding-magic-comment . nil)
               (eval . (when (fboundp 'rspec-mode) (rspec-mode 1)))
               (eval . (when (fboundp 'rubocop-mode) (rubocop-mode 1)))))

 (ruby-ts-mode . ((ruby-indent-level . 2)
                  (ruby-insert-encoding-magic-comment . nil)
                  (eval . (when (fboundp 'rspec-mode) (rspec-mode 1)))
                  (eval . (when (fboundp 'rubocop-mode) (rubocop-mode 1)))))

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
