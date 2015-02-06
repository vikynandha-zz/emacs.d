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


;; Src: https://gist.github.com/magnars/2360578
(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols (symbol-list)
                       (when (listp symbol-list)
                         (dolist (symbol symbol-list)
                           (let ((name nil) (position nil))
                             (cond
                              ((and (listp symbol) (imenu--subalist-p symbol))
                               (addsymbols symbol))

                              ((listp symbol)
                               (setq name (car symbol))
                               (setq position (cdr symbol)))

                              ((stringp symbol)
                               (setq name symbol)
                               (setq position (get-text-property 1 'org-imenu-marker symbol))))

                             (unless (or (null position) (null name))
                               (add-to-list 'symbol-names name)
                               (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols (delq nil (mapcar (lambda (symbol)
                                                     (if (string-match regexp symbol) symbol))
                                                   symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc (lambda (symbol) (setq symbol-names (cons symbol (delete symbol symbol-names))))
                  matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (push-mark (point))
      (goto-char position))))
