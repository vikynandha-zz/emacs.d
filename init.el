;; ------------------------------------
;; -*- Mode: Emacs-Lisp -*-
;; -*- lisp -*-
;; ~/.emacs.d/init.el
;; Jaseem Abid <jaseemabid@gmail.com>
;; Vignesh Nandha Kumar <viky.nandha@gmail.com>
;; ------------------------------------

;; --------
;; Identity
;; ---------
(setq init-file-user "viky"
	  user-full-name "Vignesh Nandha Kumar"
	  user-mail-address "viky.nandha@gmail.com")

;; --------------------
;; Recompile everything
;; --------------------
;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)

;; ---------------
;; Custom packages
;; ---------------
(require 'cl)
(require 'package)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Install all packages requied
(load-file "~/.emacs.d/elpa-list.el")

(package-initialize)

(defun jaseem/packages-installed-p ()
  (loop for pkg in jaseem/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (jaseem/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg jaseem/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; ---------
;; Autoloads
;; ---------
(require 'centered-cursor-mode)
(require 'coffee-mode)
(require 'httpcode)
(require 'lorem-ipsum)
(require 'magit)
(require 'rainbow-mode)
(require 'remember)
(require 'saveplace)
(require 'server)
(require 'uniquify)
(require 'zone)
(require 'web-beautify)
(require 'auto-complete)
(require 'ac-js2)

;; -----------------
;; General settings
;; -----------------
(setq-default c-basic-indent 4
			  c-basic-offset 4
			  c-default-style "k&r"
			  case-fold-search t
			  column-number-mode t
			  default-major-mode 'org-mode
			  default-tab-width 4
			  fill-adapt-mode t
			  fill-column 80
			  font-lock-maximum-decoration t
			  indent-tabs-mode nil
			  inhibit-startup-message t
			  initial-scratch-message nil
			  next-line-add-newlines nil
			  nxml-child-indent 4
			  require-final-newline t
			  ring-bell-function 'ignore
			  save-place t
			  sentence-end-double-space nil
			  tab-width 4
			  transient-mark-mode t
			  uniquify-buffer-name-style 'forward
			  vc-follow-symlinks t
			  visible-bell t)

;; Set the default browser to Chrome
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

;; Make y/n suffice for yes/no q
(fset 'yes-or-no-p 'y-or-n-p)

;; ----------------------
;; Fonts and text styling
;; ----------------------
(set-frame-font "Inconsolata-11")

;; --------------
;; Display tweaks
;; --------------

;; Set the name of the host and current path/file in title bar:
(setq frame-title-format
	  (list (format "%s %%S: %%j " (system-name))
			'(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Always open maximized
(when (eq system-type 'gnu/linux)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

;; Color themes
(load-theme 'solarized-dark t)

;; Start maximized
;; (set-frame-parameter nil 'fullscreen 'maximized)

;; No bars and buttons
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

;; backup files
(setq backup-directory-alist
	  '(("." . "~/.emacs.d/backups")))

;; ----------------
;; auto-mode-alists
;; ----------------
(add-to-list 'auto-mode-alist '("/PKGBUILD$" . pkgbuild-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.asp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ext\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.iced$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . css-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
(add-to-list 'auto-mode-alist '("mutt-.*-" . mail-mode))
(add-to-list 'auto-mode-alist '("nginx.conf" . nginx-mode))
(add-to-list 'auto-mode-alist '("/nginx/sites-enabled/" . nginx-mode))
(add-to-list 'auto-mode-alist '("/nginx/sites-available/" . nginx-mode))

;; ------------------
;; Custom keybindings
;; ------------------

;; buffer switching
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-c b") 'bury-buffer)

;; buffer list suck
;; (define-key global-map "\C-x\C-b" 'electric-buffer-list)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; comment/uncomment block
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

;; eval buffer
(global-set-key (kbd "C-c e") 'eval-buffer)

;; powerful counterparts ?
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-c s") 'rgrep)

;; Compile LESS to CSS, tex to pdf
(global-set-key '[f9] 'compile-buffer)

;; eshell tweaks

;; Open files and go places like we see from error messages, i e: path:line:col
;; (to-do "make `find-file-line-number' work for emacsclient as well")
;; (to-do "make `find-file-line-number' check if the file exists")
(defadvice find-file (around find-file-line-number
                             (path &optional wildcards)
                             activate)
  "Turn files like file.js:14:10 into file.js and going to line 14, col 10."
  (save-match-data
    (let* ((match (string-match "^\\(.*?\\):\\([0-9]+\\):?\\([0-9]*\\)$" path))
           (line-no (and match
                         (match-string 2 path)
                         (string-to-number (match-string 2 path))))
           (col-no (and match
                        (match-string 3 path)
                        (string-to-number (match-string 3 path))))
           (path (if match (match-string 1 path) path)))
      ad-do-it
      (when line-no
        ;; goto-line is for interactive use
        (goto-char (point-min))
        (forward-line (1- line-no))
        (when (> col-no 0)
          (forward-char (1- col-no)))))))

(defalias 'open 'find-file)
(defalias 'o 'find-file)
(defalias 'openo 'find-file-other-window)

(defun eshell/clear ()
  "clear shell buffer"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))
(global-set-key (kbd "C-l") 'eshell/clear)
(global-set-key (kbd "C-z") 'eshell)
(global-set-key (kbd "C-x M-z") 'suspend-frame)

;; mark all
(global-set-key (kbd "C-c a") 'mark-whole-buffer)

;; menu bar for exploring new modes
(global-set-key (kbd "C-c C-m") 'menu-bar-mode)

;; navigation bindings
(global-set-key (kbd "C-M-g") 'goto-line)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-n") 'forward-paragraph)

;; sorting
(global-set-key (kbd "M-s l") 'sort-lines)

;; undo without leaving the ctrl key
(define-key global-map "\C-x\C-u" 'undo)

;; webjump let's you quickly search google, wikipedia, emacs wiki
(global-set-key (kbd "C-x g") 'webjump)
(global-set-key (kbd "C-x M-g") 'browse-url-at-point)

;; ------------------------
;; Mode level customization
;; ------------------------

;; auto-fill
(auto-fill-mode 1)

;; centered cursor mode
(global-centered-cursor-mode t)

;; coffee-mode
(add-hook 'coffee-mode-hook
		  (lambda ()
			"coffee-mode-hook"
			(make-local-variable 'tab-width)
			(set 'tab-width 2)
			)
		  )

;; desktop-mode
(desktop-save-mode t)
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'help-mode)
(add-to-list 'desktop-modes-not-to-save 'magit-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
(add-to-list 'desktop-modes-not-to-save 'completion-list-mode)
(define-key global-map (kbd "\C-c\C-s") 'desktop-save-in-desktop-dir)

;; dired-mode
(defalias 'ido-list-directory 'dired) ;; list directory is pointless and stupid

;; emmet-mode
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook 'emmet-mode)

;; eshell
(setq eshell-buffer-maximum-lines 4096)

;; haskell-mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; hslint on the command line only likes this indentation mode;
;; alternatives commented out below.
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;; Ignore compiled Haskell files in filename completions
(add-to-list 'completion-ignored-extensions ".hi")

;; html-mode
;; Better navigation
(add-hook 'html-mode-hook
		  (lambda ()
			"html-mode-hook"
			(set (make-local-variable 'sgml-basic-offset) 4)
			(set (make-local-variable 'tab-width) 4)
			(set (make-local-variable 'whitespace-line) 100)
			(define-key html-mode-map (kbd "<M-left>") 'sgml-skip-tag-backward)
			(define-key html-mode-map (kbd "<M-right>") 'sgml-skip-tag-forward)
			)
		  )

;; jade-mode
(add-hook 'jade-mode-hook
		  (lambda ()
			"jade-mode-hook"
			(set (make-local-variable 'whitespace-line) 100)
            (auto-complete-mode)
			)
		  )

;; ido-mode
(setq ido-enable-flex-matching t
	  ido-all-frames 'visible
	  ido-case-fold t
	  ido-create-new-buffer 'prompt
	  ido-everywhere t)
(ido-mode t)

;; image modes
(add-hook 'image-mode-hook 'eimp-mode)
;; (add-hook 'eimp-mode-hook 'eimp-fit-image-to-window)

;; js-mode
(defalias 'js-mode 'js2-mode)

(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; js2-mode
(add-hook 'js2-mode-hook
		  (lambda ()
			(setq mode-name "JS2")
            (auto-complete-mode)
            (global-set-key (kbd "C-c d") (lambda ()
                                            (interactive)
                                            (insert-string "debugger;" )))
			)
		  )

(setq-default js-indent-level 4
			  js2-allow-keywords-as-property-names t
			  js2-auto-insert-catch-block t
			  js2-concat-multiline-strings t
			  js2-global-externs (quote
								  ("module" "require"
								   "setTimeout" "clearTimeout"
								   "setInterval" "clearInterval"
								   "location" "console" "JSON"
                                   ;; Common libs
								   "jQuery" "$"
								   "_" "Backbone"
                                   ;; recruiterbox global vars
                                   "RB" "_RB" "Util"
                                   ;; third-party stuff used in recruiterbox
                                   "timezoneJS" "mixpanel" "_errs" "google"
                                   ))
			  js2-highlight-level 3
			  js2-include-browser-externs t
			  js2-include-node-externs t)

;; js2-refactor-mode
(js2r-add-keybindings-with-prefix "C-c C-r")

(global-set-key (kbd "C-<next>") 'js2-next-error)

;; less-css-mode
(add-hook 'less-css-mode-hook
		  (lambda ()
            (auto-complete-mode)
			)
		  )

;; line-number-mode
(global-linum-mode t)
(global-hl-line-mode t)

;; magit
(define-key global-map (kbd "C-c g") 'magit-status)
(define-key global-map (kbd "C-c l") 'magit-log)
(define-key global-map (kbd "C-c c") 'magit-checkout)
(define-key global-map (kbd "C-c m") 'magit-merge)
(setq magit-commit-all-when-nothing-staged nil
      magit-revert-item-confirm t
      magit-process-connection-type nil
      process-connection-type nil)
(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)

;; Python-mode
(add-hook 'python-mode-hook
		  (lambda ()
			(setq indent-tabs-mode nil)
			(setq tab-width 4)
			(setq python-indent 4)))

;; prog-mode
; (add-hook 'prog-mode-hook 'guru-mode)
; (add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; rainbow-mode
(add-hook 'css-mode-hook 'rainbow-mode)
; (add-hook 'html-mode-hook 'rainbow-mode)

;; remember-mode
(define-key global-map (kbd "C-c r") 'remember)
(define-key global-map (kbd "C-c R") 'remember-region)

;; root-edit : never save file as root
(if ( = (user-uid) 0)
	(read-only-mode t)
  )

;; server-mode
(unless (server-running-p)
  (server-start))

;; show parentheses
(show-paren-mode t)

;; smex-mode
;; bind Caps-Lock to smex
; (if (eq window-system 'x)
;     (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
; (global-set-key [f13] 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; snippets
(yas-global-mode 1)

;; text-mode
(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; sgml-mode
(defun turn-off-flyspell () (flyspell-mode 0))
(add-hook 'sgml-mode-hook 'turn-off-flyspell)

;; tramp-mode
(setq tramp-default-host "localhost"
	  tramp-default-method "ssh")

;; web-beautify mode
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

;; type over a region
(pending-delete-mode t)

;; uniquify buffers
(setq uniquify-buffer-name-style 'forward)

;; write file hook
(add-hook 'write-file-hooks
		  'delete-trailing-whitespace
		  )


;; elisp snippets
(load-file "~/.emacs.d/snippets.el")
