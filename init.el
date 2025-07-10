;;; init.el --- Emacs-Kick --- A feature rich Emacs config for (neo)vi(m)mers -*- lexical-binding: t; -*-
;; Author: Rahul Martim Juliato

;; Version: 0.2.0
;; Package-Requires: ((emacs "30.1"))
;; License: GPL-2.0-or-later

;;; Commentary:
;;; Code:

;; Performance Hacks
;; Emacs is an Elisp interpreter, and when running programs or packages,
;; it can occasionally experience pauses due to garbage collection.
;; By increasing the garbage collection threshold, we reduce these pauses
;; during heavy operations, leading to smoother performance.
(setq gc-cons-threshold #x40000000)

;; Set the maximum output size for reading process output, allowing for larger data transfers.
(setq read-process-output-max (* 1024 1024 4))

;; Do I really need a speedy startup?
;; Well, this config launches Emacs in about ~0.3 seconds,
;; which, in modern terms, is a miracle considering how fast it starts
;; with external packages.
;; It wasn’t until the recent introduction of tools for lazy loading
;; that a startup time of less than 20 seconds was even possible.
;; Other fast startup methods were introduced over time.
;; You may have heard of people running Emacs as a server,
;; where you start it once and open multiple clients instantly connected to that server.
;; Some even run Emacs as a systemd or sysV service, starting when the machine boots.
;; While this is a great way of using Emacs, we WON’T be doing that here.
;; I think 0.3 seconds is fast enough to avoid issues that could arise from
;; running Emacs as a server, such as 'What version of Node is my LSP using?'.
;; Again, this setup configures Emacs much like how a Vimmer would configure Neovim.


;; Emacs comes with a built-in package manager (`package.el'), and we'll use it
;; when it makes sense. However, `straight.el' is a bit more user-friendly and
;; reproducible, especially for newcomers and shareable configs like emacs-kick.
;; So we bootstrap it here.
(setq package-enable-at-startup nil) ;; Disables the default package manager.

;; Bootstraps `straight.el'
(setq straight-check-for-modifications nil)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package '(project :type built-in))
(straight-use-package 'use-package)

(use-package general
  :straight t
  :config
  (general-evil-setup)
  (general-create-definer general-nivmap :states '(normal insert visual)))

;; In Emacs, a package is a collection of Elisp code that extends the editor's functionality,
;; much like plugins do in Neovim. We need to import this package to add package archives.
(require 'package)

;; Add MELPA (Milkypostman's Emacs Lisp Package Archive) to the list of package archives.
;; This allows you to install packages from this widely-used repository, similar to how
;; pip works for Python or npm for Node.js. While Emacs comes with ELPA (Emacs Lisp
;; Package Archive) configured by default, which contains packages that meet specific
;; licensing criteria, MELPA offers a broader range of packages and is considered the
;; standard for Emacs users. You can also add more package archives later as needed.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Define a global customizable variable `ek-use-nerd-fonts' to control the use of
;; Nerd Fonts symbols throughout the configuration. This boolean variable allows
;; users to easily enable or disable the use of symbols from Nerd Fonts, providing
;; flexibility in appearance settings. By setting it to `t', we enable Nerd Fonts
;; symbols; setting it to `nil' would disable them.
(defcustom ek-use-nerd-fonts t
  "Configuration for using Nerd Fonts Symbols."
  :type 'boolean
  :group 'appearance)


;; From now on, you'll see configurations using the `use-package` macro, which
;; allows us to organize our Emacs setup in a modular way. These configurations
;; look like this:
;;
;; (use-package some-package
;;   :ensure t     ;; Ensure the package is installed (used with package.el).
;;   :straight t   ;; Use straight.el to install and manage this package.
;;   :config       ;; Configuration settings for the package.
;;   ;; Additional settings can go here.
;; )
;;
;; This approach simplifies package management, enabling us to easily control
;; both built-in (first-party) and external (third-party) packages. While Emacs
;; is a vast and powerful editor, using `use-package`—especially in combination
;; with `straight.el`—helps streamline our configuration for better organization,
;; reproducibility, and customization. As we proceed, you'll see smaller
;; `use-package` declarations for specific packages, which will help us enable
;; the desired features and improve our workflow.

;;; EMACS
;;  This is biggest one. Keep going, plugins (oops, I mean packages) will be shorter :)
(use-package emacs
  :ensure nil
  :custom                                         ;; Set custom variables to configure Emacs behavior.
  (column-number-mode t)                          ;; Display the column number in the mode line.
  (auto-save-default nil)                         ;; Disable automatic saving of buffers.
  (create-lockfiles nil)                          ;; Prevent the creation of lock files when editing.
  (delete-by-moving-to-trash t)                   ;; Move deleted files to the trash instead of permanently deleting them.
  (delete-selection-mode 1)                       ;; Enable replacing selected text with typed text.
  (display-line-numbers-type 'relative)           ;; Use relative line numbering in programming modes.
  (global-auto-revert-non-file-buffers t)         ;; Automatically refresh non-file buffers.
  (history-length 100)                             ;; Set the length of the command history.
  (inhibit-startup-message t)                     ;; Disable the startup message when Emacs launches.
  (initial-scratch-message "")                    ;; Clear the initial message in the *scratch* buffer.
  (ispell-dictionary "en_US")                     ;; Set the default dictionary for spell checking.
  (make-backup-files nil)                         ;; Disable creation of backup files.
  (pixel-scroll-precision-mode t)                 ;; Enable precise pixel scrolling.
  (pixel-scroll-precision-use-momentum nil)       ;; Disable momentum scrolling for pixel precision.
  (ring-bell-function 'ignore)                    ;; Disable the audible bell.
  (split-width-threshold 300)                     ;; Prevent automatic window splitting if the window width exceeds 300 pixels.
  (switch-to-buffer-obey-display-actions t)       ;; Make buffer switching respect display actions.
  (tab-always-indent 'complete)                   ;; Make the TAB key complete text instead of just indenting.
  (tab-width 4)                                   ;; Set the tab width to 4 spaces.
  (treesit-font-lock-level 4)                     ;; Use advanced font locking for Treesit mode.
  (truncate-lines t)                              ;; Enable line truncation to avoid wrapping long lines.
  (use-dialog-box nil)                            ;; Disable dialog boxes in favor of minibuffer prompts.
  (use-short-answers t)                           ;; Use short answers in prompts for quicker responses (y instead of yes)
  ;; (warning-minimum-level :emergency)              ;; Set the minimum level of warnings to display.

  :hook                                           ;; Add hooks to enable specific features in certain modes.
  (prog-mode . display-line-numbers-mode)         ;; Enable line numbers in programming modes.

  :general-config
  ("C-x C-r" 'recentf)
  :config
  ;; By default emacs gives you access to a lot of *special* buffers, while navigating with [b and ]b,
  ;; this might be confusing for newcomers. This settings make sure ]b and [b will always load a
  ;; file buffer. To see all buffers use <leader> SPC, <leader> b l, or <leader> b i.
  (defun skip-these-buffers (_window buffer _bury-or-kill)
    "Function for `switch-to-prev-buffer-skip'."
    (string-match "\\*[^*]+\\*" (buffer-name buffer)))
  (setq switch-to-prev-buffer-skip 'skip-these-buffers)


  ;; Configure font settings based on the operating system.
  ;; Ok, this kickstart is meant to be used on the terminal, not on GUI.
  ;; But without this, I fear you could start Graphical Emacs and be sad 
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font"  :height 100)
  (when (eq system-type 'darwin)       ;; Check if the system is macOS.
    (setq mac-command-modifier 'meta)  ;; Set the Command key to act as the Meta key.
    (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 130))

  ;; Use C-h A to describe-face
  (with-eval-after-load 'help
    (define-key help-map "A" 'describe-face))

  ;; Save manual customizations to a separate file instead of cluttering `init.el'.
  ;; You can M-x customize, M-x customize-group, or M-x customize-themes, etc.
  ;; The saves you do manually using the Emacs interface would overwrite this file.
  ;; The following makes sure those customizations are in a separate file.
  (setq custom-file (locate-user-emacs-file "custom-vars.el")) ;; Specify the custom file path.
  (load custom-file 'noerror 'nomessage)                       ;; Load the custom file quietly, ignoring errors.

  ;; Makes Emacs vertical divisor the symbol │ instead of |.
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

  :init                        ;; Initialization settings that apply before the package is loaded.
  (tool-bar-mode -1)           ;; Disable the tool bar for a cleaner interface.
  (menu-bar-mode -1)           ;; Disable the menu bar for a more streamlined look.

  (when scroll-bar-mode
    (scroll-bar-mode -1))      ;; Disable the scroll bar if it is active.

  (global-hl-line-mode 1)      ;; Enable highlight of the current line
  (global-auto-revert-mode 1)  ;; Enable global auto-revert mode to keep buffers up to date with their corresponding files.
  (indent-tabs-mode -1)        ;; Disable the use of tabs for indentation (use spaces instead).
  (recentf-mode 1)             ;; Enable tracking of recently opened files.
  (savehist-mode 1)            ;; Enable saving of command history.
  (save-place-mode 1)          ;; Enable saving the place in files for easier return.
  (winner-mode 1)              ;; Enable winner mode to easily undo window configuration changes.
  (xterm-mouse-mode 1)         ;; Enable mouse support in terminal mode.
  (file-name-shadow-mode 1)    ;; Enable shadowing of filenames for clarity.

  ;; Set the default coding system for files to UTF-8.
  (modify-coding-system-alist 'file "" 'utf-8)

  ;; Add a hook to run code after Emacs has fully initialized.
  (add-hook 'after-init-hook
            (lambda ()
              (message "Emacs has fully loaded. This code runs after startup.")

              ;; Insert a welcome message in the *scratch* buffer displaying loading time and activated packages.
              (with-current-buffer (get-buffer-create "*scratch*")
                (insert (format
                         ";;    Welcome to Emacs!
;;
;;    Loading time : %s
;;    Packages     : %s
"
                         (emacs-init-time)
                         (number-to-string (length package-activated-list))))))))


;;; WINDOW
;; This section configures window management in Emacs, enhancing the way buffers
;; are displayed for a more efficient workflow. The `window' use-package helps
;; streamline how various buffers are shown, especially those related to help,
;; diagnostics, and completion.
;;
;; Note: I have left some commented-out code below that may facilitate your
;; Emacs journey later on. These configurations can be useful for displaying
;; other types of buffers in side windows, allowing for a more organized workspace.
(use-package window
  :ensure nil       ;; This is built-in, no need to fetch it.
  :custom
  (display-buffer-alist
   '(
     ;; ("\\*.*e?shell\\*"
     ;;  (display-buffer-in-side-window)
     ;;  (window-height . 0.25)
     ;;  (side . bottom)
     ;;  (slot . -1))

     ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|[Hh]elp\\|Messages\\|Bookmark List\\|Ibuffer\\|Occur\\|eldoc.*\\)\\*"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . 0))

     ;; Example configuration for the LSP help buffer,
     ;; keeps it always on bottom using 25% of the available space:
     ("\\*\\(lsp-help\\)\\*"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . 0))

     ;; Configuration for displaying various diagnostic buffers on
     ;; bottom 25%:
     ("\\*\\(Flymake diagnostics\\|xref\\|ivy\\|Swiper\\|Completions\\)"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . 1))
     )))


;;; DIRED
;; In Emacs, the `dired' package provides a powerful and built-in file manager
;; that allows you to navigate and manipulate files and directories directly
;; within the editor. If you're familiar with `oil.nvim', you'll find that
;; `dired' offers similar functionality natively in Emacs, making file
;; management seamless without needing external plugins.

;; This configuration customizes `dired' to enhance its usability. The settings
;; below specify how file listings are displayed, the target for file operations,
;; and associations for opening various file types with their respective applications.
;; For example, image files will open with `feh', while audio and video files
;; will utilize `mpv'.
(use-package dired
  :ensure nil                                                ;; This is built-in, no need to fetch it.
  :custom
  (dired-listing-switches "-lah --group-directories-first")  ;; Display files in a human-readable format and group directories first.
  (dired-dwim-target t)                                      ;; Enable "do what I mean" for target directories.
  (dired-guess-shell-alist-user
   '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open" "open") ;; Open image files with `feh' or the default viewer.
     ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open" "open") ;; Open audio and video files with `mpv'.
     (".*" "open" "xdg-open")))                              ;; Default opening command for other files.
  (dired-kill-when-opening-new-dired-buffer t)               ;; Close the previous buffer when opening a new `dired' instance.
  :config
  (when (eq system-type 'darwin)
    (let ((gls (executable-find "gls")))                     ;; Use GNU ls on macOS if available.
      (when gls
        (setq insert-directory-program gls)))))


(use-package desktop
  :ensure nil
  :custom
  (desktop-path (list user-emacs-directory))
  (desktop-auto-save-timeout 600)
  :config
  (desktop-save-mode 1))

(use-package repeat
  :ensure nil
  :config
  (repeat-mode 1))

(defun ap/define-holiday (month day year &optional name)
  (list (list month day year) (or name "")))

(defcustom ap/tamu-holidays
  (list (ap/define-holiday 10 13 2025 "Fall Break")
        (ap/define-holiday 10 14 2025 "Fall Break")
        (ap/define-holiday 3 9 2025 "Spring Break")
        (ap/define-holiday 3 9 2026 "Spring Break")
        (ap/define-holiday 3 10 2026 "Spring Break")
        (ap/define-holiday 3 11 2026 "Spring Break")
        (ap/define-holiday 3 12 2026 "Spring Break"))
  "List of days Texas A&M has no classes.")

(defun calendar-in-range-p (d1 d2 x)
  "Is date X between the dates D1 and D2?"
  (and (calendar-date-compare (list d1) x) (null (calendar-date-compare (list d2) x))))

(defun ap/filter-holidays (holidays)
  (let ((m1 displayed-month)
        (m2 displayed-month)
        (y1 displayed-year)
        (y2 displayed-year))
    (calendar-increment-month m1 y1 -1)
    (calendar-increment-month m2 y2 1)
    (let ((d1 (list m1 1 y1)) (d2 (list m2 (calendar-last-day-of-month m2 y2) y2)))
      (cl-remove-if 'null (mapcar (lambda (x)
                                    (if (calendar-in-range-p d1 d2 x)
                                        x
                                      nil)
                                    )
                                  holidays)))))
(use-package holidays
  :ensure nil
  :init
  ;; Disable unused holidays:
  (setq
   holiday-hebrew-holidays nil
   holiday-bahai-holidays nil
   holiday-islamic-holidays nil
   holiday-oriental-holidays nil)
  ;; Attach our custom holiday lists:
  (setq holiday-other-holidays
        '((holiday-float 11 4 3 "Thanksgiving Break")
          (holiday-float 11 4 5 "Thanksgiving Break")
          (ap/filter-holidays ap/tamu-holidays)
          (ap/filter-holidays ap/daycare-closed)))
  ;; This gets overwritten somehow:
  (setq calendar-holidays (append holiday-general-holidays holiday-local-holidays
                                  holiday-other-holidays holiday-christian-holidays
                                  holiday-hebrew-holidays holiday-islamic-holidays
                                  holiday-bahai-holidays holiday-oriental-holidays
                                  holiday-solar-holidays))
  :config
  (with-eval-after-load 'org
    (setq org-agenda-include-diary t)))

;;; ISEARCH
;; In this configuration, we're setting up isearch, Emacs's incremental search feature.
;; Since we're utilizing Vim bindings, keep in mind that classic Vim search commands
;; (like `/' and `?') are not bound in the same way. Instead, you'll need to use
;; the standard Emacs shortcuts:
;; - `C-s' to initiate a forward search
;; - `C-r' to initiate a backward search
;; The following settings enhance the isearch experience:
(use-package isearch
  :ensure nil                                  ;; This is built-in, no need to fetch it.
  :config
  (setq isearch-lazy-count t)                  ;; Enable lazy counting to show current match information.
  (setq lazy-count-prefix-format "(%s/%s) ")   ;; Format for displaying current match count.
  (setq lazy-count-suffix-format nil)          ;; Disable suffix formatting for match count.
  (setq search-whitespace-regexp ".*?")        ;; Allow searching across whitespace.
  :bind (("C-s" . isearch-forward)             ;; Bind C-s to forward isearch.
         ("C-r" . isearch-backward)))          ;; Bind C-r to backward isearch.


;;; VC
;; The VC (Version Control) package is included here for awareness and completeness.
;; While its support for Git is limited and generally considered subpar, it is good to know
;; that it exists and can be used for other version control systems like Mercurial,
;; Subversion, and Bazaar.
;; Magit, which is often regarded as the "father" of Neogit, will be configured later
;; for an enhanced Git experience.
;; The keybindings below serve as a reminder of some common VC commands.
;; But don't worry, you can always use `M-x command' :)
(use-package vc
  :ensure nil                        ;; This is built-in, no need to fetch it.
  :defer t
  :bind
  (("C-x v d" . vc-dir)              ;; Open VC directory for version control status.
   ("C-x v =" . vc-diff)             ;; Show differences for the current file.
   ("C-x v D" . vc-root-diff)        ;; Show differences for the entire repository.
   ("C-x v v" . vc-next-action))     ;; Perform the next version control action.
  :config
  ;; Better colors for <leader> g b  (blame file)
  (setq vc-annotate-color-map
        '((20 . "#f5e0dc")
          (40 . "#f2cdcd")
          (60 . "#f5c2e7")
          (80 . "#cba6f7")
          (100 . "#f38ba8")
          (120 . "#eba0ac")
          (140 . "#fab387")
          (160 . "#f9e2af")
          (180 . "#a6e3a1")
          (200 . "#94e2d5")
          (220 . "#89dceb")
          (240 . "#74c7ec")
          (260 . "#89b4fa")
          (280 . "#b4befe"))))


;;; SMERGE
;; Smerge is included for resolving merge conflicts in files. It provides a simple interface
;; to help you keep changes from either the upper or lower version during a merge.
;; This package is built-in, so there's no need to fetch it separately.
;; The keybindings below did not needed to be setted, are here just to show
;; you how to work with it in case you are curious about it.
(use-package smerge-mode
  :ensure nil                                  ;; This is built-in, no need to fetch it.
  :defer t
  :bind (:map smerge-mode-map
              ("C-c ^ u" . smerge-keep-upper)  ;; Keep the changes from the upper version.
              ("C-c ^ l" . smerge-keep-lower)  ;; Keep the changes from the lower version.
              ("C-c ^ n" . smerge-next)        ;; Move to the next conflict.
              ("C-c ^ p" . smerge-previous)))  ;; Move to the previous conflict.


;;; ELDOC
;; Eldoc provides helpful inline documentation for functions and variables
;; in the minibuffer, enhancing the development experience. It can be particularly useful
;; in programming modes, as it helps you understand the context of functions as you type.
;; This package is built-in, so there's no need to fetch it separately.
;; The following line enables Eldoc globally for all buffers.
(use-package eldoc
  :ensure nil          ;; This is built-in, no need to fetch it.
  :init
  (global-eldoc-mode))


;;; FLYMAKE
;; Flymake is an on-the-fly syntax checking extension that provides real-time feedback
;; about errors and warnings in your code as you write. This can greatly enhance your
;; coding experience by catching issues early. The configuration below activates
;; Flymake mode in programming buffers.
(use-package flymake
  :ensure nil          ;; This is built-in, no need to fetch it.
  :defer t
  :hook (prog-mode . flymake-mode)
  :custom
  (flymake-margin-indicators-string
   '((error "!»" compilation-error) (warning "»" compilation-warning)
     (note "»" compilation-info))))


;;; WHICH-KEY
;; `which-key' is an Emacs package that displays available keybindings in a
;; popup window whenever you partially type a key sequence. This is particularly
;; useful for discovering commands and shortcuts, making it easier to learn
;; Emacs and improve your workflow. It helps users remember key combinations
;; and reduces the cognitive load of memorizing every command.
(use-package which-key
  :ensure nil     ;; This is built-in, no need to fetch it.
  :defer t        ;; Defer loading Which-Key until after init.
  :hook
  (after-init . which-key-mode)) ;; Enable which-key mode after initialization.


;;; ==================== EXTERNAL PACKAGES ====================
;;
;; From this point onward, all configurations will be for third-party packages
;; that enhance Emacs' functionality and extend its capabilities.

(use-package hydra
  :straight t)

;;; VERTICO
;; Vertico enhances the completion experience in Emacs by providing a
;; vertical selection interface for both buffer and minibuffer completions.
;; Unlike traditional minibuffer completion, which displays candidates
;; in a horizontal format, Vertico presents candidates in a vertical list,
;; making it easier to browse and select from multiple options.
;;
;; In buffer completion, `switch-to-buffer' allows you to select from open buffers.
;; Vertico streamlines this process by displaying the buffer list in a way that
;; improves visibility and accessibility. This is particularly useful when you
;; have many buffers open, allowing you to quickly find the one you need.
;;
;; In minibuffer completion, such as when entering commands or file paths,
;; Vertico helps by showing a dynamic list of potential completions, making
;; it easier to choose the correct one without typing out the entire string.
(use-package vertico
  :ensure t
  :straight t
  :hook
  (after-init . vertico-mode)           ;; Enable vertico after Emacs has initialized.
  (minibuffer-setup . vertico-repeat-save)
  :custom
  (vertico-count 10)                    ;; Number of candidates to display in the completion list.
  (vertico-resize nil)                  ;; Disable resizing of the vertico minibuffer.
  (vertico-cycle nil)                   ;; Do not cycle through candidates when reaching the end of the list.
  :general-config
   ("M-R" #'vertico-repeat)
  (:keymaps 'vertico-map
			"M-q" #'vertico-quick-insert
			"C-q" #'vertico-quick-exit
			"M-P" #'vertico-repeat-previous
			"M-N" #'vertico-repeat-next)
  :config
  ;; Customize the display of the current candidate in the completion list.
  ;; This will prefix the current candidate with “» ” to make it stand out.
  ;; Reference: https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face '(:foreground "#80adf0" :weight bold))
                   "  ")
                 cand))))


;;; ORDERLESS
;; Orderless enhances completion in Emacs by allowing flexible pattern matching.
;; It works seamlessly with Vertico, enabling you to use partial strings and
;; regular expressions to find files, buffers, and commands more efficiently.
;; This combination provides a powerful and customizable completion experience.
(use-package orderless
  :ensure t
  :straight t
  :defer t                                    ;; Load Orderless on demand.
  :after vertico                              ;; Ensure Vertico is loaded before Orderless.
  :init
  (setq completion-styles '(orderless basic)  ;; Set the completion styles.
        completion-category-defaults nil      ;; Clear default category settings.
        completion-category-overrides '((file (styles partial-completion))))) ;; Customize file completion styles.


;;; MARGINALIA
;; Marginalia enhances the completion experience in Emacs by adding
;; additional context to the completion candidates. This includes
;; helpful annotations such as documentation and other relevant
;; information, making it easier to choose the right option.
(use-package marginalia
  :ensure t
  :straight t
  :hook
  (after-init . marginalia-mode))


;;; CONSULT
;; Consult provides powerful completion and narrowing commands for Emacs.
;; It integrates well with other completion frameworks like Vertico, enabling
;; features like previews and enhanced register management. It's useful for
;; navigating buffers, files, and xrefs with ease.
(use-package consult
  :ensure t
  :straight t
  :defer t
  :custom
  (consult-narrow-key "<")
  (consult-widen-key ">")
  :general-config
  ([remap switch-to-buffer]  'ap/project-buffers
   [remap switch-to-buffer-other-window]  'consult-buffer-other-window
   [remap switch-to-buffer-other-frame]  'consult-buffer-other-frame
   [remap goto-line]  'consult-goto-line
   [remap imenu]  'consult-imenu
   [remap browse-kill-ring]  'consult-yank-from-kill-ring
   [remap recentf]  'consult-recent-file
   "<leader> A"  'consult-org-agenda
   "<leader> B"  'consult-buffer)

  :init
  ;; Enhance register preview with thin lines and no mode line.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult for xref locations with a preview feature.
  (setq xref-show-xrefs-function #'consult-xref
		xref-show-definitions-function #'consult-xref)

  (defun ap/project-buffers (&optional sources)
	"Display buffers using  `consult-buffer', narrowed to only project files.

Pass SOURCES to consult-buffer, if provided."
    (interactive)
    (setq unread-command-events (append unread-command-events (list ?p 32)))
    (consult-buffer sources)))


;;; EMBARK
;; Embark provides a powerful contextual action menu for Emacs, allowing
;; you to perform various operations on completion candidates and other items.
;; It extends the capabilities of completion frameworks by offering direct
;; actions on the candidates.
;; Just `<leader> .' over any text, explore it :)
(use-package embark
  :straight t
  :general-config
  ("C-;" 'embark-act)
  (:keymaps 'vertico-map
			"C-c C-o" 'embark-collect
			"C-c C-e" 'embark-export
			"C-c C-c" 'embark-act)
  (:keymaps 'minibuffer-mode-map
			"C-c C-o" 'embark-collect
			"C-c C-e" 'embark-export)
  (:keymaps 'embark-general-map
			"/" 'consult-ripgrep)
  :config
  ;; Use embark for completion help
  (with-eval-after-load 'which-key
	(setq prefix-help-command #'embark-prefix-help-command)))
  

;;; EMBARK-CONSULT
;; Embark-Consult provides a bridge between Embark and Consult, ensuring
;; that Consult commands, like previews, are available when using Embark.
(use-package embark-consult
  :ensure t
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)) ;; Enable preview in Embark collect mode.


;;; TREESITTER-AUTO
;; Treesit-auto simplifies the use of Tree-sitter grammars in Emacs,
;; providing automatic installation and mode association for various
;; programming languages. This enhances syntax highlighting and
;; code parsing capabilities, making it easier to work with modern
;; programming languages.
(use-package treesit-auto
  :ensure t
  :straight t
  :after emacs
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

(use-package corfu
  :straight t
  :init
  (setq completion-cycle-threshold 4)
  (setq completion-auto-select 'second-tab)
  :hook (after-init . global-corfu-mode)
  :general-config
  ("C-x C-o" 'completion-at-point)
  (:keymaps 'corfu-map
			"C-c" 'corfu-quit
			"C-g" 'corfu-quit
			"Tab" 'corfu-insert
			"C-y" 'corfu-insert
			"M-t" 'corfu-popupinfo-toggle
			"M-n" 'corfu-popupinfo-scroll-down
			"M-p" 'corfu-popupinfo-scroll-up
			"M-q" #'corfu-quick-complete
			"C-q" #'corfu-quick-insert)
  :custom
  (corfu-auto nil)
  (corfu-quit-no-match 'separator)
  :config
  (corfu-popupinfo-mode)

  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer."
    (when (local-variable-p 'completion-at-point-functions)
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer)

  (defun corfu-move-to-minibuffer ()
    (interactive)
    (pcase completion-in-region--data
      (`(,beg ,end ,table ,pred ,extras)
       (let ((completion-extra-properties extras)
             completion-cycle-threshold completion-cycling)
         (consult-completion-in-region beg end table pred)))))
  (keymap-set corfu-map "M-m" #'corfu-move-to-minibuffer)
  (add-to-list 'corfu-continue-commands #'corfu-move-to-minibuffer)

  (require 'corfu-quick))

(use-package cape
  :straight t
  :commands (cape-keyword cape-dabbrev)
  :general
  (general-imap
    "C-x C-f" #'cape-file
    "C-x C-k" #'cape-dict)
  :hook ((markdown-mode org-mode) .
         (lambda ()
           (setq-local completion-at-point-functions (list #'cape-dict #'cape-keyword #'cape-dabbrev)
                       completion-styles '(basic)))))

(use-package completion-preview
  :ensure nil
  :diminish completion-preview-mode
  :hook (((prog-mode org-mode markdown-mode) . completion-preview-mode)
         (org-mode . (lambda ()
                       (electric-indent-local-mode -1)
                       ;; need to overwrite `completion-preview-commands' to trigger
                       ;; completion-preview
                       (setq-local completion-preview-commands
                                   '(;; self-insert-command
                                     evil-delete-backward-char-and-join
                                     org-self-insert-command
                                     insert-char
                                     delete-backward-char
                                     org-delete-backward-char
                                     backward-delete-char-untabify
                                     analyze-text-conversion
                                     completion-preview-complete)))))
  :general-config
  (:keymaps 'completion-preview-active-mode-map
            "M-n" 'completion-preview-next-candidate
            "M-p" 'completion-preview-prev-candidate))


;;; Diff-HL
;; The `diff-hl' package provides visual indicators for version control changes
;; directly in the margin of the buffer, showing lines added, deleted, or changed.
;; This is useful for tracking modifications while you edit files. When enabled,
;; it automatically activates in every buffer that has a corresponding version
;; control backend, offering a seamless experience.
;;
;; In comparison, Neovim users often rely on plugins like `gitsigns.nvim' or
;; `vim-signify', which provide similar functionalities by displaying Git
;; changes in the gutter and offer additional features like highlighting
;; changed lines and displaying blame information. `diff-hl' aims to provide
;; a comparable experience in Emacs with its own set of customizations.
(use-package diff-hl
  :defer t
  :straight t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)           ;; Enable Diff-HL mode for all files.
                 (diff-hl-flydiff-mode)          ;; Automatically refresh diffs.
                 (diff-hl-margin-mode)))         ;; Show diff indicators in the margin.
  :custom
  (diff-hl-side 'left)                           ;; Set the side for diff indicators.
  (diff-hl-margin-symbols-alist '((insert . "│") ;; Customize symbols for each change type.
                                  (delete . "-")
                                  (change . "│")
                                  (unknown . "?")
                                  (ignored . "i"))))


;;; Magit
;; `magit' is a powerful Git interface for Emacs that provides a complete
;; set of features to manage Git repositories. With its intuitive interface,
;; you can easily stage, commit, branch, merge, and perform other Git
;; operations directly from Emacs. Magit’s powerful UI allows for a seamless
;; workflow, enabling you to visualize your repository's history and manage
;; changes efficiently.
;;
;; In the Neovim ecosystem, similar functionality is provided by plugins such as
;; `fugitive.vim', which offers a robust Git integration with commands that
;; allow you to perform Git operations directly within Neovim. Another popular
;; option is `neogit', which provides a more modern and user-friendly interface
;; for Git commands in Neovim, leveraging features like diff views and staging
;; changes in a visual format. Both of these plugins aim to replicate and
;; extend the powerful capabilities that Magit offers in Emacs.
(use-package magit
  :ensure t
  :straight t
  :defer t)


;;; XCLIP
;; `xclip' is an Emacs package that integrates the X Window System clipboard
;; with Emacs. It allows seamless copying and pasting between Emacs and other
;; applications using the clipboard. When `xclip' is enabled, any text copied
;; in Emacs can be pasted in other applications, and vice versa, providing a
;; smooth workflow when working across multiple environments.
(use-package xclip
  :ensure t
  :straight t
  :defer t
  :hook
  (after-init . xclip-mode))     ;; Enable xclip mode after initialization.


;; EVIL
;; The `evil' package provides Vim emulation within Emacs, allowing
;; users to edit text in a modal way, similar to how Vim
;; operates. This setup configures `evil-mode' to enhance the editing
;; experience.
(use-package evil
  :ensure t
  :straight t
  :hook ((org-mode . evil-visual-state)
	 (markdown-mode . evil-visual-state)
	 (visual-line-mode . evil-visual-state))
  :init
  (setq
   evil-undo-system 'undo-fu
   evil-want-fine-undo t
   evil-want-Y-yank-to-eol t
   evil-want-integration t      ;; Integrate `evil' with other Emacs features (optional as it's true by default).
   evil-want-keybinding nil     ;; Disable default keybinding to set custom ones.
   evil-want-C-u-scroll t       ;; Makes C-u scroll
   evil-want-C-u-delete t)       ;; Makes C-u delete on insert mode
  :general-config
  (general-nivmap
    "C-n" 'evil-next-line
    "C-p" 'evil-previous-line)
  (general-imap
    "C-e" 'move-end-of-line
    "C-a" 'move-beginning-of-line)
  (general-imap
    "C-y" 'yank
    "M-y" 'yank-pop)
  (general-imap :keymaps 'org-mode-map
    "C-y" 'org-yank)
  (general-imap
    "C-t" nil ;; unbind C-t for indentation
    "C->" 'evil-shift-right-line
    "C-<" 'evil-shift-left-line
    "C-d" 'delete-char)
  (general-vmap :keymaps 'emacs-lisp-mode-map
    "gx" 'eval-region)
  (general-nmap :keymaps 'emacs-lisp-mode-map
    "gx" 'evil-eval-region)
  ;; Universal argument support:
  (general-nmap
    "<leader> u" 'universal-argument)
  (:keymaps 'universal-argument-map
	    "<leader> u" 'universal-argument-more
	    "C-u" 'universal-argument-more)
  (general-nivmap
    "<leader> s f" 'consult-find
    "<leader> s g" 'consult-grep
    "<leader> s G" 'consult-git-grep
    "<leader> s r" 'consult-ripgrep
    "<leader> s h" 'consult-info
    "<leader> /" 'consult-line
    
    ;; Flymake navigation
    "<leader> x x" 'consult-flymake;; Gives you something like `trouble.nvim'

    ;; Dired commands for file management
    "<leader> x d" 'dired
    "<leader> x j" 'dired-jump
    "<leader> x f" 'find-file

    ;; NeoTree command for file exploration
    "<leader> e d" 'dired-jump

    ;; Magit keybindings for Git integration
    "<leader> v g" 'magit-status      ;; Open Magit status
    "<leader> v l" 'magit-log-current ;; Show current log
    "<leader> v d" 'magit-diff-buffer-file ;; Show diff for the current file
    "<leader> v D" 'diff-hl-show-hunk ;; Show diff for a hunk
    "<leader> v b" 'vc-annotate       ;; Annotate buffer with version control info

    "<leader> b i" 'consult-buffer ;; Open consult buffer list
    "<leader> b b" 'ibuffer ;; Open Ibuffer
    "<leader> b d" 'kill-current-buffer ;; Kill current buffer
    "<leader> b k" 'kill-current-buffer ;; Kill current buffer
    "<leader> b x" 'kill-current-buffer ;; Kill current buffer
    "<leader> b s" 'save-buffer ;; Save buffer
    "<leader> b l" 'consult-buffer ;; Consult buffer
    "<leader>SPC" 'consult-buffer ;; Consult buffer

    ;; Project management keybindings
    "<leader> p b" 'consult-project-buffer ;; Consult project buffer
    "<leader> p p" 'project-switch-project ;; Switch project
    "<leader> p f" 'project-find-file ;; Find file in project
    "<leader> p g" 'project-find-regexp ;; Find regexp in project
    "<leader> p k" 'project-kill-buffers ;; Kill project buffers
    "<leader> p D" 'project-dired ;; Dired for project

    ;; Yank from kill ring
    "<leader> P" 'consult-yank-from-kill-ring

    ;; Help keybindings
    "<leader> h m" 'describe-mode ;; Describe current mode
    "<leader> h f" 'describe-function ;; Describe function
    "<leader> h v" 'describe-variable ;; Describe variable
    "<leader> h k" 'describe-key ;; Describe key

    ;; Custom example. Formatting with prettier tool.
    "<leader> m p"
    (lambda ()
      (interactive)
      (shell-command (concat "prettier --write " (shell-quote-argument (buffer-file-name))))
      (revert-buffer t t t)))
  (general-nmap
    ;; Tab navigation
    "] t" 'tab-next ;; Go to next tab
    "[ t" 'tab-previous ;; Go to previous tab
    ;; Buffer management keybindings
    "] b" 'switch-to-next-buffer ;; Switch to next buffer
    "[ b" 'switch-to-prev-buffer ;; Switch to previous buffer
    "] d" 'flymake-goto-next-error ;; Go to next Flymake error
    "[ d" 'flymake-goto-prev-error ;; Go to previous Flymake error
    ;; Diff-HL navigation for version control
    "] c" 'diff-hl-next-hunk ;; Next diff hunk
    "[ c" 'diff-hl-previous-hunk) ;; Previous diff hunk

  :config
  ;; Set the leader key to space for easier access to custom commands. (setq evil-want-leader t)
  ;; (evil-set-leader nil (kbd "C-c l") t)
  (evil-set-leader nil (kbd "C-c"))

  (define-advice forward-evil-paragraph (:around (orig-fun &rest args))
    (let ((paragraph-start (default-value 'paragraph-start))
          (paragraph-separate (default-value 'paragraph-separate))
          (paragraph-ignore-fill-prefix t))
      (apply orig-fun args)))

  (evil-define-operator evil-eval-region (beg end)
    "evaluate the region."
    (eval-region beg end))

  (evil-define-text-object +evil:whole-buffer-txtobj (count &optional _beg _end type)
    "Text object to select the whole buffer."
    (evil-range (point-min) (point-max) type))

  (general-define-key :keymaps 'evil-inner-text-objects-map
		      "g" '+evil:whole-buffer-txtobj
		      :keymaps 'evil-outer-text-objects-map
		      "g" '+evil:whole-buffer-txtobj)

  (defvar-keymap evil-window-repeat-map
    :repeat t
    "+" 'evil-window-increase-height
    "-" 'evil-window-decrease-height
    ">" 'evil-window-increase-width
    "<" 'evil-window-decrease-width
    "=" 'balance-windows)


  ;; Enable evil mode
  (evil-mode 1))


;; EVIL COLLECTION
;; The `evil-collection' package enhances the integration of
;; `evil-mode' with various built-in and third-party packages. It
;; provides a better modal experience by remapping keybindings and
;; commands to fit the `evil' style.
(use-package evil-collection
  :defer t
  :straight t
  :ensure t
  :custom
  (evil-collection-want-find-usages-bindings nil)
  ;; Hook to initialize `evil-collection' when `evil-mode' is activated.
  :hook
  (evil-mode . evil-collection-init))


;; EVIL SURROUND
;; The `evil-surround' package provides text object surround
;; functionality for `evil-mode'. This allows for easily adding,
;; changing, or deleting surrounding characters such as parentheses,
;; quotes, and more.
;;
;; With this you can change 'hello there' with ci'" to have
;; "hello there" and cs"<p> to get <p>hello there</p>.
;; More examples here:
;; - https://github.com/emacs-evil/evil-surround?tab=readme-ov-file#examples
(use-package evil-surround
  :ensure t
  :straight t
  :after evil-collection
  :config
  (global-evil-surround-mode 1))

(use-package embrace
  :straight t
  :hook (org-mode . embrace-org-mode-hook)
  :general
  ("C-," 'embrace-commander))

(use-package evil-embrace
  :straight t
  :after evil-surround
  :config
  (evil-embrace-enable-evil-surround-integration))

(use-package evil-nerd-commenter
  :straight t
  :general
  ([remap comment-line] #'evilnc-comment-or-uncomment-lines)
  (general-nvmap "gc" #'evilnc-comment-operator)
  (:keymaps 'evil-inner-text-objects-map
            "c" 'evilnc-inner-comment)
  (:keymaps 'evil-outer-text-objects-map
            "c" 'evilnc-outer-comment))

(use-package evil-numbers
  :straight t
  :general
  ("<leader> C-+" 'evil-numbers/inc-at-pt
   "<leader> C-=" 'evil-numbers/inc-at-pt
   "<leader> C--" 'evil-numbers/dec-at-pt)
  :config
  (defvar-keymap evil-numbers-repeat-map
    :repeat t
    "+" 'evil-numbers/inc-at-pt
    "=" 'evil-numbers/inc-at-pt
    "C-=" 'evil-numbers/inc-at-pt-incremental
    "C-+" 'evil-numbers/inc-at-pt-incremental
    "C--" 'evil-numbers/dec-at-pt-incremental
    "-" 'evil-numbers/dec-at-pt))

;; EVIL MATCHIT
;; The `evil-matchit' package extends `evil-mode' by enabling
;; text object matching for structures such as parentheses, HTML
;; tags, and other paired delimiters. This makes it easier to
;; navigate and manipulate code blocks.
;; Just use % for jumping between matching structures to check it out.
(use-package evil-matchit
  :ensure t
  :straight t
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

(use-package targets
  :straight (targets :type git :host github :repo "noctuid/targets.el")
  :config
  (targets-setup t)
  (targets-define-composite-to anyblock
    (("(" ")" pair)
     ("[" "]" pair)
     ("{" "}" pair)
     ("<" ">" pair)
     ("\"" "\"" quote)
     ("'" "'" quote)
     ("`" "`" quote)
     ("“" "”" quote))
    :bind t
    :keys "b")
  (targets-define-composite-to anyquote
    (("'" "'" quote)
     ("\"" "\"" quote)
     ("`" "`" quote)
     ("‘" "’" quote)
     ("“" "”" quote))
    :bind t
    :keys "q"))

(use-package evil-better-visual-line
  :straight t
  :general
  (general-nvmap
    "<down>" 'evil-better-visual-line-next-line
    "<up>" 'evil-better-visual-line-previous-line)
  :config
  (evil-better-visual-line-on))

(use-package evil-goggles
  :straight t
  :diminish evil-goggles-mode
  :config
  (setq evil-goggles-pulse nil)
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

;; Override evil-replace-register with a function that uses evil-paste and override evil-paste-pop to allow
;; evil-replace-with-register to count as a paste command.
(use-package evil-replace-with-register
  :straight t
  :custom
  (evil-replace-with-register-key (kbd "gr"))
  :config

  (evil-define-operator evil-replace-with-register (count beg end type register)
    "Replacing an existing text with the contents of a register"
    :move-point nil
    (interactive "<vc><R><x>")
    (setq count (or count 1))
    (goto-char beg)
    (if (eq type 'block)
        (evil-apply-on-block
         (lambda (begcol endcol)
           (let ((maxcol (evil-column (line-end-position))))
             (when (< begcol maxcol)
               (setq endcol (min endcol maxcol))
               (let ((beg (evil-move-to-column begcol nil t))
                     (end (evil-move-to-column endcol nil t)))
                 (delete-region beg end)
                 (evil-visual-paste count register))
               (setq last-command 'evil-visual-paste))))
         beg end t)
      (delete-region beg end)
      (evil-paste-before count register)
      (setq last-command 'evil-paste-before)
      (when (and evil-replace-with-register-indent (/= (line-number-at-pos beg) (line-number-at-pos)))
        ;; indent if more then one line was inserted
        (save-excursion
          (evil-indent beg (point))))))

  (advice-add 'evil-paste-pop :override
                (lambda (count)
                  "Replace the just-yanked stretch of killed text with a different stretch.
  This command is allowed only immediatly after a `yank',
  `evil-paste-before', `evil-paste-after' or `evil-paste-pop'.
  This command uses the same paste command as before, i.e., when
  used after `evil-paste-after' the new text is also yanked using
  `evil-paste-after', used with the same paste-count argument.

  The COUNT argument inserts the COUNTth previous kill.  If COUNT
  is negative this is a more recent kill."
                  (interactive "p")
                  (unless (memq last-command
                                '(evil-paste-after
                                  evil-paste-before
                                  evil-visual-paste
                                  evil-replace-with-register))
                    (user-error "Previous command was not an evil-paste: %s" last-command))
                  (unless evil-last-paste
                    (user-error "Previous paste command used a register"))
                  (when (not (eq last-command 'evil-replace-with-register))
                    (evil-undo-pop))
                  (goto-char (nth 2 evil-last-paste))
                  (setq this-command (nth 0 evil-last-paste))
                  ;; use temporary kill-ring, so the paste cannot modify it
                  (let ((kill-ring (list (current-kill
                                          (if (and (> count 0) (nth 5 evil-last-paste))
                                              ;; if was visual paste then skip the
                                              ;; text that has been replaced
                                              (1+ count)
                                            count))))
                        (kill-ring-yank-pointer kill-ring))
                    (when (eq last-command 'evil-visual-paste)
                      (let ((evil-no-display t))
                        (evil-visual-restore)))
                    (funcall (nth 0 evil-last-paste) (nth 1 evil-last-paste))
                    ;; if this was a visual paste, then mark the last paste as NOT
                    ;; being the first visual paste
                    (when (eq last-command 'evil-visual-paste)
                      (setcdr (nthcdr 4 evil-last-paste) nil)))))

  (evil-define-key '(visual normal) 'global evil-replace-with-register-key 'evil-replace-with-register))

(use-package undo-fu
  :straight t
  :hook (after-init . undo-fu-mode)
  :custom
  ;; Increase undo history limits to reduce likelihood of data loss
  (undo-limit 400000)           ; 400kb (default is 160kb)
  (undo-strong-limit 3000000)   ; 3mb   (default is 240kb)
  (undo-outer-limit 48000000)  ; 48mb  (default is 24mb)
  :config
  (define-minor-mode undo-fu-mode
    "Enables `undo-fu' for the current session."
    :keymap (let ((map (make-sparse-keymap)))
              (define-key map [remap undo] #'undo-fu-only-undo)
              (define-key map [remap redo] #'undo-fu-only-redo)
              (define-key map (kbd "C-_")     #'undo-fu-only-undo)
              (define-key map (kbd "M-_")     #'undo-fu-only-redo)
              (define-key map (kbd "C-M-_")   #'undo-fu-only-redo-all)
              (define-key map (kbd "C-x r u") #'undo-fu-session-save)
              (define-key map (kbd "C-x r U") #'undo-fu-session-recover)
              map)
    :init-value nil
    :global t))

(use-package undo-fu-session
  :straight t
  :hook (undo-fu-mode  . undo-fu-session-global-mode)
  :custom
  (undo-fu-session-directory (concat user-emacs-directory "undo-fu-session/"))
  (undo-fu-session-incompatible-files '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (when (executable-find "zstd")
    ;; There are other algorithms available, but zstd is the fastest, and speed
    ;; is our priority within Emacs
    (setq undo-fu-session-compression 'zst)))

(use-package better-jumper
  :straight t
  :diminish (better-jumper-mode better-jumper-local-mode)
  :general-config
  (:states 'motion
           "C-o" 'better-jumper-jump-backward
           "C-i" 'better-jumper-jump-forward)
  :config
  (better-jumper-mode +1))


;;; RAINBOW DELIMITERS
;; The `rainbow-delimiters' package provides colorful parentheses, brackets, and braces
;; to enhance readability in programming modes. Each level of nested delimiter is assigned
;; a different color, making it easier to match pairs visually.
(use-package rainbow-delimiters
  :defer t
  :straight t
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))


;;; DOOM MODELINE
;; The `doom-modeline' package provides a sleek, modern mode-line that is visually appealing
;; and functional. It integrates well with various Emacs features, enhancing the overall user
;; experience by displaying relevant information in a compact format.
(use-package doom-modeline
  :ensure t
  :straight t
  :defer t
  :custom
  (doom-modeline-buffer-file-name-style 'buffer-name)  ;; Set the buffer file name style to just the buffer name (without path).
  (doom-modeline-project-detection 'project)           ;; Enable project detection for displaying the project name.
  (doom-modeline-buffer-name t)                        ;; Show the buffer name in the mode line.
  (doom-modeline-vcs-max-length 25)                    ;; Limit the version control system (VCS) branch name length to 25 characters.
  :config
  (if ek-use-nerd-fonts                                ;; Check if nerd fonts are being used.
      (setq doom-modeline-icon t)                      ;; Enable icons in the mode line if nerd fonts are used.
    (setq doom-modeline-icon nil))                     ;; Disable icons if nerd fonts are not being used.
  :hook
  (after-init . doom-modeline-mode))


;;; NERD ICONS
;; The `nerd-icons' package provides a set of icons for use in Emacs. These icons can
;; enhance the visual appearance of various modes and packages, making it easier to
;; distinguish between different file types and functionalities.
(use-package nerd-icons
  :if ek-use-nerd-fonts                   ;; Load the package only if the user has configured to use nerd fonts.
  :ensure t                               ;; Ensure the package is installed.
  :straight t
  :defer t)                               ;; Load the package only when needed to improve startup time.


;;; NERD ICONS Dired
;; The `nerd-icons-dired' package integrates nerd icons into the Dired mode,
;; providing visual icons for files and directories. This enhances the Dired
;; interface by making it easier to identify file types at a glance.
(use-package nerd-icons-dired
  :if ek-use-nerd-fonts                   ;; Load the package only if the user has configured to use nerd fonts.
  :ensure t                               ;; Ensure the package is installed.
  :straight t
  :defer t                                ;; Load the package only when needed to improve startup time.
  :hook
  (dired-mode . nerd-icons-dired-mode))


;;; NERD ICONS COMPLETION
;; The `nerd-icons-completion' package enhances the completion interfaces in
;; Emacs by integrating nerd icons with completion frameworks such as
;; `marginalia'. This provides visual cues for the completion candidates,
;; making it easier to distinguish between different types of items.
(use-package nerd-icons-completion
  :if ek-use-nerd-fonts                   ;; Load the package only if the user has configured to use nerd fonts.
  :ensure t                               ;; Ensure the package is installed.
  :straight t
  :after (:all nerd-icons marginalia)     ;; Load after `nerd-icons' and `marginalia' to ensure proper integration.
  :config
  (nerd-icons-completion-mode)            ;; Activate nerd icons for completion interfaces.
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)) ;; Setup icons in the marginalia mode for enhanced completion display.


;;; CATPPUCCIN THEME
;; The `catppuccin-theme' package provides a visually pleasing color theme
;; for Emacs that is inspired by the popular Catppuccin color palette.
;; This theme aims to create a comfortable and aesthetic coding environment
;; with soft colors that are easy on the eyes.
(use-package catppuccin-theme
  :ensure t
  :straight t
  :init
  (setq catppuccin-flavor 'latte)
  :config
  (custom-set-faces
   ;; Set the color for changes in the diff highlighting to blue.
   `(diff-hl-change ((t (:background unspecified :foreground ,(catppuccin-get-color 'blue))))))

  (custom-set-faces
   ;; Set the color for deletions in the diff highlighting to red.
   `(diff-hl-delete ((t (:background unspecified :foreground ,(catppuccin-get-color 'red))))))

  (custom-set-faces
   ;; Set the color for insertions in the diff highlighting to green.
   `(diff-hl-insert ((t (:background unspecified :foreground ,(catppuccin-get-color 'green))))))

  ;; Load the Catppuccin theme without prompting for confirmation.
  (load-theme 'catppuccin :no-confirm))

(use-package avy
  :straight t
  :general
  ("M-;" 'avy-goto-char-timer
   "<leader>gb" 'avy-pop-mark
   "<leader>gl" 'avy-goto-line
   "<leader>gg" 'avy-goto-char-timer)
  (:states 'normal
		   "ga" 'avy-goto-char-timer
		   "gl" 'avy-goto-line)
  :config
  (defun avy-action-kill-whole-line (pt)
	(save-excursion
	  (goto-char pt)
	  (kill-whole-line))
	(select-window
	 (cdr
	  (ring-ref avy-ring 0)))
	t)
  (defun avy-action-copy-whole-line (pt)
	(save-excursion
	  (goto-char pt)
	  (cl-destructuring-bind (start . end)
		  (bounds-of-thing-at-point 'line)
		(copy-region-as-kill start end)))
	(select-window
	 (cdr
	  (ring-ref avy-ring 0)))
	t)

  (defun avy-action-yank-whole-line (pt)
	(avy-action-copy-whole-line pt)
	(save-excursion (yank))
	t)

  (defun avy-action-mark-to-char (pt)
	(activate-mark)
	(goto-char pt))

  (defun avy-action-flyspell (pt)
	(save-excursion
      (goto-char pt)
      (when (require 'flyspell nil t)
		(flyspell-correct-at-point)))
	(select-window
	 (cdr (ring-ref avy-ring 0)))
	t)

  (defun avy-action-teleport-whole-line (pt)
	(avy-action-kill-whole-line pt)
	(save-excursion (yank)) t)

  (defun avy-action-embark (pt)
	(unwind-protect
		(save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
	t)

  (setf (alist-get ?y avy-dispatch-alist) 'avy-action-yank
        (alist-get ?w avy-dispatch-alist) 'avy-action-copy
        (alist-get ?W avy-dispatch-alist) 'avy-action-copy-whole-line
        (alist-get ?t avy-dispatch-alist) 'avy-action-teleport
        (alist-get ?T avy-dispatch-alist) 'avy-action-teleport-whole-line
        (alist-get ?Y avy-dispatch-alist) 'avy-action-yank-whole-line
        (alist-get ?k avy-dispatch-alist) 'avy-action-kill-stay
        (alist-get ?K avy-dispatch-alist) 'avy-action-kill-whole-line
        (alist-get ?  avy-dispatch-alist) 'avy-action-mark-to-char
        (alist-get ?. avy-dispatch-alist) 'avy-action-flyspell
        (alist-get ?\; avy-dispatch-alist) 'avy-action-embark)
  (setq avy-keys (delete ?k avy-keys)))

(use-package ace-window
  :straight t
  :general
  ("M-o" 'ace-window)
  :custom
  (ace-window-display-mode t)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-dispatch-alist
   '((?x aw-delete-window "Delete Window")
	 (?m aw-swap-window "Swap Windows")
	 (?M aw-move-window "Move Window")
	 (?c aw-copy-window "Copy Window")
	 (?B aw-switch-buffer-in-window "Select Buffer")
	 (?n aw-flip-window)
	 (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
	 (?c aw-split-window-fair "Split Fair Window")
	 (?v aw-split-window-vert "Split Vert Window")
	 (?b aw-split-window-horz "Split Horz Window")
	 (?o delete-other-windows "Delete Other Windows")
	 (?r aw-window-resize "Resize Window")
	 (?? aw-show-dispatch-help)))
  :config
  ;; Resize window using hydras
  (defhydra hydra-window-resizer (:columns 2)
	"Window Sizing."
	("-" shrink-window-horizontally "horizontal shrink")
	("=" enlarge-window-horizontally "horizontal enlarge")
	("_" shrink-window "vertical shrink")
	("+" enlarge-window "vertical enlarge"))

  (defun aw-window-resize (window)
	"Resize WINDOW using `hydra-window-resizer/body'."
	(aw-switch-to-window window)
	(hydra-window-resizer/body))
  (defun aw-show-dispatch-help ()
	"Display action shortucts in echo area."
	(interactive)
	(message "%s" (mapconcat
				   (lambda (action)
					 (cl-destructuring-bind (key fn &optional description) action
					   (format "%s: %s"
							   (propertize
								(char-to-string key)
								'face 'aw-key-face)
							   (or description fn))))
				   aw-dispatch-alist
				   " "))
	;; Prevent this from replacing any help display
	;; in the minibuffer.
	(let (aw-minibuffer-flag)
	  (mapc #'delete-overlay aw-overlays-back)
	  (call-interactively 'ace-window))))

(use-package org
  :straight (org :type git :host github :repo "emacs-straight/org-mode")
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :commands (org-mode org-agenda org-capture)
  :general
  ("<leader> a" 'org-agenda
   "<leader> c" 'org-capture)
  :general-config
  (:keymaps 'org-mode-map
			"C-M-<up>" 'org-up-element
			"C-z" 'org-cycle-list-bullet)
  (general-nivmap ;; Org open controls
	"<leader>oj" 'org-clock-goto
	"<leader>ol" 'org-clock-in-last
	"<leader>oi" 'org-clock-in
	"<leader>oo" 'org-clock-out
	"<leader>oa" 'org-agenda
	"<leader>oc" 'org-capture)
  (general-nivmap :keymaps 'org-mode-map ;; Reproduce doom's org menu
	"C-c l '" #'org-edit-special
	"C-c l *" #'org-ctrl-c-star
	"C-c l +" #'org-ctrl-c-minus
	"C-c l ," #'org-switchb
	"C-c l ." #'org-goto
	"C-c l #" #'org-update-statistics-cookies
	"C-c l @" #'org-cite-insert
	"C-c l A" #'org-archive-subtree-default
	"C-c l e" #'org-export-dispatch
	"C-c l f" #'org-footnote-action
	"C-c l h" #'org-toggle-heading
	"C-c l i" #'org-toggle-item
	"C-c l I" #'org-id-get-create
	"C-c l k" #'org-babel-remove-result
	"C-c l n" #'org-store-link
	"C-c l q" #'org-set-tags-command
	"C-c l t" #'org-todo
	"C-c l T" #'org-todo-list
	"C-c l x" #'org-toggle-checkbox
	"C-c l a a" #'org-attach
	"C-c l a d" #'org-attach-delete-one
	"C-c l a D" #'org-attach-delete-all
	"C-c l a n" #'org-attach-new
	"C-c l a o" #'org-attach-open
	"C-c l a O" #'org-attach-open-in-emacs
	"C-c l a r" #'org-attach-reveal
	"C-c l a R" #'org-attach-reveal-in-emacs
	"C-c l a u" #'org-attach-url
	"C-c l a s" #'org-attach-set-directory
	"C-c l a S" #'org-attach-sync
	"C-c l b -" #'org-table-insert-hline
	"C-c l b a" #'org-table-align
	"C-c l b b" #'org-table-blank-field
	"C-c l b c" #'org-table-create-or-convert-from-region
	"C-c l b e" #'org-table-edit-field
	"C-c l b f" #'org-table-edit-formulas
	"C-c l b h" #'org-table-field-info
	"C-c l b s" #'org-table-sort-lines
	"C-c l b r" #'org-table-recalculate
	"C-c l b R" #'org-table-recalculate-buffer-tables
	"C-c l b d c" #'org-table-delete-column
	"C-c l b d r" #'org-table-kill-row
	"C-c l b i c" #'org-table-insert-column
	"C-c l b i h" #'org-table-insert-hline
	"C-c l b i r" #'org-table-insert-row
	"C-c l b i H" #'org-table-hline-and-move
	"C-c l b t f" #'org-table-toggle-formula-debugger
	"C-c l b t o" #'org-table-toggle-coordinate-overlays
	"C-c l c c" #'org-clock-cancel
	"C-c l c d" #'org-clock-mark-default-task
	"C-c l c e" #'org-clock-modify-effort-estimate
	"C-c l c E" #'org-set-effort
	"C-c l c g" #'org-clock-goto
	"C-c l c G" (lambda (&rest _ (interactive) (org-clock-goto 'select)))
	"C-c l c i" #'org-clock-in
	"C-c l c I" #'org-clock-in-last
	"C-c l c o" #'org-clock-out
	"C-c l c r" #'org-resolve-clocks
	"C-c l c R" #'org-clock-report
	"C-c l c t" #'org-evaluate-time-range
	"C-c l c =" #'org-clock-timestamps-up
	"C-c l c -" #'org-clock-timestamps-down
	"C-c l d d" #'org-deadline
	"C-c l d s" #'org-schedule
	"C-c l d t" #'org-time-stamp
	"C-c l d T" #'org-time-stamp-inactive
	"C-c l g c" #'org-clock-goto
	"C-c l g C" (lambda (&rest _ (interactive) (org-clock-goto 'select)))
	"C-c l g i" #'org-id-goto
	"C-c l g r" #'org-refile-goto-last-stored
	"C-c l g x" #'org-capture-goto-last-stored
	"C-c l l i" #'org-id-store-link
	"C-c l l l" #'org-insert-link
	"C-c l l L" #'org-insert-all-links
	"C-c l l s" #'org-store-link
	"C-c l l S" #'org-insert-last-stored-link
	"C-c l l t" #'org-toggle-link-display
	"C-c l P a" #'org-publish-all
	"C-c l P f" #'org-publish-current-file
	"C-c l P p" #'org-publish
	"C-c l P P" #'org-publish-current-project
	"C-c l P s" #'org-publish-sitemap
	"C-c l r" #'org-refile
	"C-c l R" #'org-refile-reverse
	"C-c l s a" #'org-toggle-archive-tag
	"C-c l s b" #'org-tree-to-indirect-buffer
	"C-c l s c" #'org-clone-subtree-with-time-shift
	"C-c l s d" #'org-cut-subtree
	"C-c l s h" #'org-promote-subtree
	"C-c l s j" #'org-move-subtree-down
	"C-c l s k" #'org-move-subtree-up
	"C-c l s l" #'org-demote-subtree
	"C-c l s n" #'org-narrow-to-subtree
	"C-c l s r" #'org-refile
	"C-c l s s" #'org-sparse-tree
	"C-c l s A" #'org-archive-subtree-default
	"C-c l s N" #'widen
	"C-c l s S" #'org-sort
	"C-c l p d" #'org-priority-down
	"C-c l p p" #'org-priority
	"C-c l p u" #'org-priority-up)

  :hook ((org-mode . (lambda () (electric-indent-local-mode -1)))
         (org-mode  . turn-on-visual-line-mode)
         (org-agenda-mode . hl-line-mode)
         (org-agenda-mode . (lambda () (add-hook 'window-configuration-change-hook 'org-agenda-align-tags nil t)))
         (org-agenda-after-show . org-show-entry))

  :custom
  (org-beamer-mode t) ;; Export to beamer
  (org-catch-invisible-edits 'show)
  (org-complete-tags-always-offer-all-agenda-tags t) ;; Always use all tags from Agenda files in capture
  (org-edit-timestamp-down-means-later nil)
  (org-export-coding-system 'utf-8)
  (org-export-kill-product-buffer-when-displayed t)
  (org-fast-tag-selection-single-key 'expert)
  (org-hide-leading-stars nil)
  (org-html-validation-link nil)
  (org-imenu-depth 2)
  (org-indent-mode "noindent")
  (org-log-done t)
  (org-startup-indented nil)
  (org-support-shift-select t)
  (org-tags-column 80)
  (org-directory "~/org")
  (org-default-notes-file "~/org/inbox.org")
  ;; org-agenda:
  (org-agenda-files (list
                     "~/org/todo.org"
                     "~/org/inbox.org"))
  (org-agenda-compact-blocks t)
  (org-agenda-start-on-weekday 1)
  (org-agenda-span 7)
  (org-agenda-start-day nil)
  (org-agenda-include-diary t)
  (org-agenda-sorting-strategy
   '((agenda habit-down time-up user-defined-up effort-up category-keep)
     (todo category-up effort-up)
     (tags category-up effort-up)
     (search category-up)))
  (org-agenda-window-setup 'current-window)
  (org-agenda-custom-commands
   `(("N" "Notes" tags "NOTE"
      ((org-agenda-overriding-header "Notes")
       (org-tags-match-list-sublevels t)))))
  (setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))
  ;; org-archive:
  (org-archive-mark-done nil)
  (org-archive-location "%s_archive::* Archive")
  ;; org-capture:
  (org-capture-templates
   `(("t" "todo" entry (file+headline "" "Inbox") ; "" => `org-default-notes-file'
      "* TODO %?\n%t\n%i\n")))
  ;; org-refile:
  (org-refile-use-cache nil)
  (org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))
  ;; Targets start with the file name - allows creating level 1 tasks
  (org-refile-use-outline-path t)
  (org-outline-path-complete-in-steps nil)
  ;; Allow refile to create parent tasks with confirmation
  (org-refile-allow-creating-parent-nodes 'confirm)
  ;; org-todo:
  (org-todo-keywords
   (quote ((sequence "TODO(t)" "|" "DONE(d!/!)")
           )))
  (org-todo-repeat-to-state "TODO")
  (org-todo-keyword-faces
   (quote (("NEXT" :inherit warning)
           ("PROJECT" :inherit font-lock-string-face))))
  (org-use-property-inheritance t) ;; Inherit properties from parents
  ;; org-cite:
  (org-cite-export-processors '((t csl)))
  (org-cite-csl-styles-dir "~/.csl")
  :config

  ;; Open file links in the same frame:
  (setf (alist-get 'file org-link-frame-setup) #'find-file)

  ;; Open .docx files using macOS/XDG open:
  (add-to-list 'org-file-apps `("\\.docx\\'" . ,(if (eq system-type 'darwin) "open %s" "xdg-open %s")))

  ;; org-refile configuration:
  (advice-add 'org-refile :after (lambda (&rest _) (org-save-all-org-buffers)))

  ;; Exclude DONE state tasks from refile targets
  (defun sanityinc/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets."
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-refile-target-verify-function 'sanityinc/verify-refile-target)

  (defun sanityinc/org-refile-anywhere (&optional goto default-buffer rfloc msg)
    "A version of `org-refile' which allows refiling to any subtree."
    (interactive "P")
    (let ((org-refile-target-verify-function))
      (org-refile goto default-buffer rfloc msg)))

  (defun sanityinc/org-agenda-refile-anywhere (&optional goto rfloc no-update)
    "A version of `org-agenda-refile' which allows refiling to any subtree."
    (interactive "P")
    (let ((org-refile-target-verify-function))
      (org-agenda-refile goto rfloc no-update)))

  ;; Custom add-ons:
  (defun ap/org-summary-todo (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise.

N-DONE is the number of done elements; N-NOT-DONE is the number of
not done."
    (let (org-log-done org-log-states)  ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  (defun ap/org-checkbox-todo ()
    "Switch header TODO state to DONE when all checkboxes are ticked.

Switch to TODO otherwise"
    (let ((todo-state (org-get-todo-state)) beg end)
      (unless (not todo-state)
        (save-excursion
          (org-back-to-heading t)
          (setq beg (point))
          (end-of-line)
          (setq end (point))
          (goto-char beg)
          (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
                                 end t)
              (if (match-end 1)
                  (if (equal (match-string 1) "100%")
                      (unless (string-equal todo-state "DONE")
                        (org-todo 'done))
                    (unless (string-equal todo-state "TODO")
                      (org-todo 'todo)))
                (if (and (> (match-end 2) (match-beginning 2))
                         (equal (match-string 2) (match-string 3)))
                    (unless (string-equal todo-state "DONE")
                      (org-todo 'done))
                  (unless (string-equal todo-state "TODO")
                    (org-todo 'todo)))))))))

  (add-hook 'org-after-todo-statistics-hook 'ap/org-summary-todo)
  (add-hook 'org-checkbox-statistics-hook 'ap/org-checkbox-todo)

  (defun ap/wrap-dotimes (fn)
    "Wrap FN in a dotimes loop to make it repeatable with universal arguments."
    (let ((fn fn)) #'(lambda (&optional c)
                       (interactive "p")
                       (dotimes (_ c) (funcall fn)))))

  (define-key org-mode-map (kbd "M-<up>") (ap/wrap-dotimes 'org-metaup))
  (define-key org-mode-map (kbd "M-<down>") (ap/wrap-dotimes 'org-metadown)))

(use-package ox-pandoc
  :straight t
  :after org
  :init
  (add-to-list 'org-export-backends 'pandoc)
  (setq org-pandoc-options
        `((standalone . t)
          (mathjax . t)
          (variable . "revealjs-url=https://revealjs.com"))))

(use-package citeproc
  :straight t
  :after (org))


(use-package move-dup
  :straight t
  :general
  ([M-S-up] 'move-dup-move-lines-up
   [M-S-down] 'move-dup-move-lines-down
   [M-up] 'move-dup-move-lines-up
   [M-down] 'move-dup-move-lines-down
   [C-M-up] 'move-dup-duplicate-up
   [C-M-down] 'move-dup-duplicate-down))

(use-package session
  :straight t
  :hook
  (after-init . session-initialize)
  :init
  (setq session-save-file (locate-user-emacs-file ".session"))
  (setq session-name-disable-regexp "\\(?:\\`'/tmp\\|\\.git/[A-Z_]+\\'\\)")
  (setq session-save-file-coding-system 'utf-8))

;;; UTILITARY FUNCTION TO INSTALL EMACS-KICK
(defun ek/first-install ()
  "Install tree-sitter grammars and compile packages on first run..."
  (interactive)                                      ;; Allow this function to be called interactively.
  (switch-to-buffer "*Messages*")                    ;; Switch to the *Messages* buffer to display installation messages.
  (message ">>> All required packages installed.")
  (message ">>> Configuring Emacs-Kick...")
  (message ">>> Configuring Tree Sitter parsers...")
  (require 'treesit-auto)
  (treesit-auto-install-all)                         ;; Install all available Tree Sitter grammars.
  (message ">>> Configuring Nerd Fonts...")
  (require 'nerd-icons)
  (nerd-icons-install-fonts)                         ;; Install all available nerd-fonts
  (message ">>> Emacs-Kick installed! Press any key to close the installer and open Emacs normally. First boot will compile some extra stuff :)")
  (read-key)                                         ;; Wait for the user to press any key.
  (kill-emacs))                                      ;; Close Emacs after installation is complete.

(provide 'init)
;;; init.el ends here
