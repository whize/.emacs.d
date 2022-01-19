;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 Kei Kawano

;; Author: Kei Kawano <whize.k@gmail.com>

;;; Commentary:

;; My init.el.

;;; code:

;; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))
;; </leaf-install-code>

;; <my-settings>
(leaf leaf-convert :ensure)
(leaf leaf-convert :ensure t)
(leaf leaf-tree
  :ensure t
  :custom ((imenu-list-size . 30)
           (imenu-list-position . 'left)))
(leaf leaf
  :init
  (server-start)
  (global-git-gutter-mode +1)
  )

(leaf cl-lib
  :doc "Common Lisp extensions for Emacs"
  :tag "builtin"
  :added "2021-12-18")

(leaf macrostep
      :ensure t
      :bind (("C-c e" . macrostep-expand)))

(leaf cus-edit
      :doc "tools for customizing Emacs and Lisp packages"
      :tag "builtin" "faces" "help"
      :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "Kei Kawano")
            (user-mail-address . "whize.k@gmail.com")
            (user-login-name . "whize")
            (create-lockfiles . nil)
            (debug-on-error . nil)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            ;; (use-dialog-box . nil)
            ;; (use-file-dialog . nil)
            ;; (menu-bar-mode . t)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil)
            (mac-option-modifier . 'meta)
            ;; (mac-auto-operator-composition-mode . t)
            )
  :config
  (setq inhibit-startup-message t)
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?)
  (set-frame-position nil 0 -24)
  (set-frame-parameter nil 'alpha 98)   ;背景透過
  (size-indication-mode t)
  (setq next-line-add-newlines t)
  :hook
  (doc-view-mode-hook . (lambda ()
                          (display-line-numbers-mode 0)))
  (pdf-view-mode-hook . (lambda ()
                          (display-line-numbers-mode 0)))
  (vterm-mode-hook . (lambda ()
                       (display-line-numbers-mode 0)))
  (before-save-hook . 'gofmt-before-save)
  )

(setq gc-cons-threshold 16777216)
(setq read-process-output-max (* 1024 1024 2))

(setq default-frame-alist
      '(
       (font . "FiraCode Nerd Font 13")))
        ;; (font . "Cica 14")))

;; ligatures setting
;; refer: https://github.com/tonsky/FiraCode/wiki/Emacs-instructions
;;
(when (window-system)
  (set-frame-font "Fira Code"))
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))


