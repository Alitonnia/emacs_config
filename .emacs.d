;;After a while
;; I think we would use Emacs only for writing and demos
;; Code in a IDE 


;;Load path
(setq user-emacs-directory "~/Developments/src/github.com/ALitonnia/dotfiles/common/emacs.d/elisp")

(eval-and-compile
  (setq load-prefer-newer t
        package-user-dir "~/Developments/src/github.com/ALitonnia/dotfiles/common/emacs.d/elpa"
        package--init-file-ensured t
        package-enable-at-startup nil)

  (unless (file-directory-p package-user-dir)
    (make-directory package-user-dir t)))
(eval-and-compile
  (setq load-path (append load-path (directory-files package-user-dir t "^[^.]" t))))

(eval-when-compile
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)
    (package-install 'diminish)
    (package-install 'quelpa)
    (package-install 'bind-key))

  (setq use-package-always-ensure t)
  (setq use-package-expand-minimally t)

  (require 'use-package))
(require 'diminish)
(require 'bind-key)

;; Server
(use-package server
  :ensure nil
 ;:hook (after-init . server-mode)
  )

;; Edit
;; Ignore split window horizontally
(setq split-width-threshold nil)
(setq split-width-threshold 160)

;; Default Encoding
(prefer-coding-system 'utf-8-unix)
(set-locale-environment "en_US.UTF-8")
(set-default-coding-systems 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8) ; included by set-selection-coding-system
(set-keyboard-coding-system 'utf-8) ; configured by prefer-coding-system
(set-terminal-coding-system 'utf-8) ; configured by prefer-coding-system
(setq buffer-file-coding-system 'utf-8) ; utf-8-unix
(setq save-buffer-coding-system 'utf-8-unix) ; nil
(setq process-coding-system-alist
  (cons '("grep" utf-8 . utf-8) process-coding-system-alist))

;; Quiet Startup
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)

(defun display-startup-echo-area-message ()
  (message ""))

(setq frame-title-format nil)
(setq ring-bell-function 'ignore)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same
(setq adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*")
(setq adaptive-fill-first-line-regexp "^* *$")
(setq sentence-end "\\([。、！？]\\|……\\|[,.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)
(setq delete-by-moving-to-trash t)    ; Deleting files go to OS's trash folder
(setq make-backup-files t)          ; Forbide to make backup files
(setq auto-save-default t)        
(setq set-mark-command-repeat-pop t)  ; Repeating C-SPC after popping mark pops it again
(setq track-eol t)			; Keep cursor at end of lines.
(setq line-move-visual nil)		; To be required by track-eol
(setq-default kill-whole-line t)	; Kill line including '\n'
(setq-default indent-tabs-mode nil)   ; use space
(defalias 'yes-or-no-p #'y-or-n-p)

(when (functionp 'mac-auto-ascii-mode)
  (mac-auto-ascii-mode 1))

;; Delete selection if insert something
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; Hungry deletion
(use-package hungry-delete
  :diminish
  :hook (after-init . global-hungry-delete-mode)
  :config (setq-default hungry-delete-chars-to-skip " \t\f\v"))

;;Smart_parens
(use-package smartparens
  :hook
  (after-init . smartparens-global-mode)
  :config
  (require 'smartparens-config)
  (sp-pair "=" "=" :actions '(wrap))
  (sp-pair "+" "+" :actions '(wrap))
  (sp-pair "<" ">" :actions '(wrap))
  (sp-pair "$" "$" :actions '(wrap)))

;;Save place on exit
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

;;Recent file
(use-package recentf
  :ensure t
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 25)
  (recentf-max-menu-items 25)
  ;;(recentf-auto-cleanup 'never)
  (recentf-exclude '((expand-file-name package-user-dir)
                     ".cache"
                     "cache"
                     "recentf"
                     "COMMIT_EDITMSG\\'"))
  (run-at-time nil (* 5 60) 'recentf-save-list)
  )

;; It seems good till here :)

(use-package all-the-icons
  ;; :ensure t ;; Very important when first use this package
  ;; After first run, need M-x all-the-icons-install-fonts :)
  :defer t
  :load-path "~/Developments/src/github.com/ALitonnia/all-the-icons.el/")

;;Key bindings
(global-set-key (kbd "C-o")     'other-window)
(global-set-key (kbd "M-r")     'rename-file)

;; Undo tree
(use-package undo-tree
  :bind
  ("M-/" . undo-tree-redo)
  :config
  (global-undo-tree-mode))

;; Confirm OK :)

;; Key-dict
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (add-hook 'after-init-hook 'which-key-mode)
  :init ;;Possibly hook to posterior hook @@
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom)
  ;;(setq which-key-side-window-location 'right) ;;This hides current modes & remaining keys
  (setq which-key-side-window-max-width 1.0)
  (setq which-key-side-window-max-height 1.0)
  (setq which-key-add-column-padding 0)
  
  (setq which-key-max-display-columns nil)
  (setq which-key-prefix-prefix "" )
  (setq which-key-separator " " )
  (setq which-key-show-remaining-keys t)
  (setq which-key-use-C-h-commands t)
  )

;; End for now

;;Search
(use-package projectile
  :diminish
  :bind
  ("M-o p" . counsel-projectile-switch-project)
  :config
  (setq projectile-projects-cache (make-hash-table))
  (projectile-mode +1))


;; Ag ???
(use-package ag
  :custom
  (ag-highligh-search t)
  (ag-reuse-buffers t)
  (ag-reuse-window t)
  ;:bind
  ;("M-s a" . ag-project)
  :config
  (use-package wgrep-ag))

;;Ivy +Counsel

(use-package counsel
    :diminish ivy-mode counsel-mode
    :defines
    (projectile-completion-system magit-completing-read-function)
    :bind
    (("C-s" . swiper)
    ;("M-s r" . ivy-resume)
    ;("C-c v p" . ivy-push-view)
    ;("C-c v o" . ivy-pop-view)
    ;("C-c v ." . ivy-switch-view)
    ("M-s c" . counsel-ag)
    ("M-o f" . counsel-fzf)
    ("C-x r" . counsel-recentf)
    ;("M-y" . counsel-yank-pop)
    :map ivy-minibuffer-map
    ("C-w" . ivy-backward-kill-word)
    ("C-k" . ivy-kill-line)
    ("C-j" . ivy-immediate-done)
    ("RET" . ivy-alt-done)
    ("C-h" . ivy-backward-delete-char))
    :preface
    (defun ivy-format-function-pretty (cands)
      "Transform CANDS into a string for minibuffer."
      (ivy--format-function-generic
       (lambda (str)
         (concat
             (all-the-icons-faicon "hand-o-right" :height .85 :v-adjust .05 :face 'font-lock-constant-face)
             (ivy--add-face str 'ivy-current-match)))
       (lambda (str)
         (concat "  " str))
       cands
       "\n"))
    :hook
    (after-init . ivy-mode)
    (ivy-mode . counsel-mode)
    :custom
    ;;(counsel-yank-pop-height 15) ;; Bug out somehow
    (enable-recursive-minibuffers t)
    (ivy-use-selectable-prompt t)
    (ivy-use-virtual-buffers t)
    (ivy-on-del-error-function nil)
    (swiper-action-recenter t)
    (counsel-grep-base-command "ag -S --noheading --nocolor --nofilename --numbers '%s' %s")
    :config
    ;; using ivy-format-fuction-arrow with counsel-yank-pop
    (advice-add
    'counsel--yank-pop-format-function
    :override
    (lambda (cand-pairs)
      (ivy--format-function-generic
       (lambda (str)
         (mapconcat
          (lambda (s)
            (ivy--add-face (concat (propertize "┃ " 'face `(:foreground "#61bfff")) s) 'ivy-current-match))
          (split-string
           (counsel--yank-pop-truncate str) "\n" t)
          "\n"))
       (lambda (str)
         (counsel--yank-pop-truncate str))
       cand-pairs
       counsel-yank-pop-separator)))

    ;; NOTE: this variable do not work if defined in :custom
    (setq ivy-format-function 'ivy-format-function-pretty)
    (setq counsel-yank-pop-separator
        (propertize "\n────────────────────────────────────────────────────────\n"
               'face `(:foreground "#6272a4")))

    ;; Integration with `projectile'
    (with-eval-after-load 'projectile
      (setq projectile-completion-system 'ivy))
    ;; Integration with `magit'
    (with-eval-after-load 'magit
      (setq magit-completing-read-function 'ivy-completing-read))

    ;; Enhance fuzzy matching
    (use-package flx)
    ;; Enhance M-x
    (use-package amx)
    ;; Ivy integration for Projectile
    (use-package counsel-projectile
      :config (counsel-projectile-mode 1))

    
  ;; Show ivy frame using posframe
  (use-package ivy-posframe
    :custom
    (ivy-display-function #'ivy-posframe-display-at-frame-center)
    ;; (ivy-posframe-width 130)
    ;; (ivy-posframe-height 11)
    (ivy-posframe-parameters
      '((left-fringe . 5)
        (right-fringe . 5)))
    :custom-face
    (ivy-posframe ((t (:background "#282a36"))))
    (ivy-posframe-border ((t (:background "#6272a4"))))
    (ivy-posframe-cursor ((t (:background "#61bfff"))))
    :hook
    (ivy-mode . ivy-posframe-enable))

  ;; ghq
  (use-package ivy-ghq
    :load-path "~/Developments/src/github.com/analyticd/ivy-ghq"
    :commands (ivy-ghq-open)
    :bind
    ("M-o p" . ivy-ghq-open-and-fzf)
    :custom
    (ivy-ghq-short-list t)
    :preface
    (defun ivy-ghq-open-and-fzf ()
      (interactive)
      (ivy-ghq-open)
      (counsel-fzf)))

  ;; More friendly display transformer for Ivy
  (use-package ivy-rich
    :defines (all-the-icons-dir-icon-alist bookmark-alist)
    :functions (all-the-icons-icon-family
                all-the-icons-match-to-alist
                all-the-icons-auto-mode-match?
                all-the-icons-octicon
                all-the-icons-dir-is-submodule)
    :preface
    (defun ivy-rich-bookmark-name (candidate)
      (car (assoc candidate bookmark-alist)))

    (defun ivy-rich-repo-icon (candidate)
      "Display repo icons in `ivy-rich`."
      (all-the-icons-octicon "repo" :height .9))

    (defun ivy-rich-org-capture-icon (candidate)
      "Display repo icons in `ivy-rich`."
      (pcase (car (last (split-string (car (split-string candidate)) "-")))
         ("emacs" (all-the-icons-fileicon "emacs" :height .68 :v-adjust .001))
         ("schedule" (all-the-icons-faicon "calendar" :height .68 :v-adjust .005))
         ("tweet" (all-the-icons-faicon "commenting" :height .7 :v-adjust .01))
         ("link" (all-the-icons-faicon "link" :height .68 :v-adjust .01))
         ("memo" (all-the-icons-faicon "pencil" :height .7 :v-adjust .01))
         (_       (all-the-icons-octicon "inbox" :height .68 :v-adjust .01))
         ))

    (defun ivy-rich-org-capture-title (candidate)
      (let* ((octl (split-string candidate))
             (title (pop octl))
             (desc (mapconcat 'identity octl " ")))
        (format "%-25s %s"
                 title
                 (propertize desc 'face `(:inherit font-lock-doc-face)))))

    (defun ivy-rich-buffer-icon (candidate)
      "Display buffer icons in `ivy-rich'."
      (when (display-graphic-p)
        (when-let* ((buffer (get-buffer candidate))
                    (major-mode (buffer-local-value 'major-mode buffer))
                    (icon (if (and (buffer-file-name buffer)
                                   (all-the-icons-auto-mode-match? candidate))
                              (all-the-icons-icon-for-file candidate)
                            (all-the-icons-icon-for-mode major-mode))))
          (if (symbolp icon)
              (setq icon (all-the-icons-icon-for-mode 'fundamental-mode)))
          (unless (symbolp icon)
            (propertize icon
                        'face `(
                                :height 1.1
                                :family ,(all-the-icons-icon-family icon)
                                ))))))

    (defun ivy-rich-file-icon (candidate)
      "Display file icons in `ivy-rich'."
      (when (display-graphic-p)
        (let ((icon (if (file-directory-p candidate)
                        (cond
                         ((and (fboundp 'tramp-tramp-file-p)
                               (tramp-tramp-file-p default-directory))
                          (all-the-icons-octicon "file-directory"))
                         ((file-symlink-p candidate)
                          (all-the-icons-octicon "file-symlink-directory"))
                         ((all-the-icons-dir-is-submodule candidate)
                          (all-the-icons-octicon "file-submodule"))
                         ((file-exists-p (format "%s/.git" candidate))
                          (all-the-icons-octicon "repo"))
                         (t (let ((matcher (all-the-icons-match-to-alist candidate all-the-icons-dir-icon-alist)))
                              (apply (car matcher) (list (cadr matcher))))))
                      (all-the-icons-icon-for-file candidate))))
          (unless (symbolp icon)
            (propertize icon
                        'face `(
                                :height 1.1
                                :family ,(all-the-icons-icon-family icon)
                                ))))))
    :hook (ivy-rich-mode . (lambda ()
                             (setq ivy-virtual-abbreviate
                                   (or (and ivy-rich-mode 'abbreviate) 'name))))
    :init
    (setq ivy-rich-display-transformers-list
          '(ivy-switch-buffer
            (:columns
             ((ivy-rich-buffer-icon)
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
             :predicate
             (lambda (cand) (get-buffer cand)))
            ivy-switch-buffer-other-window
            (:columns
             ((ivy-rich-buffer-icon)
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
             :predicate
             (lambda (cand) (get-buffer cand)))
            counsel-M-x
            (:columns
             ((counsel-M-x-transformer (:width 40))
              (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
            counsel-describe-function
            (:columns
             ((counsel-describe-function-transformer (:width 45))
              (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
            counsel-describe-variable
            (:columns
             ((counsel-describe-variable-transformer (:width 45))
              (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
            counsel-find-file
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-file-jump
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-dired-jump
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-git
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-recentf
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate (:width 110))))
            counsel-bookmark
            (:columns
             ((ivy-rich-bookmark-type)
              (ivy-rich-bookmark-name (:width 30))
              (ivy-rich-bookmark-info (:width 80))))
            counsel-projectile-switch-project
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-fzf
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            ivy-ghq-open
            (:columns
             ((ivy-rich-repo-icon)
              (ivy-rich-candidate)))
            ivy-ghq-open-and-fzf
            (:columns
             ((ivy-rich-repo-icon)
              (ivy-rich-candidate)))
            counsel-projectile-find-file
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-org-capture
            (:columns
             ((ivy-rich-org-capture-icon)
              (ivy-rich-org-capture-title)
              ))
            counsel-projectile-find-dir
            (:columns
             ((ivy-rich-file-icon)
              (counsel-projectile-find-dir-transformer)))))

    (setq ivy-rich-parse-remote-buffer nil)
    :config
    (ivy-rich-mode 1))
)
(global-set-key (kbd"\M-x") 'counsel-M-x)

;;Hydra
(use-package hydra)

;; Search highlight
(use-package anzu
  :diminish
  :bind
  ("C-r"   . anzu-query-replace-regexp)
  ;("C-M-r" . anzu-query-replace-at-cursor-thing)
  :hook
  (after-init . global-anzu-mode))

;; Jump around with C +/Null <home>, <end>
(use-package mwim
  :bind
  ("<home>" . mwim-beginning-of-code-or-line)
  ("<end>" . mwim-end-of-code-or-line))

;;Flymake Syntax Check
(use-package flymake-posframe
  :load-path "~/Developments/src/github.com/ALitonnia/flymake-posframe"
  :custom
  (flymake-posframe-error-prefix " ")
  :custom-face
  (flymake-posframe-foreground-face ((t (:foreground "white"))))
  :hook (flymake-mode . flymake-posframe-mode))

(use-package flymake-diagnostic-at-point
  :disabled
  :after flymake
  :custom
  (flymake-diagnostic-at-point-timer-delay 0)
  (flymake-diagnostic-at-point-error-prefix " ")
  (flymake-diagnostic-at-point-display-diagnostic-function 'flymake-diagnostic-at-point-display-popup) ;; or flymake-diagnostic-at-point-display-minibuffer
  :hook
  (flymake-mode . flymake-diagnostic-at-point-mode))

;;Flyspell

(use-package flyspell
  :diminish
  :if (executable-find "aspell")
  :hook
  ((org-mode yaml-mode markdown-mode git-commit-mode) . flyspell-mode)
  (prog-mode . flyspell-prog-mode)
  (before-save-hook . flyspell-buffer)
  (flyspell-mode . (lambda ()
                     (dolist (key '("C-;" "C-," "C-."))
                       (unbind-key key flyspell-mode-map))))
  :custom
  (flyspell-issue-message-flag nil)
  (ispell-program-name "aspell")
  (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
  :custom-face
  (flyspell-incorrect ((t (:underline (:color "#f1fa8c" :style wave)))))
  (flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave)))))
  :preface
  (defun message-off-advice (oldfun &rest args)
    "Quiet down messages in adviced OLDFUN."
    (let ((message-off (make-symbol "message-off")))
      (unwind-protect
          (progn
            (advice-add #'message :around #'ignore (list 'name message-off))
            (apply oldfun args))
        (advice-remove #'message message-off))))
  :config
  (advice-add #'ispell-init-process :around #'message-off-advice)
  
  (use-package flyspell-correct-ivy
    :bind ("C-M-:" . flyspell-correct-at-point)
    :config
    (when (eq system-type 'darwin)
      (progn
        (global-set-key (kbd "C-M-;") 'flyspell-correct-at-point)))
    (setq flyspell-correct-interface #'flyspell-correct-ivy)))

;;Persp

;; Yasnippet
(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-snippet-dirs '("~/.emacs.d/snippets"))
  :hook (after-init . yas-global-mode))

;; Company

(use-package company
  :diminish company-mode
  :defines
  (company-dabbrev-ignore-case company-dabbrev-downcase)
  :bind
  (:map company-active-map
   ("C-n" . company-select-next)
   ("C-p" . company-select-previous)
   ("<tab>" . company-complete-common-or-cycle)
   :map company-search-map
   ("C-p" . company-select-previous)
   ("C-n" . company-select-next))
  :custom
  (company-idle-delay 0)
  (company-echo-delay 0.1)
  (company-minimum-prefix-length 2)
  :hook
  (after-init . global-company-mode)
  (plantuml-mode . (lambda () (set (make-local-variable 'company-backends)
                                   '((company-yasnippet
                                      company-dabbrev
                                      )))))
  ((go-mode
    c++-mode
    c-mode
    objc-mode) . (lambda () (set (make-local-variable 'company-backends)
                                 '((company-yasnippet
                               company-lsp
                               company-files
                               ;; company-dabbrev-code
                               )))))
  )
(use-package company-posframe
  :hook (company-mode . company-posframe-mode))

;; Show quick tooltip
(use-package company-quickhelp
  :defines company-quickhelp-delay
  :bind (:map company-active-map
              ("M-h" . company-quickhelp-manual-begin))
  :hook
  (global-company-mode . company-quickhelp-mode)
  :custom (company-quickhelp-delay 0.1))

;; Done till here
;;; LSP
(use-package lsp-mode
:custom
;; debug
(lsp-print-io nil)
(lsp-trace nil)
(lsp-print-performance nil)
;; general
(lsp-auto-guess-root t)
(lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
(lsp-response-timeout 10)
(lsp-prefer-flymake t) ;; t(flymake), nil(lsp-ui), or :none
(lsp-clients-go-server-args '("--cache-style=always" "--diagnostics-style=onsave" "--format-style=goimports"))
:hook
((go-modec-mode c++-mode) . lsp)
;:bind
;(:map lsp-mode-map
;("C-c r"   . lsp-rename))
)
;; Prefer Shell than Dap
;; Consider breakpoint??
;; Done till here

;; Lsp completion
(use-package company-lsp
:custom
(company-lsp-cache-candidates t) ;; auto, t(always using a cache), or nil
(company-lsp-async t)
(company-lsp-enable-snippet t)
(company-lsp-enable-recompletion t))

;;/////////////////////////////////////////////
;;Minimap
(use-package minimap
  :commands
  (minimap-bufname minimap-create minimap-kill)
  :custom
  (minimap-major-modes '(prog-mode))
  (minimap-window-location 'right)
  (minimap-update-delay 0.1)
  (minimap-minimum-width 20)
  :bind
  ;;("M-t p" . ladicle/toggle-minimap) 
  :preface
  (defun ladicle/toggle-minimap ()
    "Toggle minimap for current buffer."
    (interactive)
    (if (null minimap-bufname)
        (minimap-create)
      (minimap-kill)))
  :config
  (custom-set-faces
   '(minimap-active-region-background
    ((((background dark)) (:background "#555555555555"))
      (t (:background "#C847D8FEFFFF"))) :group 'minimap)))

;; DOOM
(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
  ;; (vertical-bar   (doom-darken base5 0.4))
  ;; (doom-darken bg 0.4)
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  )
;; Nyan
(use-package nyan-mode
   :custom
   (nyan-cat-face-number 4)
   (nyan-animate-nyancat t)
   :hook
   (doom-modeline-mode . nyan-mode))

;; Hide mode
(use-package hide-mode-line
  :hook
  ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode))

;; Line number
(use-package display-line-numbers
  :ensure nil
  :hook
  ((prog-mode yaml-mode systemd-mode) . display-line-numbers-mode))

;; Dimmer
(use-package dimmer
  :disabled
  :custom
  (dimmer-fraction 1.0)
  (dimmer-exclusion-regexp-list
       '(".*Minibuf.*"
         ".*which-key.*"
         ".*NeoTree.*"
         ".*Messages.*"
         ".*Async.*"
         ".*Warnings.*"
         ".*LV.*"
         ".*Ilist.*"))
  :config
  (dimmer-mode t))

;; Fill column indicators
(use-package fill-column-indicator
  :hook
  ((markdown-mode
    git-commit-mode) . fci-mode))

;;E-shell
(setq eshell-prompt-function
      (lambda ()
        (format "%s %s\n%s%s%s "
                (all-the-icons-octicon "repo")
                (propertize (cdr (shrink-path-prompt default-directory)) 'face `(:foreground "white"))
                (propertize "❯" 'face `(:foreground "#ff79c6"))
                (propertize "❯" 'face `(:foreground "#f1fa8c"))
                (propertize "❯" 'face `(:foreground "#50fa7b")))))

(setq eshell-hist-ignoredups t)
(setq eshell-cmpl-cycle-completions nil)
(setq eshell-cmpl-ignore-case t)
(setq eshell-ask-to-save-history (quote always))
(setq eshell-prompt-regexp "❯❯❯ ")
(add-hook 'eshell-mode-hook
          '(lambda ()
             (progn
               (define-key eshell-mode-map "\C-a" 'eshell-bol)
               (define-key eshell-mode-map "\C-r" 'counsel-esh-history)
               (define-key eshell-mode-map [up] 'previous-line)
               (define-key eshell-mode-map [down] 'next-line)
               )))

;; Highlight
(use-package hl-line
  :ensure nil
  :hook
  (after-init . global-hl-line-mode))

;; Matching parenthesis
(use-package paren
  :ensure nil
  :hook
  (after-init . show-paren-mode)
  :custom-face
  (show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c")))) ;; :box t
  :custom
  (show-paren-style 'mixed)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t))

;;Highlight Symbol
(use-package highlight-symbol
  :bind
  (:map prog-mode-map
  ("M-o h" . highlight-symbol)
  ("M-p" . highlight-symbol-prev)
  ("M-n" . highlight-symbol-next)))

;; Cursor Blink
(use-package beacon
  :custom
  (beacon-color "#f1fa8c")
  :hook (after-init . beacon-mode))

;;Rainbow
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-mode
  :diminish
  :hook (emacs-lisp-mode . rainbow-mode))

;; Volitile
(use-package volatile-highlights
  :diminish
  :hook
  (after-init . volatile-highlights-mode)
  :custom-face
  (vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))

;;Indent
(use-package highlight-indent-guides
  :diminish
  :hook
  ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'character)) ; column


(use-package auto-package-update
:ensure
:config
(setq auto-package-update-delete-old-version t
      auto-package-update-interval 2)
(auto-package-update-maybe))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ag-highligh-search t t)
 '(ag-reuse-buffers t)
 '(ag-reuse-window t)
 '(ccls-executable "/usr/local/bin/ccls")
 '(ccls-sem-highlight-method 'font-lock)
 '(company-echo-delay 0.1 t)
 '(company-idle-delay 1)
 '(company-lsp-async t)
 '(company-lsp-cache-candidates t)
 '(company-lsp-enable-recompletion t)
 '(company-lsp-enable-snippet t)
 '(company-minimum-prefix-length 3)
 '(company-quickhelp-delay 1 t)
 '(counsel-grep-base-command
   "ag -S --noheading --nocolor --nofilename --numbers '%s' %s" t)
 '(dap-go-debug-program
   '("node" "~/.extensions/go/out/src/debugAdapter/goDebug.js"))
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(enable-recursive-minibuffers t)
 '(flymake-posframe-error-prefix " " t)
 '(flyspell-issue-message-flag nil)
 '(gofmt-command "goimports" t)
 '(ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
 '(ispell-program-name "aspell")
 '(ivy-on-del-error-function nil t)
 '(ivy-use-selectable-prompt t t)
 '(ivy-use-virtual-buffers t t)
 '(lsp-auto-guess-root t)
 '(lsp-clients-go-server-args
   '("--cache-style=always" "--diagnostics-style=onsave" "--format-style=goimports"))
 '(lsp-document-sync-method 'incremental)
 '(lsp-log-io nil)
 '(lsp-prefer-flymake t)
 '(lsp-print-io nil)
 '(lsp-print-performance nil)
 '(lsp-response-timeout 10)
 '(lsp-trace nil t)
 '(lsp-ui-doc-enable nil t)
 '(lsp-ui-doc-header t t)
 '(lsp-ui-doc-include-signature nil t)
 '(lsp-ui-doc-max-height 30 t)
 '(lsp-ui-doc-max-width 120 t)
 '(lsp-ui-doc-position 'at-point t)
 '(lsp-ui-doc-use-childframe t t)
 '(lsp-ui-doc-use-webkit t t)
 '(lsp-ui-flycheck-enable nil t)
 '(lsp-ui-imenu-enable t t)
 '(lsp-ui-imenu-kind-position 'top t)
 '(lsp-ui-peek-enable t t)
 '(lsp-ui-peek-fontify 'on-demand t)
 '(lsp-ui-peek-list-width 50 t)
 '(lsp-ui-peek-peek-height 20 t)
 '(lsp-ui-sideline-code-actions-prefix "" t)
 '(lsp-ui-sideline-enable nil t)
 '(lsp-ui-sideline-ignore-duplicate t t)
 '(lsp-ui-sideline-show-code-actions t t)
 '(lsp-ui-sideline-show-diagnostics nil t)
 '(lsp-ui-sideline-show-hover t t)
 '(lsp-ui-sideline-show-symbol t t)
 '(minimap-major-modes '(prog-mode) t)
 '(minimap-minimum-width 20 t)
 '(minimap-update-delay 0.5 t)
 '(minimap-window-location 'right t)
 '(package-selected-packages
   '(yasnippet wgrep volatile-highlights use-package undo-tree rainbow-mode rainbow-delimiters quelpa nyan-mode mwim minimap lsp-ui lsp-python lsp-java lsp-intellij js2-mode ivy-rich ivy-posframe ivy-hydra hungry-delete highlight-symbol highlight-indent-guides hide-mode-line go-mode gitignore-mode github-pullrequest gitconfig-mode gitattributes-mode git-timemachine git-gutter flyspell-correct-ivy flx fill-column-indicator doom-themes doom-modeline dockerfile-mode diminish dark-mint-theme dap-mode counsel-projectile company-quickhelp company-posframe company-lsp company-box company-anaconda ccls browse-at-remote beacon avy-zap auto-package-update amx ag ace-window 0blayout))
 '(recentf-exclude
   '((expand-file-name package-user-dir)
     ".cache" "cache" "recentf" "COMMIT_EDITMSG\\'") t)
 '(recentf-max-menu-items 25 t)
 '(recentf-max-saved-items 25 t)
 '(run-at-time nil t)
 '(swiper-action-recenter t t)
 '(wgrep-auto-save-buffer t)
 '(wgrep-change-readonly-file t)
 '(wgrep-enable-key "e")
 '(yas-snippet-dirs '("~/.emacs.d/snippets") t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-posframe-foreground-face ((t (:foreground "white"))))
 '(flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave)))))
 '(flyspell-incorrect ((t (:underline (:color "#f1fa8c" :style wave)))))
 '(ivy-posframe ((t (:background "#282a36"))))
 '(ivy-posframe-border ((t (:background "#6272a4"))))
 '(ivy-posframe-cursor ((t (:background "#61bfff"))))
 '(show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
 '(vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))
