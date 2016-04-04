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

; Restrictions

(require 'font-lock)

(global-font-lock-mode nil)
(custom-set-variables
 ;'(global-hi-lock-mode nil)
 '(vc-handled-backends nil)
)

; Goodies

(require 'uniquify)
(require 'dired)
(require 'ls-lisp)

(setenv "EMACS" "true")
(fset 'yes-or-no-p 'y-or-n-p)
(set-language-environment 'UTF-8)
(global-auto-revert-mode t)
(custom-set-variables
 '(uniquify-buffer-name-style 'reverse)
 '(undo-limit 500000)
 '(undo-strong-limit 500000)
 '(undo-outer-limit 50000000)
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'always)
 '(dired-dwim-target t)
 '(dired-listing-switches "-alhp")
 '(ls-lisp-use-insert-directory-program nil)
 '(ls-lisp-dirs-first t)
 '(ls-lisp-ignore-case t)
 '(grep-find-command "find . -type f -name \"X\" -exec grep -nH -e Y {} ;")
 '(auto-save-default nil)
 '(auto-save-mode nil)
 '(backward-delete-char-untabify-method nil)
 '(blink-cursor-mode nil)
 '(c-offsets-alist nil)
 '(c-basic-offset 8)
 '(c-backspace-function 'backward-delete-char)
 '(c-electric-flag nil)
 '(tab-width 8)
 '(indent-tabs-mode nil)
 '(column-number-mode t)
 '(compilation-read-command nil)
 '(compilation-scroll-output t)
 '(confirm-kill-emacs (quote yes-or-no-p))
 '(cursor-in-non-selected-windows t)
 '(delete-selection-mode t)
 '(kill-whole-line t)
 '(inhibit-startup-screen t)
 '(large-file-warning-threshold nil)
 '(make-backup-files nil)
 '(mark-even-if-inactive t)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(require-final-newline nil)
 '(enable-local-variables :all)
 '(same-window-buffer-names (quote ("*shell*" "*mail*" "*inferior-lisp*" "*Buffer List*" "*Async Shell Command*")))
 '(scroll-bar-mode (quote left))
 '(scroll-conservatively 50)
 '(scroll-margin 5)
 '(scroll-preserve-screen-position (quote t))
 '(show-paren-mode t)
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(initial-scratch-message "; M-x lisp-interaction-mode\n; C-j to evaluate\n\n")
 '(require-final-newline nil)
 '(mode-require-final-newline nil)
 '(cursor-type 'bar)
)
(global-set-key (kbd "DEL") 'backward-delete-char)
(global-set-key (kbd "TAB") 'self-insert-command)
(global-set-key [(ctrl z)] 'undo)
(global-set-key "\M-n" '(lambda () (interactive) (scroll-up 1)))
(global-set-key "\M-p" '(lambda () (interactive) (scroll-down 1)))
(global-set-key [(control tab)] 'other-window)
(global-set-key [(control down)] '(lambda () (interactive) (scroll-up 1)))
(global-set-key [(control up)] '(lambda () (interactive) (scroll-down 1)))
(global-set-key [(meta down)] '(lambda () (interactive) (scroll-up 1)))
(global-set-key [(meta up)] '(lambda () (interactive) (scroll-down 1)))

;;(defvar just-tab-keymap (make-sparse-keymap) "Keymap for just-tab-mode")
;;(define-minor-mode just-tab-mode
;;   "Just want the TAB key to be a TAB"
;;   :global t :lighter " TAB" :init-value 0 :keymap just-tab-keymap
;;   (define-key just-tab-keymap (kbd "TAB") 'indent-for-tab-command))
;;(eval-after-load "cc-mode"  '(define-key c-mode-map (kbd "TAB") 'self-insert-command))
;;(eval-after-load "c++-mode" '(define-key c++-mode-map (kbd "TAB") 'self-insert-command))


; Fat

(require 'time-stamp)
(setq time-stamp-format "%:y.%02m.%02d")
(defun insert-date ()
  (interactive)
  (insert (time-stamp-string)))
(global-set-key "\M-D" 'insert-date )

(defun build ()
  (interactive)
  (save-buffer)
  (if (boundp 'my-compile-command)
      (progn (compile my-compile-command))
      (progn (compile "./build.sh")))
)
(global-set-key [f8] 'build)

(defun test ()
  (interactive)
  (save-buffer)
  (if (boundp 'my-test-command)
      (progn (compile my-test-command))
      (progn (cd "./test")(compile "./test.sh")(cd "./..")))
)
(global-set-key [f9] 'test)

; alias c='eval cd `cat ~/cwd`'
(defun dired-export-cwd ()
  (interactive)
  (with-temp-file "~/cwd"
    (insert default-directory))
)
(define-key dired-mode-map "c" 'dired-export-cwd)

(defun pt-pbpaste ()
  "Paste data from pasteboard."
  (interactive)
  (shell-command-on-region
   (point)
   (if mark-active (mark) (point))
   "pbpaste" nil t)
)
(defun pt-pbcopy ()
  "Copy region to pasteboard."
  (interactive)
  (print (mark))
  (when mark-active
    (shell-command-on-region
     (point) (mark) "pbcopy")
    (kill-buffer "*Shell Command Output*"))
)
(global-set-key [?\C-x ?\C-y] 'pt-pbpaste)
(global-set-key [?\C-x ?\M-w] 'pt-pbcopy)

(defun autocompile nil
  (interactive)
  (require 'bytecomp)
  (if (string= (buffer-file-name) (expand-file-name (concat default-directory ".emacs")))
      (byte-compile-file (buffer-file-name)))
)
(add-hook 'after-save-hook 'autocompile)

(defun newframe ()
  (interactive)
  (make-frame)
  (other-frame 1)
)
(add-hook 'ediff-before-setup-hook 'newframe)
(add-hook 'ediff-quit-hook 'delete-frame)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(defun my-diff (switch)
      (let ((file1 (pop command-line-args-left))
            (file2 (pop command-line-args-left)))
        (ediff-files file1 file2)))
(add-to-list 'command-switch-alist '("-diff" . my-diff))

(put 'scroll-left 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)


;(require 'pc-select)
;(delete-selection-mode)
(setq x-select-enable-clipboard t)
;; Force cp1251 be the first cyrillic enviroment
(set-language-environment 'UTF-8)
;(set-language-info-alist "Cyrillic-CP1251" `(
;  (charset cyrillic-iso8859-5)
;  (coding-system cp1251)
;  (coding-priority cp1251)
;  (input-method . "cyrillic-jcuken")
;  (features cyril-util)
;  (unibyte-display . cp1251)
;  (sample-text . "Russian")
;  (documentation . "Support for Cyrillic CP1251"))
;    '("Cyrillic"))
;(set-language-environment 'Cyrillic-CP1251)

;; frame size
;(add-to-list 'default-frame-alist '(left . 0))
;(add-to-list 'default-frame-alist '(top . 0))
;(add-to-list 'default-frame-alist '(height . 55))
;(add-to-list 'default-frame-alist '(width . 155)) ;; 1280x1024

;; oracle sql mode
;;
;; code bellow much better ;; (add-hook 'sql-mode-hook 'sql-highlight-oracle-keywords)
(defun highlight-plsql ()
 (when (and (stringp buffer-file-name)
            (string-match "\\.\\(psql\\|sql\\|spc\\|plsql\\)\\'" buffer-file-name))
       (sql-set-product 'oracle)
 ))
(defun highlight-mssql ()
 (when (and (stringp buffer-file-name)
            (string-match "\\.tsql\\'" buffer-file-name))
       (sql-set-product 'ms)
 ))
(add-hook 'find-file-hook 'highlight-plsql)
(add-hook 'find-file-hook 'highlight-mssql)
(setq auto-mode-alist (append '(("\\.\\(psql\\|sql\\|spc\\|plsql\\|tsql\\)\\'" . sql-mode))
  auto-mode-alist))


;; match parens
(defun goto-match-paren (arg)
  "Goto matching paren."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key [(ctrl %)] 'goto-match-paren)

;; sqlplus
(require 'sql)
(defalias 'sql-get-login 'ignore)

;; frame title
(setq frame-title-format
 (list ;; (format "%s %%S: %%j " (system-name))
 '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
