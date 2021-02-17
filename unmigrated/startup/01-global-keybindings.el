;; ✔ Initial Migration Complete

;; Undo built-in annoyances

(global-unset-key [f11])
(global-unset-key [f10])

;; Mouse stuff
(define-key me-minor-mode-map [mouse-9] 'mac-mouse-turn-on-fullscreen)
(define-key me-minor-mode-map [drag-mouse-9] 'mac-mouse-turn-on-fullscreen)
(define-key me-minor-mode-map [mouse-11] 'mac-mouse-turn-off-fullscreen)
(define-key me-minor-mode-map [drag-mouse-11] 'mac-mouse-turn-off-fullscreen)


;; Navigation to other windows (panes)
(define-key me-minor-mode-map "\C-x\C-n" 'other-window)  ; Normally bound to set-goal-column

(defun dwa/other-window-backward (&optional n)
  "Select the previous window. Copied from \"Writing Gnu Emacs Extensions\"."
  (interactive "P")
  (other-window (- (or n 1)))
  )

(define-key me-minor-mode-map "\C-x\C-p" 'dwa/other-window-backward) ; Normally bound to mark-page
(define-key me-minor-mode-map [(control shift return)] 'dwa/other-window-backward)


;; Miscellaneous
(define-key me-minor-mode-map "\C-x\C-g" 'goto-line)

(define-key me-minor-mode-map "\C-xg" 'magit-status)


(autoload 'my-wl-check-mail-primary "wl")
(define-key me-minor-mode-map "\C-xM" 'my-wl-check-mail-primary)

;; Org bindings
(eval-when-compile '(require 'gnus-sum))

(defun dwa/org-capture (&optional goto keys)
  (interactive "P")

  ;; Make sure the article buffer is available
  (when (eq major-mode 'gnus-summary-mode)
    (save-window-excursion (gnus-summary-display-article
                            (gnus-summary-article-number))))

  (if (memq major-mode '(gnus-summary-mode gnus-article-mode))
      (with-current-buffer gnus-original-article-buffer
        (nnheader-narrow-to-headers)
        (let ((message-id (message-fetch-field "message-id"))
              (subject (rfc2047-decode-string (message-fetch-field "subject")))
              (from (rfc2047-decode-string (message-fetch-field "from")))
              (date-sent (message-fetch-field "date")))
          (org-capture goto "t")
          (save-excursion
            (insert ?( (replace-regexp-in-string 
                        "\\([^<@]*[^<@ ]\\) *<.*@.*>"
                        "\\1"
                        from) ?) " " 
                    (replace-regexp-in-string
                     "\\[.*? - [A-Za-z]+ #\\([0-9]+\\)\\] (New)"
                     "[[redmine:\\1][#\\1]]"
                     (replace-regexp-in-string "^\\(Re\\|Fwd\\): " ""
                                               subject))))
          (org-set-property "Date" date-sent)
          (org-set-property "Message"
                            (format "[[message://%s][%s]]"
                                    (substring message-id 1 -1)
                                    (subst-char-in-string
                                     ?\[ ?\{ (subst-char-in-string
                                              ?\] ?\} subject))))
          (org-set-property "Submitter" from)))
    (org-capture goto "t")))


;; Unicode
(define-key me-minor-mode-map [(control ?U)] 'xmlunicode-character-shortcut-insert)
(define-key me-minor-mode-map [(control ?\")] 'xmlunicode-smart-double-quote)

(define-key me-minor-mode-map [(meta ?`)] 'other-frame)

;;; Need this to make dired-jump work from `C-x C-j'
(require 'jabber nil t)
(require 'dired-x)

(defun dwa/dired-copy-full-path-as-kill ()
  (interactive) 
  (setq current-prefix-arg '(0))
  (call-interactively 'dired-copy-filename-as-kill))

(add-hook 'dired-load-hook 
          (lambda ()
            (define-key dired-mode-map [?W] 'dwa/dired-copy-full-path-as-kill)))

(define-key ctl-x-map [(control ?z)] 'shell-toggle)

(define-key mode-specific-map [?y ?n] 'yas/new-snippet)
(define-key mode-specific-map [?y tab] 'yas/expand)
(define-key mode-specific-map [?y ?f] 'yas/find-snippets)
(define-key mode-specific-map [?y ?r] 'yas/reload-all)
(define-key mode-specific-map [?y ?v] 'yas/visit-snippet-file)


;===--- indentation folding support -----------------------------------------===;
(defun increase-selective-display(&optional arg)
  (interactive "p")
  (interactive)
  (set-selective-display
   (+ (or selective-display 0) (or arg 1))))

(defun decrease-selective-display(&optional arg)
  (interactive "p")
  (when (and (numberp selective-display) (> selective-display 0))
    (set-selective-display
     (max 0
      (- selective-display (or arg 1))))))

(bind-key "C-M-." 'increase-selective-display)
(bind-key "C-M-," 'decrease-selective-display)

;; Make sure the ellipsis indicating collapsed selective-display shows
;; up in "highlight" face so we can see it
(set-display-table-slot
 standard-display-table 4
 (let ((highlight-dot (make-glyph-code ?. 'highlight)))
   (make-vector 3 highlight-dot))
 )
;===-------------------------------------------------------------------------===;

(bind-key "C-x v e" 'ediff-revision)
;(when (eq system-type 'windows-nt)
;  (add-to-list 'exec-path "C:/msysgit/bin")
;  (add-to-list 'exec-path "C:/msysgit/cmd")

;  (setenv "PATH" (mapconcat (lambda (s) (replace-regexp-in-string "/" "\\\\" s)) exec-path ";")))
