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

(setq resize-mini-windows t) ; grow and shrink as necessary
(setq max-mini-window-height 10) ; grow up to max of 10 lines
(setq minibuffer-scroll-window t)
 ;; line numbers
(global-linum-mode 1)
;; no tabs
(setq c-basic-indent 4)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)

(defun show-notification (notification)
  "Show notification. Use notify-send."
  (start-process "notify-send" nil "notify-send" "-i" "/usr/local/share/emacs/24.5/etc/images/icons/hicolor/32x32/apps/emacs.png" notification)
)

(defun notify-compilation-result (buffer msg)
  "Notify that the compilation is finished"
  (if (equal (buffer-name buffer) "*compilation*")
    (if (string-match "^finished" msg)
      (show-notification "Compilation Successful")
      (show-notification "Compilation Failed")
    )
  )
)

(add-to-list 'compilation-finish-functions 'notify-compilation-result)


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

(autoload 'haskell-tab-indent-mode "~/.emacs.d/haskell-tab-indent.el")

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
