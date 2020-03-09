(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;; -*- lexical-binding: t -*-
(setq gc-cons-threshold (* 50 1000 1000))

(defun tangle-init ()
  "If the current buffer is 'init.org' the code-blocks are
tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
               (expand-file-name (concat user-emacs-directory "init.org")))
    ;; Avoid running hooks when tangling.
    (let ((prog-mode-hook nil))
      (org-babel-tangle)
      (byte-compile-file (concat user-emacs-directory "init.el")))))

(add-hook 'after-save-hook 'tangle-init)

;; (eval-when-compile
;;   (setq use-package-expand-minimally byte-compile-current-file))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                 (not (gnutls-available-p))))
    (proto (if no-ssl "http" "https")))

    (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
    ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)

    (when (< emacs-major-version 24)
     ;; For important compatibility libraries like cl-lib
      (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; this package is useful for overriding major mode keybindings
(use-package bind-key)

(setq mac-right-command-modifier 'super)
(setq mac-command-modifier 'super)

(setq mac-option-modifier 'meta)
(setq mac-left-option-modifier 'meta)
(setq mac-right-option-modifier 'meta)

(setq mac-right-option-modifier 'nil)

(set-face-attribute 'mode-line nil :background "NavajoWhite")
(set-face-attribute 'mode-line-inactive nil :background "#FAFAFA")

(setq-default line-spacing 0)
(setq initial-frame-alist '((width . 135) (height . 55)))
(tool-bar-mode -1)
(setq-default frame-title-format "%b (%f)")

(setq column-number-mode t) ;; show columns and rows in mode line

(when (member "Go Mono" (font-family-list))
  (set-face-attribute 'default nil :font "Go Mono 14"))
(setq-default line-spacing 1)
(use-package all-the-icons)
;; (use-package gruvbox-theme)
;; (load-theme 'gruvbox-dark-soft)

(global-hl-line-mode 1)

(use-package rich-minority
  :config
  (rich-minority-mode 1)
  (setf rm-blacklist ""))

(set-face-background 'show-paren-match "wheat")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)
(show-paren-mode)

(setq-default indent-tabs-mode nil)
(setq-default c-basic-indent 2)
(setq-default c-basic-offset 2)
(setq-default tab-width 2)
(setq tab-width 2)
(setq js-indent-level 2)
(setq css-indent-offset 2)
(setq c-basic-offset 2)

(global-visual-line-mode t)

(use-package vi-tilde-fringe
  :config
  (global-vi-tilde-fringe-mode 1))

;; (setq scroll-margin 10
;;    scroll-step 1
;;    next-line-add-newlines nil
;;    scroll-conservatively 10000
;;    scroll-preserve-screen-position 1)

;; (setq mouse-wheel-follow-mouse 't)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(setq create-lockfiles nil)  ; stop creating .# files

(setq large-file-warning-threshold 100000000)

(global-auto-revert-mode t)

(setq
 inhibit-startup-message t         ; Don't show the startup message
 inhibit-startup-screen t          ; or screen
 cursor-in-non-selected-windows t  ; Hide the cursor in inactive windows
 echo-keystrokes 0.1               ; Show keystrokes right away, don't show the message in the scratch buffer
 initial-scratch-message nil       ; Empty scratch buffer
 sentence-end-double-space nil     ; Sentences should end in one space, come on!
 ;; confirm-kill-emacs 'y-or-n-p      ; y and n instead of yes and no when quitting
)
(setq-default delete-by-moving-to-trash t)

(fset 'yes-or-no-p 'y-or-n-p)      ; y and n instead of yes and no everywhere else
(scroll-bar-mode -1)
(delete-selection-mode 1)
(global-unset-key (kbd "s-p"))

(use-package simpleclip
  :init
  (simpleclip-mode 1))

(global-set-key (kbd "s-0") (lambda ()
                              (interactive)
                              (if (string= (buffer-name) "*scratch*") (previous-buffer) (switch-to-buffer "*scratch*"))))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(defun iterm-goto-filedir-or-home ()
  "Go to present working dir and focus iterm"
  (interactive)
  (do-applescript
   (concat
    " tell application \"iTerm2\"\n"
    "   tell current window\n"
    "     create tab with profile \"Default\"\n"
    "   end tell\n"
    "   tell the current session of current window\n"
    (format "     write text \"cd %s\" \n"
            ;; string escaping madness for applescript
            (replace-regexp-in-string "\\\\" "\\\\\\\\"
                                      (shell-quote-argument (or default-directory "~"))))
    "   end tell\n"
    " end tell\n"
    " do shell script \"open -a iTerm\"\n"
    ))
  )
(global-set-key (kbd "s-i") 'iterm-goto-filedir-or-home)

(global-set-key (kbd "s-<backspace>") 'kill-whole-line)
(global-set-key (kbd "s-<delete>") 'kill-whole-line)
(global-set-key (kbd "M-S-<backspace>") 'kill-word)
(global-set-key (kbd "M-<delete>") 'kill-word)
(bind-key* "S-<delete>" 'kill-word)

(global-set-key (kbd "s-<right>") 'end-of-visual-line)
(global-set-key (kbd "s-<left>") 'beginning-of-visual-line)

(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)

(global-set-key (kbd "s-a") 'mark-whole-buffer)       ;; select all
(global-set-key (kbd "s-s") 'save-buffer)             ;; save
(global-set-key (kbd "s-S") 'write-file)              ;; save as
(global-set-key (kbd "s-q") 'save-buffers-kill-emacs) ;; quit

;; Thanks to Bozhidar Batsov
;; http://emacsredux.com/blog/2013/]05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.
Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.
If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)
(global-set-key (kbd "s-<left>") 'smarter-move-beginning-of-line)

(use-package undo-fu)
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "s-z")   'undo-fu-only-undo)
(global-set-key (kbd "s-r")   'undo-fu-only-redo)

(global-set-key (kbd "s-[") 'previous-buffer)
(global-set-key (kbd "s-]") 'next-buffer)

(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))

(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))

(global-set-key (kbd "s-w") (kbd "C-x 0")) ;; just like close tab in a web browser
(global-set-key (kbd "s-1") (kbd "C-x 1")) ;; close others with shift

(global-set-key (kbd "s-2") (kbd "C-x 2"))
(global-set-key (kbd "s-3") (kbd "C-x 3"))

(global-set-key (kbd "s-K") 'kill-this-buffer)

;; (global-set-key (kbd "s-T") 'vsplit-last-buffer)
;; (global-set-key (kbd "s-t") 'hsplit-last-buffer)

(eval-after-load "org"
  '(progn (setq org-metaup-hook nil)
   (setq org-metadown-hook nil)))

(use-package move-text
  :config
  (move-text-default-bindings))

(defun smart-open-line ()
  "Insert an empty line after the current line. Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun smart-open-line-above ()
  "Insert an empty line above the current line. Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "s-<return>") 'smart-open-line)
(global-set-key (kbd "s-S-<return>") 'smart-open-line-above)

(defun smart-join-line (beg end)
  "If in a region, join all the lines in it. If not, join the current line with the next line."
  (interactive "r")
  (if mark-active
      (join-region beg end)
      (top-join-line)))

(defun top-join-line ()
  "Join the current line with the next line."
  (interactive)
  (delete-indentation 1))

(defun join-region (beg end)
  "Join all the lines in the region."
  (interactive "r")
  (if mark-active
      (let ((beg (region-beginning))
            (end (copy-marker (region-end))))
        (goto-char beg)
        (while (< (point) end)
          (join-line 1)))))

(global-set-key (kbd "s-j") 'smart-join-line)

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(use-package multiple-cursors
  :config
  (setq mc/always-run-for-all 1)
  (global-set-key (kbd "s-d") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-s-g") 'mc/mark-all-dwim)
  (define-key mc/keymap (kbd "<return>") nil)
  (global-set-key (kbd "s-<mouse-1>") 'mc/add-cursor-on-click))

(global-set-key (kbd "s-/") 'comment-line)

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(setq split-height-threshold 0)
(setq split-width-threshold nil)

(global-set-key (kbd "M-<tab>") (kbd "C-x o"))

(use-package shackle
  :init
  (setq shackle-default-alignment 'below
        shackle-default-size 0.4
        shackle-rules '((help-mode           :align below :select t)
                        (helpful-mode        :align below)
                        (compilation-mode    :select t   :size 0.25)
                        ("*compilation*"     :select nil :size 0.25)
                        ("*ag search*"       :select nil :size 0.25)
                        ("*Flycheck errors*" :select nil :size 0.25)
                        ("*Warnings*"        :select nil :size 0.25)
                        ("*Error*"           :select nil :size 0.25)
                        ("*Org Links*"       :select nil :size 0.1)
                        (magit-status-mode                :align bottom :size 0.5  :inhibit-window-quit t)
                        (magit-log-mode                   :same t                  :inhibit-window-quit t)
                        (magit-commit-mode                :ignore t)
                        (magit-diff-mode     :select nil  :align left   :size 0.5)
                        (git-commit-mode                  :same t)
                        (vc-annotate-mode                 :same t)
                        ))
  :config
  (shackle-mode 1))

(use-package swiper
  :config
  (global-set-key (kbd "s-f") 'swiper-isearch))

(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
      '((swiper . ivy--regex-plus)
        (swiper-isearch . regexp-quote)
        ;; (counsel-git . ivy--regex-plus)
        ;; (counsel-ag . ivy--regex-plus)
        (counsel-rg . ivy--regex-plus)
        (t      . ivy--regex-fuzzy)))   ;; enable fuzzy searching everywhere except for Swiper and ag

  (global-set-key (kbd "s-b") 'ivy-switch-buffer)
  (global-set-key (kbd "M-s-b") 'ivy-resume))


(use-package ivy-rich
  :config
  (ivy-rich-mode 1)
  (setq ivy-rich-path-style 'abbrev))

(use-package counsel
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "s-y") 'counsel-yank-pop)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "s-o") 'counsel-find-file)
  (global-set-key (kbd "M-<space>") 'counsel-rg)
  (global-set-key (kbd "s-p") 'counsel-git))

;; When using git ls (via counsel-git), include unstaged files
(setq counsel-git-cmd "git ls-files -z --full-name --exclude-standard --others --cached --")

(use-package smex) ;; show rexent commands when invoking alt-x
(use-package flx) ;; fuzzy matching

  (use-package magit
    :config
    (global-set-key (kbd "s-g") 'magit-status))
  (use-package magit-todos)

  (use-package hl-todo
    :config
    (setq hl-todo-keyword-faces
        '(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("DEBUG"  . "#A020F0")
          ("GOTCHA" . "#FF4500")
          ("STUB"   . "#1E90FF"))))

(setq magit-repository-directories '(("\~/Projects/" . 4)))

(defun magit-status-with-prefix-arg ()
  "Call `magit-status` with a prefix."
  (interactive)
  (let ((current-prefix-arg '(4)))
    (call-interactively #'magit-status)))

(global-set-key (kbd "s-P") 'magit-status-with-prefix-arg)

(use-package git-gutter
  :config
  (global-git-gutter-mode 't)
  (set-face-background 'git-gutter:modified 'nil) ;; background color
  (set-face-foreground 'git-gutter:added "green4")
  (set-face-foreground 'git-gutter:deleted "red"))

(setq ispell-program-name "aspell")

(use-package flyspell-correct)
(use-package flyspell-correct-popup)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))

;; Spellcheck current word
(define-key flyspell-mode-map (kbd "s-\\") 'flyspell-correct-previous-word-generic) ;; Cmd+\ spellcheck word with popup
(define-key flyspell-mode-map (kbd "C-s-\\") 'ispell-word)                          ;; Ctrl+Cmd+\ spellcheck word using built UI

(use-package powerthesaurus
  :config
  (global-set-key (kbd "s-|") 'powerthesaurus-lookup-word-dwim)
  )

(use-package define-word
  :config
  (global-set-key (kbd "M-\\") 'define-word-at-point))

  (use-package yasnippet
    :config
    (setq yas-snippet-dirs
          '("~/.emacs.d/snippets"))
    (yas-global-mode 1))

  (use-package format-all)

(use-package company
  :config
  (setq company-idle-delay 0.1)
  (setq company-global-modes '(not org-mode))
  (setq company-minimum-prefix-length 1)
  (add-hook 'after-init-hook 'global-company-mode))

  (setq ns-pop-up-frames nil)

(setq org-startup-indented t)
(setq org-catch-invisible-edits 'error)
(setq org-cycle-separator-lines -1)
(setq calendar-week-start-day 1)
(setq org-ellipsis "⤵")
(setq org-support-shift-select t)

(use-package org-download
  :config
  ;; add support to dired
  (add-hook 'dired-mode-hook 'org-download-enable))

(setq org-directory "~/org")
(setq org-agenda-files '("~/org"))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation t)
(setq org-src-fontify-natively t)

(use-package htmlize)

  (with-eval-after-load 'org
    ;; no shift or alt with arrows
    ;; (define-key org-mode-map (kbd "<S-left>") nil)
    ;; (define-key org-mode-map (kbd "<S-right>") nil)
    ;; (define-key org-mode-map (kbd "<M-left>") nil)
    ;; (define-key org-mode-map (kbd "<M-right>") nil)
    ;; ;; no shift-alt with arrows
    ;; (define-key org-mode-map (kbd "<M-S-left>") nil)
    ;; (define-key org-mode-map (kbd "<M-S-right>") nil)

    ;; (define-key org-mode-map (kbd "C-s-<left>") 'org-metaleft)
    ;; (define-key org-mode-map (kbd "C-s-<right>") 'org-metaright))

  ;; (setq org-use-speed-commands t)

  ;; (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-s-<down>") 'org-narrow-to-subtree)
    (define-key org-mode-map (kbd "C-s-<up>") 'widen))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "s-=") 'org-capture)
(global-set-key "\C-ca" 'org-agenda)

(require 'ox-latex)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
(setq org-highlight-latex-and-related '(latex))
(with-eval-after-load 'ox-latex
  (add-to-list
   'org-latex-classes
   '("tufte-book"

     "\\documentclass{tufte-book}
     \\input{/users/rakhim/.emacs.d/latex/tufte.tex}"
     ("\\part{%s}" . "\\part*{%s}")
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

(use-package pandoc-mode)

(add-hook 'markdown-mode-hook 'pandoc-mode)
(add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(global-set-key (kbd "C-x c") (lambda () (interactive) (find-file "~/.emacs.d/init.org")))
