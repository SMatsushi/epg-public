;; for compatibility between Mac and rcmaster
(setq mac t)
(if mac
    (setq homepath "~/work/") ;; for Mac
  (setq homepath "~/"))

(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-@" 'set-mark-command)
(global-set-key "\C-x\C-u" 'undo-only)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-o" 'openline-below)
(global-set-key "\C-x\C-m" 'goto-match-paren)
(global-set-key "\C-c\C-d" 'describe-key)

(setq shell-pushd-regexp "pu")
(setq shell-popd-regexp "po")

;; other commands
; c++ mode : read-only \C-x \C-q 
;; \C-x v v rcs co/ci
;; \C-c \C-c done. 

;; yatex setting
(if mac
    (setq auto-mode-alist (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
  (autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
  (setq tex-command "/Users/satoshi/Library/TeXShop/bin/platex2pdf-euc" dvi2-command "open -a TexShop")
  (add-hook 'yatex-mode-hook
	    '(lambda ()
	       (setq buffer-file-coding-system 'euc-japan-unix))))

;; turn on/off truncate lines
;;====================================
;;; 折り返し表示ON/OFF
;;====================================
(setq truncate-partial-width-windows nil)
(set-default ' truncate-lines t)

(defun toggle-truncate-lines ()
; "折り返し表示をトグル動作します."
  "toggle line truncation."
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))

(global-set-key "\C-c\C-l" 'toggle-truncate-lines)  ; 折り返し表示ON/OFF

;; RAMCloud mode

;; Tell emacs where is your personal elisp lib dir
;; this is the dir you place all your extra packages
(add-to-list 'load-path (concat homepath "lib/emacs/"))
;; load the packaged named xyz.
(load "ramcloud-c-style") ;; best not to include the ending “.el” or “.elc”
(add-hook 'c-mode-common-hook 'ramcloud-set-c-style)
;; (autoload 'c-mode "cc" nil t)

;; change color themes
;; use it with: M-x color-theme

(add-to-list 'load-path (concat homepath "lib/emacs/color-theme"))
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (if window-system 
	 (progn
	   (color-theme-subtle-hacker)
	   (add-to-list
	    'default-frame-alist
	    '(alpha . (95 80))) ;; (alpha . (<active frame> <non active frame>))
	   (setq default-frame-alist
		 (append
		  '((width . 100) (height . 40))
		  default-frame-alist)))
	   (color-theme-hober))))

;;
(defun openline-below ()
  "Open new line below for simular use of vi."
  (interactive)
  (progn
    (next-line)
    (move-beginning-of-line nil)
    (open-line 1)))

;; http://www.emacswiki.org/emacs/ParenthesisMatching
(defun goto-match-paren (arg)
  "Go to the matching  if on (){}[], similar to vi style of % "
  (interactive "p")
  ;; first, check for "outside of bracket" positions expected by forward-sexp, etc.
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ;; now, try to succeed from inside of a bracket
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t nil)))

;; enable IME control
;; C-j の機能を別のキーに割り当て
(global-set-key (kbd "C-m") 'newline-and-indent)
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(global-set-key "\C-j" 'toggle-input-method)

;; (setq default-input-method "MacOSX")
;; (global-set-key (kbd "C-j") toggle-input-method)
;; assign Cmd-+, Cmd--: notworking yet...
(global-set-key "\M-+" 'text-scale-increase)
(global-set-key "\M--" 'text-scale-decrease)

;; assign number mode
(global-set-key "\M-n" 'linum-mode)

;; swap command key and option key
;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))
