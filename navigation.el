(defun switch-to-last-buffer ()
  "Switch to last open buffer"
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
