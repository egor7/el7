; DIRED
; C-o - открыть в другом окне, не переходя в него
; i - вставить директорию
; C-u k - на так вставленной папке ее обратно скроет
;
;
; NARROW
; C-x n n - оставить только этот регион на экране
; C-x n w - показать все
;
; HIGHLIGHT
; C-x w h - раскрасить REGEXP
; C-x w r - снять раскраску
;
; M-$ - spell

(require 'uniquify)
(require 'dired)
(require 'ls-lisp)
(require 'info)

(fset 'yes-or-no-p 'y-or-n-p)
(set-language-environment 'UTF-8)
(global-set-key [(ctrl z)] 'undo)
(custom-set-variables
 '(global-auto-revert-mode t) ; autoreload files
 '(menu-bar-mode nil)
 '(confirm-kill-emacs (quote yes-or-no-p))
 '(kill-whole-line t)
 '(show-paren-mode t)
 '(truncate-lines t)
 '(uniquify-buffer-name-style 'reverse)
 '(undo-limit 500000)
 '(undo-strong-limit 500000)
 '(undo-outer-limit 50000000)
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'always)
 '(dired-dwim-target t) ; guess target dir
 '(ls-lisp-use-insert-directory-program nil) ; this 3 lines
 '(ls-lisp-dirs-first t) ; makes dirs first
 '(ls-lisp-ignore-case t) ; sort in alf order ignore case
 ;'(auto-save-default nil)
 ;'(auto-save-mode nil)
 '(make-backup-files nil)
)

;; compile .emacs on save
(defun autocompile nil
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat default-directory ".emacs")))
      (byte-compile-file (buffer-file-name)))
)
(add-hook 'after-save-hook 'autocompile)

;; match parens
(defun goto-match-paren (arg)
  "Goto matching paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key [(meta $)] 'goto-match-paren)
