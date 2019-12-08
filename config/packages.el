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
  '(general smartparens)
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
     "M-#" 'spacemacs/alternate-buffer
     "M-y" 'helm-show-kill-ring
     "C-c f" 'helm-recentf
     :states 'normal
     "q" (lambda () 
           (message "Sorry dawg, Vim macros are off for my own sanity :^\)"))))

(defun config/init-smartparens ()
  (general-define-key
   "C-)" 'sp-forward-slurp-sexp
   "C-(" 'sp-backward-slurp-sexp
   "C-}" 'sp-forward-barf-sexp
   "C-{" 'sp-backward-barf-sexp
   "M-s" 'sp-splice-sexp
   "M-(" 'sp-wrap-round
   "M-{" 'sp-wrap-curly
   "M-[" 'sp-wrap-square
   ))

;;; packages.el ends here
