(add-hook 'emacs-lisp-mode-hook #'general-lisp-customisations)
(add-hook 'lisp-mode-hook #'general-lisp-customisations)
(add-hook 'scheme-mode-hook #'general-lisp-customisations)

(ido-mode -1)

;; (setq lisp-indent-function 'common-lisp-indent-function)
(put 'if 'lisp-indent-function nil)

(spacemacs/set-leader-keys
  "ee" 'flycheck-buffer)

(setq scheme-program-name "guile")

(add-hook 'lisp-mode-hook #'smart-backspace-mode)
(add-hook 'c-mode-common-hook #'smart-backspace-mode)

