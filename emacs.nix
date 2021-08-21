{ fontSize }:

''
(package-initialize)
(require 'use-package)

(cua-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; (toggle-scroll-bar -1)

(setq display-line-numbers-type t)
(global-display-line-numbers-mode)
(show-paren-mode 1)
(setq auto-save-default t
      make-backup-files t)
(setq confirm-kill-emacs nil)

(require 'unicode-fonts)
(unicode-fonts-setup)

(set-face-attribute 'default nil :font "Source Code Pro for Powerline-${toString fontSize}")
(set-frame-font "Source Code Pro for Powerline-${toString fontSize}" nil t)

;; (load-theme 'spacemacs-dark t)

(require 'undo-tree)
(global-undo-tree-mode)

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes)
(load-theme 'doom-solarized-dark t)

(use-package all-the-icons)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(require 'nix-mode)

(use-package direnv
 :config
 (direnv-mode))

(use-package cmm-mode)
(require 'smartparens-config)

(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook
            (lambda ()
              (lsp)
              (setq evil-shift-width 2)))
  (add-hook 'haskell-mode-hook #'smartparens-mode)
  (add-hook 'haskell-literate-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'smartparens-mode)
  :config
  (setq lsp-haskell-process-path-hie "haskell-language-server")
  (setq lsp-haskell-process-args ())
   ;; Comment/uncomment this line to see interactions between lsp client/server.
  (setq lsp-log-io t))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))
(use-package yasnippet
  :ensure t)
(use-package lsp-mode
  :ensure t
  :hook (haskell-mode . lsp)
  :commands lsp)
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'top))
(use-package lsp-treemacs
  :after lsp)

(use-package haskell-mode
  :init
  (add-hook 'haskell-mode-hook 'font-lock-mode))

;; Better Completion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet yaml-mode which-key vterm use-package typescript-mode smartparens rust-mode rspec-mode ormolu org-roam org-plus-contrib org-drill nix-mode lua-mode lsp-ui lsp-ivy lsp-haskell js2-mode ivy-hydra hasky-extensions haml-mode glsl-mode forge flycheck-elm flx expand-region engine-mode elm-mode direnv dhall-mode dante counsel-projectile coffee-mode))
;; spacemacs-theme
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t)
)
; Add key combinations for interactive haskell-mode
(eval-after-load 'haskell-mode '(progn
  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
  (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
  (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
  (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
  (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))
(eval-after-load 'haskell-cabal '(progn
  (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
  (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
  (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
(eval-after-load 'haskell-cabal
  '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))

(define-key haskell-cabal-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)

;; Unicode symbols
(defvar haskell-font-lock-symbols)
(setq haskell-font-lock-symbols t)
(setq haskell-custom-symbols `(("++" . 8855)
			       ("<>" . 8855)
))

(eval-after-load 'haskell-font-lock
  '(progn
     (setq haskell-font-lock-symbols-alist (append haskell-font-lock-symbols-alist haskell-custom-symbols))
))

;(eval-after-load 'flycheck
;  '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

;(with-eval-after-load 'lsp-mode
;  (defun magthe:lsp-next-checker ()
;    (flycheck-add-next-checker 'lsp '(warning . haskell-ghc)))
;  (add-hook 'lsp-lsp-haskell-after-open-hook
;            #'magthe:lsp-next-checker))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

;;-------------------------------------------------------------------------------
;; Org Mode

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
;;-------------------------------------------------------------------------------
''