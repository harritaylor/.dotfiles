;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Harri Taylor"
      mode-line-default-help-echo nil
      show-help-function nil)

;;; Frames/Windows
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(setq doom-font (font-spec :family "Go Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
;; (setq doom-theme 'doom-one)
(use-package! circadian
  :init
  :config
  (setq calendar-latitude 51.4827)
  (setq calendar-longitude -3.1820)
  (setq circadian-themes '((:sunrise . doom-one-light)
                           (:sunset . doom-gruvbox))))
(add-hook 'circadian-after-load-theme-hook
          #'(solaire-global-mode +1))

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Projects/org/"
    org-archive-location (concat org-directory "archive/%s::")
    org-ellipsis " ▼ "
    org-bullets-bullet-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷"))

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type nil)

(use-package! smooth-scrolling
  :init
  (smooth-scrolling-mode 1))

(add-to-list 'default-frame-alist '(left . x-display-pixel-width/2))
(add-to-list 'default-frame-alist '(top . x-display-pixel-height/2))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 155))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . f))

(setq evil-split-window-below t
      evil-vsplit-window-right t)


(setq dired-use-ls-dired nil)


;; Python
(when (executable-find "ipython")
  (setq python-shell-interpreter "ipython"))
(setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
(setq +python-jupyter-repl-args '("--simple-prompt"))
(setq conda-anaconda-home "~/.conda")

;; latex
(setq +latex-viewers '(skim))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