;;; Scroll settings
;; スクロール設定
(leaf *scroll-settings
  :config
  (setq scroll-preserve-screen-position t)
  (leaf smooth-scroll
    :doc "Minor mode for smooth scrolling and in-place scrolling."
    :tag "frames" "emulations" "convenience"
    :url "http://www.emacswiki.org/emacs/download/smooth-scroll.el"
    :added "2021-12-18"
    :ensure t
    :config
    (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
    (setq mouse-wheel-progressive-speed nil)
    (setq mouse-wheel-follow-mouse 't)
    (setq scroll-step 1))
  )

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1" "cl-lib-0.6"
  :tag "environment" "unix" "emacs>=24.1"
  :url "https://github.com/purcell/exec-path-from-shell"
  :added "2021-12-18"
  :emacs>= 24.1
  :ensure t
  :custom
  (exec-path-from-shell-arguments . "")
  (exec-path-from-shell-variables . '("PATH" "GOPATH"))
  :init
  (exec-path-from-shell-initialize)
  )

(leaf *mini-frame
  :if (version<= "27" emacs-version)
  :config
  (setq resize-mini-frames t))

;; global-set-key
(leaf *key-binding
  :config
  (leaf *global
    :config
    (global-set-key (kbd "C-z") nil)
    (global-set-key (kbd "C-h") #'backward-delete-char)
    (global-set-key (kbd "M-?") #'help-for-help)
    (global-set-key (kbd "C-m") #'newline-and-indent)
    (global-set-key (kbd "C-x /") #'dabbrev-expand)
    (global-set-key (kbd "C-x ,") #'delete-region)
    (global-set-key (kbd "M-;") #'comment-dwim)
    (global-set-key (kbd "C-x C-b") #'ibuffer)
    (global-set-key (kbd "C-x ?") #'help-command)

    (global-set-key [wheel-up] #'(lambda () "" (interactive) (scroll-down 1)))
    (global-set-key [wheel-down] #'(lambda () "" (interactive) (scroll-up 1)))
    (global-set-key [double-wheel-up] #'(lambda () "" (interactive) (scroll-down 1)))
    (global-set-key [double-wheel-down] #'(lambda () "" (interactive) (scroll-up 1)))
    (global-set-key [triple-wheel-up] #'(lambda () "" (interactive) (scroll-down 2)))
    (global-set-key [triple-wheel-down] #'(lambda () "" (interactive) (scroll-up 2)))

    (global-set-key (kbd "C-c a") #'org-agenda)
    (global-set-key (kbd "C-;") #'switch-to-buffer)
    (global-set-key (kbd "<f2>") nil))

  (leaf *map-local
    :config
    (define-key read-expression-map (kbd "TAB") #'completion-at-point)
    (define-key isearch-mode-map (kbd "C-h") #'isearch-delete-char)))

(leaf restart-emacs
  :doc "Restart emacs from within emacs"
  :tag "convenience"
  :url "https://github.com/iqbalansari/restart-emacs"
  :added "2021-12-19"
  :ensure t)

(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3" "memoize-1.0.1"
  :tag "lisp" "convenient" "emacs>=24.3"
  :url "https://github.com/domtronn/all-the-icons.el"
  :added "2021-12-18"
  :emacs>= 24.3
  :ensure t
  :after memoize)

(leaf projectile
  :doc "Manage and navigate projects in Emacs easily"
  :req "emacs-25.1"
  :tag "convenience" "project" "emacs>=25.1"
  :url "https://github.com/bbatsov/projectile"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :bind
  ("s-p" . projectile-command-map)
  (projectile-mode-map
   ("C-." . projectile-next-project-buffer)
   ("C-," . projectile-previous-project-buffer))
  :custom
  (projectile-completion-system . 'ivy)
  :global-minor-mode t)

;; color theme

(leaf *color-theme
  :config
  (leaf doom-themes
    :doc "an opinionated pack of modern color-themes"
    :req "emacs-25.1" "cl-lib-0.5"
    :tag "faces" "custom themes" "emacs>=25.1"
    :url "https://github.com/hlissner/emacs-doom-themes"
    :added "2021-12-18"
    :emacs>= 25.1
    :ensure t
    :init (load-theme 'doom-one t)
    :config
    (doom-themes-neotree-config))
  ;; (leaf cyberpunk-theme
  ;;   :doc "Cyberpunk Color Theme"
  ;;   :tag "cyberpunk" "theme" "color"
  ;;   :url "https://github.com/n3mo/cyberpunk-theme.el"
  ;;   :added "2021-12-18"
  ;;   :ensure t
  ;;   :init (load-theme 'cyberpunk t))
  ;; (leaf modus-themes
  ;;   :doc "Highly accessible themes (WCAG AAA)"
  ;;   :req "emacs-27.1"
  ;;   :tag "accessibility" "theme" "faces" "emacs>=27.1"
  ;;   :url "https://gitlab.com/protesilaos/modus-themes"
  ;;   :added "2021-12-18"
  ;;   :emacs>= 27.1
  ;;   :ensure t
  ;;   :custom
  ;;   ((modus-themes-bold-constructs . nil)
  ;;    (modus-themes-italic-constructs . nil)
  ;;    (modus-themes-region . '(bd-only no-extend)))
  ;;   :init
  ;;   (modus-themes-load-themes)
  ;;   :config
  ;;   (modus-themes-load-vivendi)
  ;;   :bind
  ;;   ("<f5>" . modus-themes-toggle)
  ;;   )
  )

(leaf modeline
  :config
  (leaf doom-modeline
    :doc "A minimal and modern mode-line"
    :req "emacs-25.1" "all-the-icons-2.2.0" "shrink-path-0.2.0" "dash-2.11.0"
    :tag "mode-line" "faces" "emacs>=25.1"
    :url "https://github.com/seagle0128/doom-modeline"
    :added "2021-12-18"
    :emacs>= 25.1
    :ensure t
    :custom
    (doom-modeline-buffer-file-name-style . 'truncate-with-project)
    (doom-modeline-icon . t)
    (doom-modeline-major-mode-icon . t)
    (doom-modeline-minor-modes . t)
    (doom-modeline-github . t)
    ;; (doom-modeline-def-modeline 'main
    ;;   '(bar window-number modals matches follow buffer-info remote-host buffer-position word-count parrot selection-info)
    ;;   '(objed-state misc-info persp-name battery github lsp github debug minor-modes input-method major-mode process vcs checker))
    :init (doom-modeline-mode 1)
    :config
    (line-number-mode 0)
    (column-number-mode 0)

    )

  ;; (leaf moody
  ;;   :doc "Tabs and ribbons for the mode line"
  ;;   :req "emacs-25.3"
  ;;   :tag "emacs>=25.3"
  ;;   :url "https://github.com/tarsius/moody"
  ;;   :added "2021-12-18"
  ;;   :emacs>= 25.3
  ;;   :ensure t
  ;;   :custom
  ;;   (x-underline-at-descent-line . t)
  ;;   (moody-slant-function . 'moody-slant-apple-rgb)
  ;;   :config
  ;;   (moody-replace-mode-line-buffer-identification)
  ;;   (moody-replace-vc-mode)
  ;;   (moody-replace-eldoc-minibuffer-message-function)
  ;;   )
  (leaf minions
    :doc "A minor-mode menu for the mode line"
    :req "emacs-25.2"
    :tag "emacs>=25.2"
    :url "https://github.com/tarsius/minions"
    :added "2021-12-18"
    :emacs>= 25.2
    :ensure t
    :custom (minions-mode-line-lighter . "[+]")
    :global-minor-mode t)
  (leaf hide-mode-line
    :doc "minor mode that hides/masks your modeline"
    :req "emacs-24.4"
    :tag "mode-line" "frames" "emacs>=24.4"
    :url "https://github.com/hlissner/emacs-hide-mode-line"
    :added "2021-12-18"
    :emacs>= 24.4
    :ensure t neotree imenu-list
    :hook
    (neotree-mode . hide-mode-line)
    )
  )


;; ファイル変更自動リロード
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :added "2021-12-17"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :added "2021-12-18"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

;; 選択範囲上書き時削除挿入
(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :added "2021-12-17"
  :global-minor-mode delete-selection-mode)

(leaf undo-tree
  :doc "Treat undo history as a tree"
  :tag "tree" "history" "redo" "undo" "files" "convenience"
  :url "http://www.dr-qubit.org/emacs.php"
  :added "2021-12-18"
  :ensure t
  :global-minor-mode global-undo-tree-mode)

;; 対応する括弧を強調
(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

;; 対応する閉じ括弧を自動入力
(leaf electric
  :doc "window maker and Command loop for `electric' modes"
  :tag "builtin"
  :added "2021-12-16"
  :init (electric-pair-mode 1))

;; startup
(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :added "2021-12-18"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;; 行番号表示
(leaf display-line-numbers
  :doc "interface for display-line-numbers"
  :tag "builtin"
  :added "2021-12-18"
  :config
  (global-display-line-numbers-mode t))

(leaf popup
  :doc "Visual Popup User Interface"
  :req "emacs-24.3"
  :tag "lisp" "emacs>=24.3"
  :url "https://github.com/auto-complete/popup-el"
  :added "2021-12-18"
  :emacs>= 24.3
  :ensure t)

;; ivy
(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :added "2021-12-17"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-re-builders-alist . '((t . ivy--regex-fuzzy)
                                      (swiper . ivy--regex-plus)))
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.4"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :added "2021-12-17"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "ivy-0.13.4" "swiper-0.13.4"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :added "2021-12-17"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf ivy-rich
  :doc "More friendly display transformer for ivy"
  :req "emacs-25.1" "ivy-0.13.0"
  :tag "ivy" "convenience" "emacs>=25.1"
  :url "https://github.com/Yevgnen/ivy-rich"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :after ivy
  :global-minor-mode t)


(leaf hl-todo
  :doc "highlight TODO and similar keywords"
  :req "emacs-25"
  :tag "convenience" "emacs>=25"
  :url "https://github.com/tarsius/hl-todo"
  :added "2021-12-18"
  :emacs>= 25
  :ensure t
  :global-minor-mode t
  :custom
  (hl-todo-keyword-faces . '(("TODO" . "#FF4500")
                             ("FIXME" . "#DDAE13")
                             ("DEBUG" . "#1E90FF")))
  :init
  (global-hl-todo-mode t))

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :added "2021-12-17"
  :emacs>= 25.1
  :ensure t
  :commands (prescient-persist-mode)
  :custom `((prescient-aggressive-file-save . t)
            (prescient-save-file . ,(locate-user-emacs-file "prescient")))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-5.1" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :added "2021-12-17"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf vterm
  ;; requirements: brew install cmake libvterm libtool
  :doc "Fully-featured terminal emulator"
  :req "emacs-25.1"
  :tag "terminals" "emacs>=25.1"
  :url "https://github.com/akermu/emacs-libvterm"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :commands (vterm-mode)
  :bind
  ("<f2>" . vterm-toggle)
  (vterm-mode-map
   ("C-<f2>" . my/vterm-new-buffer-in-current-window)
   ("C-<return>" . vterm-toggle-insert-cd)
   ([remap projectile-previous-project-buffer] . vterm-toggle-forward)
   ([remap projectile-next-project-buffer] . vterm-toggle-backward))
  :init
  (when noninteractive
    (advice-add #'vterm-module-compile :override #'ignore)
    (provide 'vterm-module))
  :hook
  ((vterm-mode . hide-mode-line-mode))
  :custom
  (vterm-max-scrollback . 10000)
  (vterm-buffer-name-string . "vterm: %s")
  (vterm-kill-buffer-on-exit . t)
  (vterm-keymap-exceptions
   . '("<f1>" "<f2>" "C-c" "C-x" "C-u" "C-g" "C-l" "M-x" "M-o" "C-v" "M-v" "C-y" "M-y"))
  )

(leaf vterm-toggle
  :doc "Toggles between the vterm buffer and other buffers."
  :req "emacs-25.1" "vterm-0.0.1"
  :tag "terminals" "vterm" "emacs>=25.1"
  :url "https://github.com/jixiuf/vterm-toggle"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :after vterm
  :custom
  (vterm-toggle-scope . 'project)
  :config
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-in-direction)
                 (direction . bottom)
                 (reusable-frames . visible)
                 (window-height . 0.4)))
  (defun my/vterm-new-buffer-in-current-window()
    (interactive)
    (let ((display-buffer-alist nil))
      (vterm)))
  )

(leaf pangu-spacing
  :doc "Minor-mode to add space between Chinese and English characters."
  :url "http://github.com/coldnew/pangu-spacing"
  :added "2021-12-18"
  :ensure t
  :custom ((pangu-spacing-real-insert-separator . t))
  :hook ((text-mode-hook . pangu-spacing-mode)
         (org-mode-hook . pangu-spacing-mode)))

(leaf syntax
  :doc "helper functions to find syntactic context"
  :tag "builtin"
  :added "2021-12-20")

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :added "2021-12-17"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode
  )

(leaf flyspell
  :doc "On-the-fly spell checker"
  :tag "builtin"
  :added "2021-12-18"
  :custom
  (ispell-program-name . "aspell")
  (ispell-local-dictionary . "en_US")
  :hook
  (text-mode-hook . flyspell-mode)
  (org-mode-hook . flyspell-mode)
  :init
  (leaf flyspell-popup
    :doc "Correcting words with Flyspell in popup menus"
    :req "popup-0.5.0"
    :tag "convenience"
    :url "https://github.com/xuchunyang/flyspell-popup"
    :added "2021-12-18"
    :ensure t
    :after flyspell
    :hook (flyspell-mode-hook . flyspell-popup-auto-correct-mode)))

(leaf editorconfig
  :doc "EditorConfig Emacs Plugin"
  :req "cl-lib-0.5" "nadvice-0.3" "emacs-24"
  :tag "emacs>=24"
  :url "https://github.com/editorconfig/editorconfig-emacs#readme"
  :added "2021-12-18"
  :emacs>= 24
  :ensure t
  :after nadvice
  :custom ((editorconfig-get-properties-function . 'editorconfig-core-get-properties-hash)))

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-25.1"
  :tag "matching" "convenience" "abbrev" "emacs>=25.1"
  :url "http://company-mode.github.io/"
  :added "2021-12-17"
  :emacs>= 25.1
  :ensure t
  :blackout t
  :defvar company-backends
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0.2)
           (company-minimum-prefix-length . 1)
           ;; (company-transformers . '(company-sort-by-occurrence))
           )
  :global-minor-mode global-company-mode)


(leaf eldoc
  :doc "Show function arglist or variable docstring in echo area"
  :tag "builtin"
  :added "2021-12-18"
  :ensure t)

(leaf ripgrep
  :doc "Front-end for ripgrep, a command line search tool"
  :tag "search" "grep" "sift" "ag" "pt" "ack" "ripgrep"
  :url "https://github.com/nlamirault/ripgrep.el"
  :added "2021-12-18"
  :ensure t)

(leaf dumb-jump
  :doc "Jump to definition for 50+ languages without configuration"
  :req "emacs-24.3" "s-1.11.0" "dash-2.9.0" "popup-0.5.3"
  :tag "programming" "emacs>=24.3"
  :url "https://github.com/jacktasia/dumb-jump"
  :added "2021-12-18"
  :emacs>= 24.3
  :ensure t
  :custom ((dumb-jump-selector . 'ivy)))

(leaf smart-jump
  :doc "Smart go to definition."
  :req "emacs-25.1"
  :tag "tools" "emacs>=25.1"
  :url "https://github.com/jojojames/smart-jump"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :after dumb-jump
  :config (smart-jump-setup-default-registers))

(leaf dap-mode
  :doc "Debug Adapter Protocol mode"
  :req "emacs-26.1" "dash-2.18.0" "lsp-mode-6.0" "bui-1.1.0" "f-0.20.0" "s-1.12.0" "lsp-treemacs-0.1" "posframe-0.7.0" "ht-2.3"
  :tag "debug" "languages" "emacs>=26.1"
  :url "https://github.com/emacs-lsp/dap-mode"
  :added "2021-12-18"
  :emacs>= 26.1
  :ensure t
  :after lsp-mode bui lsp-treemacs posframe
  :custom
  '(dap-auto-configure-features . '(sessions locals controls tooltip))
  )

(leaf lsp-mode
  :doc "LSP mode"
  :req "emacs-26.1" "dash-2.18.0" "f-0.20.0" "ht-2.3" "spinner-1.7.3" "markdown-mode-2.3" "lv-0"
  :tag "languages" "emacs>=26.1"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :added "2021-12-18"
  :emacs>= 26.1
  :ensure t
  :after spinner markdown-mode lv
  :custom
  '((lsp-keymap-prefix . "C-c l")
    (lsp-inhibit-message . t)
    (lsp-message-project-root-wawrning . t)
    (create-lockfiles . nil)
    (lsp-signature-auto-activate . t)
    (lsp-signature-doc-lines . 1)
    (lsp-print-performance .t)
    (lsp-log-io . t)
    (lsp-eldoc-render-all . t)
    (lsp-enable-completion-at-point . t)
    (lsp-enable-xref . t)
    (lsp-keep-workspace-alive . nil)
    (lsp-enable-snippet . t)
    (lsp-server-trace . nil)
    (lsp-auto-guess-root . nil)
    (lsp-document-sync-method . 2)
    (lsp-diagnostics-provider . :flycheck)
    (lsp-response-timeout . 5)
    (lsp-idle-delay . 0.500)
    (lsp-enable-files-watchers . nil)
    (lsp-completion-provider . :capf)
    (lsp-headerline-breadcrumb-segments . '(symbols))
    ;; (lsp-rust-server . 'rust-analyzer)
    (lsp-rust-analyzer-cargo-watch-command . "clippy")
    (lsp-rust-analyzer-server-display-inlay-hints . t)
    )
  :commands
  (lsp lsp-deferred)
  :hook
  (prog-major-mode . lsp-prog-major-mode-enable)
  (lsp-mode-hook . lsp-ui-mode)
  (lsp-mode-hook . lsp-headerline-breadcrumb-mode)
  :init
  (leaf lsp-ui
    :doc "UI modules for lsp-mode"
    :req "emacs-26.1" "dash-2.18.0" "lsp-mode-6.0" "markdown-mode-2.3"
    :tag "tools" "languages" "emacs>=26.1"
    :url "https://github.com/emacs-lsp/lsp-ui"
    :added "2021-12-18"
    :emacs>= 26.1
    :ensure t
    :after lsp-mode markdown-mode
    :custom
    ((lsp-ui-doc-enable . t)
     (lsp-ui-doc-delay . 0.5)
     (lsp-ui-doc-header . t)
     (lsp-ui-doc-include-signature . t)
     (lsp-ui-doc-position . 'at-point)
     (lsp-ui-doc-max-width . 150)
     (lsp-ui-doc-max-height . 30)
     (lsp-ui-doc-use-childframe . nil)
     (lsp-ui-doc-use-webkit . nil)
     (lsp-ui-flycheck-enable . t)
     (lsp-ui-peek-enable . t)
     (lsp-ui-peek-peek-height . 20)
     (lsp-ui-peek-list-width . 50)
     (lsp-ui-peek-fontify . 'on-demand)
     )
    :hook ((lsp-mode-hook . lsp-ui-mode))
    )
  (leaf lsp-treemacs
    :doc "LSP treemacs"
    :req "emacs-26.1" "dash-2.18.0" "f-0.20.0" "ht-2.0" "treemacs-2.5" "lsp-mode-6.0"
    :tag "languages" "emacs>=26.1"
    :url "https://github.com/emacs-lsp/lsp-treemacs"
    :added "2021-12-18"
    :emacs>= 26.1
    :ensure t
    :after treemacs lsp-mode)
  )

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "dash-20210826" "git-commit-20211004" "magit-section-20211004" "transient-20210920" "with-editor-20211001"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :url "https://github.com/magit/magit"
  :added "2021-12-18"
  :emacs>= 25.1
  :ensure t
  :after git-commit magit-section with-editor)

(leaf fringe-helper
  :doc "helper functions for fringe bitmaps"
  :tag "lisp"
  :url "http://nschum.de/src/emacs/fringe-helper/"
  :added "2021-12-18"
  :ensure t)

(leaf git-gutter
  :doc "Port of Sublime Text plugin GitGutter"
  :req "emacs-24.4"
  :tag "emacs>=24.4"
  :url "https://github.com/emacsorphanage/git-gutter"
  :added "2021-12-18"
  :emacs>= 24.4
  :ensure t
  :custom ((left-fringe-width . 20)
           (git-gutter:window-width . 2))
  :config
  (leaf git-gutter-fringe
     :doc "Fringe version of git-gutter.el"
     :req "git-gutter-0.88" "fringe-helper-0.1.1" "cl-lib-0.5" "emacs-24"
     :tag "emacs>=24"
     :url "https://github.com/emacsorphanage/git-gutter-fringe"
     :added "2021-12-18"
     :emacs>= 24
     :ensure t
     :after git-gutter fringe-helper))

(leaf visual-regexp
  :doc "A regexp/replace command for Emacs with interactive visual feedback"
  :req "cl-lib-0.2"
  :tag "feedback" "visual" "replace" "regexp"
  :url "https://github.com/benma/visual-regexp.el/"
  :added "2021-12-18"
  :ensure t)

(leaf ispell
  :doc "interface to spell checkers"
  :tag "builtin"
  :added "2021-12-18"
  :custom
  (ispell-program-name . "aspell")
  (ispell-local-dictionary . "en_US")
  :after
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+"))
  )

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2021-12-18"
  :custom
  ((org-startup-indented . t)
   (org-structure-template-alist . '(("a" . "export ascii\n")
                                     ("c" . "center\n")
                                     ("C" . "comment\n")
                                     ("e" . "example\n")
                                     ("E" . "export")
                                     ("h" . "export html\n")
                                     ("l" . "export latex\n")
                                     ("q" . "quote\n")
                                     ("s" . "src\n")
                                     ("v" . "verse\n")))
   )
  :custom
  '((org-modules . (org-modules org-tempo)))
  :hook
  (org-mode-hook . hl-todo-mode)
  )


;;; Languages

;;; Golang

(setenv "GO111MODULE" "on")

(leaf go-eldoc
  :doc "eldoc for go-mode"
  :req "emacs-24.3" "go-mode-1.0.0"
  :tag "emacs>=24.3"
  :url "https://github.com/syohex/emacs-go-eldoc"
  :added "2021-12-20"
  :emacs>= 24.3
  :ensure t
  :after go-mode)

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :url "https://github.com/dominikh/go-mode.el"
  :added "2021-12-18"
  :ensure t
  :bind
  ((go-mode-map
    ("M-." . go-guru-definition)
    ("M-," . pop-tag-mark)))
  :hook
  (go-mode-hook . lsp-deferred)
  (go-mode-hook . go-eldoc-setup)
  (before-save-hook . gofmt-before-save)
  :custom
  (gofmt-command . "goimports")
  )

(leaf go-guru
  :doc "Integration of the Go 'guru' analysis tool into Emacs."
  :req "go-mode-1.3.1" "cl-lib-0.5"
  :tag "tools"
  :added "2021-12-20"
  :ensure t
  :after go-mode)

(leaf gorepl-mode
  :doc "Go REPL Interactive Development in top of Gore"
  :req "emacs-24" "s-1.11.0" "f-0.19.0" "hydra-0.13.0"
  :tag "gorepl" "golang" "go" "languages" "emacs>=24"
  :url "http://www.github.com/manute/gorepl-mode"
  :added "2021-12-20"
  :emacs>= 24
  :ensure t
  :after hydra
  :commands
  (gorepl-run-load-current-file)
  )

(leaf go-tag
  :doc "Edit Golang struct field tag"
  :req "emacs-24.0" "go-mode-1.5.0"
  :tag "tools" "emacs>=24.0"
  :url "https://github.com/brantou/emacs-go-tag"
  :added "2021-12-20"
  :emacs>= 24.0
  :ensure t
  :after go-mode)

(leaf flycheck-golangci-lint
  :doc "Flycheck checker for golangci-lint"
  :req "emacs-24" "flycheck-0.22"
  :tag "go" "tools" "convenience" "emacs>=24"
  :url "https://github.com/weijiangan/flycheck-golangci-lint"
  :added "2021-12-20"
  :emacs>= 24
  :ensure t
  :after flycheck
  :hook
  (go-mode . flycheck-golangci-lint-setup))

;; PHP
;; I usually use PHPStrom
(leaf php-cs-fixer
  :doc "php-cs-fixer wrapper."
  :req "cl-lib-0.5"
  :tag "php" "languages"
  :url "https://github.com/OVYA/php-cs-fixer"
  :added "2021-12-19"
  :ensure t)

(leaf php-boris
  :doc "Run boris php REPL"
  :tag "boris" "repl" "commint" "php"
  :added "2021-12-19"
  :ensure t)

(leaf phpunit
  :doc "Launch PHP unit tests using phpunit"
  :req "s-1.12.0" "f-0.19.0" "pkg-info-0.6" "cl-lib-0.5" "emacs-24.3"
  :tag "phpunit" "tests" "php" "tools" "emacs>=24.3"
  :url "https://github.com/nlamirault/phpunit.el"
  :added "2021-12-19"
  :emacs>= 24.3
  :ensure t)

(leaf php-mode
  :doc "Major mode for editing PHP code"
  :req "emacs-25.2"
  :tag "php" "languages" "emacs>=25.2"
  :url "https://github.com/emacs-php/php-mode"
  :added "2021-12-19"
  :emacs>= 25.2
  :ensure t
  :custom
  (php-mode-template-compatibility . nil)
  :hook
  (php-mode-hook . rainbow-delimiters-mode)
  (php-mode-hook . php-enable-psr2-coding-style)
  )

;; Web
(leaf web-mode
  :doc "major mode for editing web templates"
  :req "emacs-23.1"
  :tag "languages" "emacs>=23.1"
  :url "https://web-mode.org"
  :added "2021-12-18"
  :emacs>= 23.1
  :ensure t
  :custom
  (web-mode-enable-auto-pairing . t)
  (web-mode-enable-auto-closing . t)
  (web-mode-enable-current-element-highlight . t)
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  )

;; Rust language
;; (leaf rust-mode
;;   :doc "A major-mode for editing Rust source code"
;;   :req "emacs-25.1"
;;   :tag "languages" "emacs>=25.1"
;;   :url "https://github.com/rust-lang/rust-mode"
;;   :added "2021-12-22"
;;   :emacs>= 25.1
;;   :ensure t
;;   :custom
;;   (rust-format-on-save . t)
;;   :hook
;;   (flycheck-mode-hook . #'flycheck-rust-setup))

(leaf rustic
  :doc "Rust development environment"
  :req "emacs-26.1" "rust-mode-1.0.3" "dash-2.13.0" "f-0.18.2" "let-alist-1.0.4" "markdown-mode-2.3" "project-0.3.0" "s-1.10.0" "seq-2.3" "spinner-1.7.3" "xterm-color-1.6"
  :tag "languages" "emacs>=26.1"
  :added "2021-12-22"
  :emacs>= 26.1
  :ensure t
  :after rust-mode markdown-mode project spinner xterm-color
  :custom
  (rustic-format-on-save . t))

;; (leaf cargo
;;   :doc "Emacs Minor Mode for Cargo, Rust's Package Manager."
;;   :req "emacs-24.3" "markdown-mode-2.4"
;;   :tag "tools" "emacs>=24.3"
;;   :added "2021-12-22"
;;   :emacs>= 24.3
;;   :ensure t
;;   :after markdown-mode
;;   :hook
;;   (rustic-mode . cargo-minor-mode))

;; (leaf flycheck-rust
;;   :doc "Flycheck: Rust additions and Cargo support"
;;   :req "emacs-24.1" "flycheck-28" "dash-2.13.0" "seq-2.3" "let-alist-1.0.4"
;;   :tag "convenience" "tools" "emacs>=24.1"
;;   :url "https://github.com/flycheck/flycheck-rust"
;;   :added "2021-12-22"
;;   :emacs>= 24.1
;;   :ensure t
;;   :after flycheck)

;; File type
(leaf dotenv-mode
  :doc "Major mode for .env files"
  :req "emacs-24.3"
  :tag "emacs>=24.3"
  :url "https://github.com/preetpalS/emacs-dotenv-mode"
  :added "2022-01-14"
  :emacs>= 24.3
  :ensure t)

(leaf json-mode
  :doc "Major mode for editing JSON files."
  :req "json-snatcher-1.0.0" "emacs-24.4"
  :tag "emacs>=24.4"
  :url "https://github.com/joshwnj/json-mode"
  :added "2021-12-18"
  :emacs>= 24.4
  :ensure t
  :after json-snatcher)

(leaf nginx-mode
  :doc "major mode for editing nginx config files"
  :tag "nginx" "languages"
  :added "2021-12-18"
  :ensure t)

(leaf yaml-mode
  :doc "Major mode for editing YAML files"
  :req "emacs-24.1"
  :tag "yaml" "data" "emacs>=24.1"
  :url "https://github.com/yoshiki/yaml-mode"
  :added "2021-12-18"
  :emacs>= 24.1
  :ensure t)

(leaf dockerfile-mode
  :doc "Major mode for editing Docker's Dockerfiles"
  :req "emacs-24"
  :tag "docker" "emacs>=24"
  :url "https://github.com/spotify/dockerfile-mode"
  :added "2021-12-18"
  :emacs>= 24
  :ensure t)

(leaf ox-gfm
  :doc "Github Flavored Markdown Back-End for Org Export Engine"
  :tag "github" "markdown" "wp" "org"
  :added "2021-12-18"
  :ensure t
  :init
  '(require 'ox-gfm nil t))

(leaf rainbow-delimiters
  :doc "Highlight brackets according to their depth"
  :tag "tools" "lisp" "convenience" "faces"
  :url "https://github.com/Fanael/rainbow-delimiters"
  :added "2021-12-19"
  :ensure t)


(leaf markdown-mode
  :doc "Major mode for Markdown-formatted text"
  :req "emacs-25.1"
  :tag "itex" "github flavored markdown" "markdown" "emacs>=25.1"
  :url "https://jblevins.org/projects/markdown-mode/"
  :added "2021-12-20"
  :emacs>= 25.1
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . gfm-mode))
  :init
  (defvar markdown-command "/usr/local/bin/multimarkdown"))

(leaf plantuml-mode
  :doc "Major mode for PlantUML"
  :req "dash-2.0.0" "emacs-25.0"
  :tag "ascii" "plantuml" "uml" "emacs>=25.0"
  :added "2021-12-20"
  :emacs>= 25.0
  :ensure t
  :custom
  (plantuml-executable-path . "plantuml")
  (plantuml-default-exec-mode . 'jar)
  (plantuml-jar-path . "~/bin/plantuml.jar")
  (plantuml-output-type . "png")
  :config
  (add-to-list 'auto-mode-alist '("\\.pu$\\'" . plantuml-mode))
  )

(leaf calendar
  :doc "calendar functions"
  :tag "builtin"
  :added "2021-12-18"
  :init
  (leaf japanese-holidays
    :doc "Calendar functions for the Japanese calendar"
    :req "emacs-24.1" "cl-lib-0.3"
    :tag "calendar" "emacs>=24.1"
    :url "https://github.com/emacs-jp/japanese-holidays"
    :added "2021-12-18"
    :emacs>= 24.1
    :ensure t
    :custom
    ((calendar-mark-holidays-flag . t)
     (calendar-holidays . (append japanese-holidays hliday-local-holidays holiday-other-holidays)))
    :hook
    ((calendar-today-visible-hook . calendar-mark-today)
     (calendar-today-visible-hook . japanese-holiday-mark-weekend)
     (calendar-today-invisible-hook . japanese-holiday-mark-weekend))
    )
  )

;; </my-settings>

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
