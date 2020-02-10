(require 'cl-lib)

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

(defun fancy-newline ()
  "For use in C-style languages. {|} RET becomes:
  ... {
    |
  }
  with mode-appropriate indent."
  (interactive)
  (if (and (equal (char-before) 123) ; {
           (equal (char-after) 125)) ; }
      (progn (newline-and-indent)
             (split-line)
             (indent-for-tab-command))
    (newline-and-indent)))

(defun line-empty-p ()
  (string-empty-p (s-trim (thing-at-point 'line t))))

;; Note to self: this crashes when called from a SLIME command prompt,
;; as the (current-column) includes the prompt text but (thing-at-point ...)
;; doesn't!
(defun line-so-far ()
  (substring (thing-at-point 'line t) 0 (current-column)))

(defun beginning-of-line-text-p ()
  (string-empty-p (s-trim (line-so-far))))

(defun beginning-line-or-indentation ()
  "If line is empty, move to the beginning of the line. Otherwise, move to the first character of the line"
  (interactive)             ; special form, makes this command callable via M-x or a keybind
  (if (line-empty-p)        ; if line is empty
      (beginning-of-line)   ; jump to beginning
    (back-to-indentation))) ; else, jump to first character

(defun djoyner/evil-shift-left-visual ()
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun djoyner/evil-shift-right-visual ()
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))


(defun haskell-evil-open-above ()
  (interactive)
  (evil-digit-argument-or-evil-beginning-of-line)
  (haskell-indentation-newline-and-indent)
  (evil-previous-line)
  (haskell-indentation-indent-line)
  (evil-append-line nil))

(defun haskell-evil-open-below ()
  (interactive)
  (evil-append-line nil)
  (haskell-indentation-newline-and-indent))


(defun smart-backspace ()
  (interactive)
  (cl-flet ((standard-backspace ()
              (let ((smart-backspace-mode nil))
                (command-execute (or
                                  (key-binding (this-single-command-keys))
                                  'delete-backward-char))))
            (smart-bksp ()
              (join-line)
              (indent-according-to-mode)))

    (if (window-minibuffer-p)
        (standard-backspace)
        (if (beginning-of-line-text-p)
            (smart-bksp)
            (standard-backspace)))))

(defvar smart-backspace-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<backspace>") 'smart-backspace)
    map))

(define-minor-mode smart-backspace-mode
  "Smarten yourself up!"
  :global t)

