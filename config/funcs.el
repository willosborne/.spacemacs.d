(defvar electrify-return-match
  "[\]}\)\"]"
  "If this regex matches text after cursor, do an \"electric\" return.")

(defun electrify-return-if-match (arg)
  "If text after cursor matches `electrify-return-match', then open and indent a new line between cursor and text. 
Move cursor to new line."
  (interactive "P")
  (let ((case-fold-search nil)) ;; case-sensitive match
    (if (looking-at electrify-return-match) ;; if text after point matches regex
        (save-excursion (newline)
                        (indent-according-to-mode))) ;; save point, newline-and-indent, then jump back 
    (newline arg) ;; insert the number of newlines defined by the prefix argument
    (indent-according-to-mode))) ;; then indent as needed (this is to make it more general

(when (configuration-layer/package-usedp 'smartparens)
  (defun general-lisp-customisations ()
    (local-set-key (kbd "RET") 'electrify-return-if-match)
    (show-paren-mode t)
    (prettify-symbols-mode)
    (turn-on-smartparens-strict-mode)))
