;;; packages.el --- config layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Will <will@zaibatsu>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `config-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `config/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `config/pre-init-PACKAGE' and/or
;;   `config/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst config-packages
  '(general smartparens battle-haxe writeroom-mode haskell-mode)
  "The list of Lisp packages required by the config layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun config/pre-init-general ()
  (use-package general))

(defun config/init-general ()
  (general-define-key
   :states '(normal insert emacs)
   "M-#" 'spacemacs/alternate-buffer
   "M-y" 'helm-show-kill-ring
   "C-c f" 'helm-recentf
   "C-a" 'beginning-line-or-indentation
   ;; "C-a" 'back-to-indentation
   "C-e" 'move-end-of-line
   "C-y" 'yank
   "C-x C-b" 'helm-buffers-list
   "S-<left>" 'evil-window-left
   "S-<right>" 'evil-window-right
   "S-<up>" 'evil-window-up
   "S-<down>" 'evil-window-down
   )
  (general-define-key
   :states 'visual
   ">" 'djoyner/evil-shift-right-visual
   "<" 'djoyner/evil-shift-left-visual)
  ;; "q" (lambda () 
  ;;       (message "Sorry dawg, Vim macros are off in normal mode for my own sanity :^\)")))

  (general-define-key
   :states '(motion visual)
   "j" 'evil-next-visual-line
   "k" 'evil-previous-visual-line)

  (general-define-key
   :states 'insert
   "RET" 'fancy-newline
   "<backspace>" 'smart-backspace
   ))

(defun config/init-smartparens ()
  (use-package smartparens
    :diminish ""
    :config
    (general-define-key
     "C-)" 'sp-forward-slurp-sexp
     "C-(" 'sp-backward-slurp-sexp
     "C-}" 'sp-forward-barf-sexp
     "C-{" 'sp-backward-barf-sexp
     "M-s" 'sp-splice-sexp
     "M-(" 'sp-wrap-round
     "M-{" 'sp-wrap-curly
     "M-[" 'sp-wrap-square)
    (smartparens-global-mode)
    (sp-with-modes sp-lisp-modes
      ;; disable ', it's the quote character!
      (sp-local-pair "'" nil :actions nil))
    ))

(defun config/init-writeroom-mode ()
  (use-package writeroom-mode
    :config
    (spacemacs/set-leader-keys-for-minor-mode 'writeroom-mode "<" 'writeroom-decrease-width)
    (spacemacs/set-leader-keys-for-minor-mode 'writeroom-mode ">" 'writeroom-increase-width)
    (spacemacs/set-leader-keys-for-minor-mode 'writeroom-mode "=" 'writeroom-adjust-width)
    (spacemacs/set-leader-keys-for-minor-mode 'writeroom-mode "SPC" 'writeroom-toggle-mode-line)

    (spacemacs/set-leader-keys "a w" 'writeroom-mode)))

(defun config/init-battle-haxe ()
  (use-package haxe-mode
    :mode ("\\.hx\\'" . haxe-mode)
    :no-require t
    :init
    (require 'js)
    (define-derived-mode haxe-mode js-mode "Haxe"
      "Haxe syntax highlighting mode. This is simply using js-mode for now."))

  (use-package battle-haxe
    :hook (haxe-mode . battle-haxe-mode)
    :bind (("S-<f4>" . #'pop-global-mark) ;To get back after visiting a definition
           :map battle-haxe-mode-map
           ("<f4>" . #'battle-haxe-goto-definition)
           ("<f12>" . #'battle-haxe-helm-find-references))
    :custom
    (battle-haxe-yasnippet-completion-expansion t "Keep this if you want yasnippet to expand completions when it's available.")
    (battle-haxe-immediate-completion nil "Toggle this if you want to immediately trigger completion when typing '.' and other relevant prefixes.")))

(defun config/init-haskell-mode ()
  (general-define-key
   :keymaps 'haskell-mode-map
   :states 'insert
   "<backspace>" 'delete-backward-char))
;;; packages.el ends here
