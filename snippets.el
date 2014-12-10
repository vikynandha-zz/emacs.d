;; --------------------------------------------------- ;;
;; Collection of snippets and macros that don't fit anywhere else ;;
;; --------------------------------------------------- ;;

(defun passwords-edit ()
  "Edit the passwords file."
  (interactive)
  (find-file "~/Notes/Passwords.org.gpg"))

(defmacro replace-in-file (from-string to-string)
  `(progn
     (goto-char (point-min))
     (while (search-forward ,from-string nil t)
       (replace-match ,to-string nil t))))

(defun cleanup-fancy-quotes ()
  (interactive)
  (progn
    (replace-in-file "’" "'")
    (replace-in-file "“" "\"")
    (replace-in-file "”" "\"")
    (replace-in-file "" "")))

(defun smart-open-line ()
  "Shortcut for C-e RET"
  (interactive)
  (move-end-of-line nil)
  (newline))
(global-set-key [(shift return)] 'smart-open-line)

;; Occur in isearch
;; http://www.emacswiki.org/emacs/OccurFromIsearch
(defun isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
	(occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))
(define-key isearch-mode-map (kbd "C-c o") 'isearch-occur)

;; Compile current buffer (if LESS) to CSS
(defun compile-less-css ()
  "Compile LESS to CSS"
  (async-shell-command (concat "lessc -x " (buffer-file-name) " "
                               (file-name-directory (directory-file-name (file-name-directory buffer-file-name)))
                               "css/" (file-name-sans-extension (file-name-nondirectory buffer-file-name)) ".css") nil nil)
  (delete-other-windows))

(defun compile-tex-pdf ()
  "Compile Tex/LaTeX files to pdf"
  (shell-command (concat "pdflatex " (buffer-file-name)) nil nil))

(defun compile-buffer ()
  (interactive)
  (if (string-match "\.less$" (buffer-file-name))
            (compile-less-css))
  (if (string-match "\.tex$" (buffer-file-name))
      (compile-tex-pdf))
  (delete-other-windows))


(defun insert-file-name ()
  "Insert the full path file name into the current buffer."
  (interactive)
  (insert (file-name-nondirectory buffer-file-name)
                                  (window-buffer (minibuffer-selected-window))))
