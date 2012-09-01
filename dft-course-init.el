; register python in org-mode
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

; enable prompt-free code running
(setq org-confirm-babel-evaluate nil)

; no extra indentation
(setq org-src-preserve-indentation t)
(setq org-startup-with-inline-images "inlineimages")

; use syntax highlighting in org-file
(setq org-src-fontify-natively t)
