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

(custom-set-variables
 '(inhibit-startup-screen t)
 '(initial-scratch-message "; M-x lisp-interaction-mode\n; C-j to evaluate\n\n")
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
 ;'(indent-tabs-mode nil)
 '(backward-delete-char-untabify-method nil)
 '(x-select-enable-clipboard nil)
 '(compilation-scroll-output t)
 '(scroll-bar-mode (quote right))
 '(scroll-conservatively 50)
 '(scroll-margin 5)
 '(scroll-preserve-screen-position (quote t))
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

;; clipboard
(defun copy-to-x-clipboard ()
  (interactive)

  (if (region-active-p)
          (progn
            (shell-command-on-region (region-beginning) (region-end) "xsel -ib")
            (message "Yanked region to clipboard!")
            (deactivate-mark))
        (message "No region active; can't yank to clipboard!")))

(defun paste-from-x-clipboard()
  (interactive)
   (shell-command "xsel -ob" 1))


;; some keys
(global-set-key (kbd "C-x M-w") 'copy-to-x-clipboard)
(global-set-key (kbd "C-x C-y") 'paste-from-x-clipboard)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key [(ctrl z)] 'undo)
(global-set-key "\M-n" '(lambda () (interactive) (scroll-up 1)))
(global-set-key "\M-p" '(lambda () (interactive) (scroll-down 1)))
