;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(require 'use-package)

(cua-mode 1)

(set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
(set-frame-font "DejaVu Sans Mono-12" nil t)
(set-default-font "DejaVu Sans Mono-12")
(require 'nix-mode)

; Haskell with Dante
(use-package haskell-mode
    :ensure t
    :defer t
    :init
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
    (add-hook 'haskell-mode-hook 'company-mode)
    (add-hook 'haskell-mode-hook 'flycheck-mode)
    (require 'flycheck-color-mode-line)
    (use-package flycheck-pos-tip
      :ensure t
      :init
;      (with-eval-after-load 'flycheck
;        (flycheck-pos-tip-mode))
    )
)

(autoload 'haskell-tab-indent-mode "haskell-tab-indent.el")

(use-package dante
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (global-eldoc-mode -1)
  (add-hook 'haskell-mode-hook 'dante-mode)
  (add-hook 'haskell-mode-hook 'haskell-tab-indent-mode)
  (add-hook 'dante-mode-hook 'company-mode)
  ; hlint with Dante checker
  (add-hook 'dante-mode-hook
      '(lambda ()
           (flycheck-add-next-checker 'haskell-dante '(warning . haskell-hlint)))
  )
)
(with-eval-after-load 'company
    (add-to-list (make-local-variable 'company-backends) 'company-dabbrev-code)
    (add-to-list (make-local-variable 'company-backends) 'company-capf)
    (add-to-list (make-local-variable 'company-backends) 'company-dict)
    (add-to-list (make-local-variable 'company-backends) 'company-cabal)
)

(add-hook 'dante-mode-hook
   '(lambda () (flycheck-add-next-checker 'haskell-dante
                '(warning . haskell-hlint))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-pos-tip use-package nix-mode magit flycheck-color-mode-line dante))))

(eval-after-load 'company '(progn
  (define-key haskell-mode-map (kbd "C-x TAB") 'company-complete)))

(setq haskell-stylish-on-save t)
