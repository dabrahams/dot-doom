(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((git-commit-major-mode . git-commit-elisp-text-mode)
     (org-re-reveal-root . "revealjs/")
     (eval add-hook 'after-save-hook
           (lambda nil
             (org-export-to-file 'awesomecv "zamboni-vita.tex"))
           :append :local)
     (eval add-hook! after-save :append :local
           (zz/refresh-reveal-prez)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
