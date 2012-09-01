;; turn on font-lock mode
(global-font-lock-mode t)

(show-paren-mode 1)
(line-number-mode 1)

;disable backup
(setq backup-inhibited t)

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

; set default :results to output
(setq org-babel-default-header-args
      (cons '(:results . "output")
	    (assq-delete-all :results org-babel-default-header-args)))

; you can further customize by creating a new lisp file and
;uncommenting this line
; (load-file "yourcustom.el")
