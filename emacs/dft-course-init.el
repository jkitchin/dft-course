
;; create an environment variable called DFTCOURSE that points to where the course files are.
(setq dft-course (getenv "DFTCOURSE"))

(global-visual-line-mode 1) ; how long lines are handled
;; turn on font-lock mode
(global-font-lock-mode t)

(show-paren-mode 1)
(line-number-mode 1)

;disable backup
(setq backup-inhibited t)

;; answer with y/n
(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-screen t)

;; Color themes and frame title
(setq frame-title-format "Emacs for dft-course")

(add-to-list 'load-path (concat dft-course "/emacs/color-theme-6.6.0"))
(require 'color-theme)
(load-file (concat dft-course "/emacs/my-color-theme.el"))
(my-color-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
             (concat dft-course "/emacs/python-mode"))

;(setq py-shell-name "C:/Python27/Scripts/ipython.bat")
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default py-indent-offset 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defadvice py-execute-buffer
  (after j/py-execute-buffer (arg))
  "another way to modify execute buffer"
  (progn
    (switch-to-buffer-other-window "*Python*")))

(ad-activate 'py-execute-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
             (concat dft-course "/emacs/org-mode/lisp"))
(add-to-list 'load-path
             (concat dft-course "/emacs/org-mode/contrib/lisp"))
(require 'org-install)
(require 'org-list)
(require 'org-special-blocks)
(require 'org)

(setq org-return-follows-link t)

; do not evaluate code on export
(setq org-export-babel-evaluate nil)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key [f12] 'org-mode)

(global-set-key "\C-e" 'end-of-line); overwrites org-mode \C-e definition

(global-set-key "\C-cL" 'org-insert-link-global)
(global-set-key "\C-co" 'org-open-at-point-global)


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
      (cons '(:results . "replace output")
	    (assq-delete-all :results org-babel-default-header-args)))

(setq org-babel-default-header-args
      (cons '(:exports . "both")
	    (assq-delete-all :exports org-babel-default-header-args)))

(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  )
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

(setq org-export-latex-default-packages-alist
      (quote
       (("AUTO" "inputenc" t)
	("" "fixltx2e" nil)
    ("" "url")
	("" "graphicx" t)
    ("" "minted" t)
    ("" "color" t)
	("" "longtable" nil)
	("" "float" nil)
	("" "wrapfig" nil)
	("" "soul" t)
	("" "textcomp" t)
    ("" "amsmath" t)
	("" "marvosym" t)
	("" "wasysym" t)
	("" "latexsym" t)
	("" "amssymb" t)
	("linktocpage,
  pdfstartview=FitH,
  colorlinks,
  linkcolor=blue,
  anchorcolor=blue,
  citecolor=blue,
  filecolor=blue,
  menucolor=blue,
  urlcolor=blue" "hyperref" t)
	("" "attachfile" t)
	"\\tolerance=1000")))

(setq org-export-latex-listings 'minted)
(setq org-export-latex-minted-options
           '(("frame" "lines")
             ("fontsize" "\\scriptsize")
             ("linenos" "")))
(setq org-latex-to-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "bibtex %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;;; new link formats for org-mode that I wrote


; here is a way to get pydoc in a link: [[pydoc:numpy]]
(setq org-link-abbrev-alist
      '(("pydoc" . "shell:pydoc %s")))

;; these allow me to write mod:numpy or func:numpy.dot to get
;; clickable links to documentation
(org-add-link-type
 "mod"
 (lambda (arg)
   (shell-command (format "pydoc %s" arg) nil))
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (format "\\texttt{%s}" path)))))

(org-add-link-type
 "func"
 (lambda (arg)
   (shell-command (format "pydoc %s" arg) nil))
 (lambda (path desc format)
   (cond
    ((eq format 'latex)
     (format "\\texttt{%s}" path)))))

;;; support for links to microsoft docx,pptx,xlsx files
;;; standard org-mode opens these as zip-files
;;  http://orgmode.org/manual/Adding-hyperlink-types.html
(org-add-link-type "msx" 'org-msx-open)

(defun org-msx-open (path)
       "Visit the msx file on PATH.

uses the dos command:
start  empty title path
"
       (shell-command
	(concat "start \"title\" " (shell-quote-argument path)) t))


(org-add-link-type "ashell" 'org-ashell-open)
(defun org-ashell-open (cmd)
"open an ashell:cmd link
[[ashell:xterm -e \"cd 0; ls && /bin/bash\"]]

I use this to run commands asynchronously in the shell. org-mode runs shell links in a blocking mode, which is annoying when you open an xterm."
(start-process-shell-command "ashell" "*scratch*" cmd))


;; -*- emacs-lisp -*-   [[color:red][in red]]
(org-add-link-type
 "color"
 (lambda (path)
   (message (concat "color "
		    (progn (add-text-properties
			    0 (length path)
			    (list 'face `((t (:foreground ,path))))
			    path) path))))
 (lambda (path desc format)
   (cond
    ((eq format 'html)
     (format "<span style=\"color:%s;\">%s</span>" path desc))
    ((eq format 'latex)
     (format "{\\color{%s}%s}" path desc)))))

;; -*- emacs-lisp -*-   [[incar:keyword]]
; this makes nice links in org-mode to the online documentation and
; renders useful links in output
(org-add-link-type
 "incar"
  (lambda (keyword)
    (shell-command (format "firefox http://cms.mpi.univie.ac.at/wiki/index.php/%s" keyword) nil))
  ; this function is for formatting
  (lambda (keyword link format)
   (cond
    ((eq format 'html)
     (format "<a href=http://cms.mpi.univie.ac.at/wiki/index.php/%s>%s</a>" keyword keyword))
    ((eq format 'latex)
     (format "\\href{http://cms.mpi.univie.ac.at/wiki/index.php/%s}{%s}"  keyword keyword)

))))

(org-add-link-type
 "image"
 (lambda (keyword)
   ()) ; do nothing. maybe figure out how to open a png or pdf
 (lambda (keyword link format)
   (cond
    ((eq format 'latex)
     (format "\\includegraphics{%s.pdf}" keyword)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-duplicate ((t (:foreground "red" :underline t :weight bold))))
 '(org-link ((t (:inherit link :foreground "medium blue" :underline t)))))

; you can further customize by creating a new lisp file and
;uncommenting this line
; (load-file "yourcustom.el")
