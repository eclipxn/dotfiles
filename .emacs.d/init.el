(cua-mode)

(setq custom-safe-themes t)
(use-package autothemer)
(load-theme 'custom-theme)

(set-cursor-color "#d3d3d3")

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(setq package-check-signature nil)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
;; (package-refresh-contents)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-always-demand t)

(setq make-backup-files nil)

(use-package general)

(keyboard-translate ?\C-i ?\H-i)
(keyboard-translate ?\C-m ?\H-m)
(general-define-key
 :keymaps 'key-translation-map
 "C-S-i" "H-S-i"
 "C-M-i" "H-M-i"
 "C-/" "H-/")
(let ((frame (framep (selected-frame))))
  (or (eq t frame)
      (eq 'pc frame)
      (define-key input-decode-map (kbd "C-[") (kbd "H-["))))

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq mode-line-format nil)
(tooltip-mode -1)
(set-fringe-mode 30)
(setq frame-resize-pixelwise t)

(use-package nlinum
  :config (global-nlinum-mode)
  (setq nlinum-format " %d"))

(defvar my/font "hermit")
(set-frame-font (concat my/font " 11") nil t)

(setq frame-title-format "%b - emacs")
(setq-default cursor-type 'bar)

(setq use-dialog-box nil)

(setq-default mode-line-format nil)

;; (defun my-message-filter (args)
;;   "Modify the arguments passed to `message'."

;;   (let ((fmt (car args))
;;         (rest (cdr args)))
;;     ;; Example: prefix everything with "[ADVISED] "
;;     (cons (concat (propertize "=^. .^= | " 'face '(:foreground "#da96ff" :weight bold)) fmt) rest)))
;; (advice-add 'message :filter-args #'my-message-filter)

;; (advice-remove 'message #'my-message-filter)

(global-hl-line-mode 1)

(advice-add 'face-at-point :around
            (lambda (orig-fun &rest r)
              (global-hl-line-mode -1)
              (prog1
                  (apply orig-fun r)
                (global-hl-line-mode 1))))

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))



(mapc (lambda (mode)
        (font-lock-add-keywords mode
                                '(("\\<\\([_a-zA-Z][_a-zA-Z0-9]*\\)\\>\\s-*(" 1 font-lock-function-name-face)) t))
      '(c++-mode c-mode python-mode js-mode rustic-mode))
(font-lock-add-keywords 'c++-mode
                        '(("\\<\\(\\(?:bool\\|char\\(?:\\(?:16\\|32\\)_t\\)?\\|double\\|float\\|int\\|long\\|s\\(?:hort\\|igned\\)\\|unsigned\\|void\\|wchar_t\\)\\)\\>" 1 font-lock-type-face)
                          ("\\<\\(for\\|while\\|if\\|return\\|operator\\|decltype\\)\\>" 1 font-lock-keyword-face)))



(setq-default fringe-indicator-alist (assq-delete-all 'continuation fringe-indicator-alist))


(defun init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))

(use-package midnight
  :config
  (setq clean-buffer-list-delay-special 1)
  (setq clean-buffer-list-kill-regexps '("^\\*.*\\*$")))

(setq cua-prefix-override-inhibit-delay 0.0001)
(advice-add 'cua-paste-pop :around (lambda (orig-fun &rest r)
                                     (let ((delete-selection (and delete-selection-mode (region-active-p))))
                                       (apply orig-fun r)
                                       (when delete-selection
                                         (delete-region (region-beginning) (region-end))))))

(defun my/forward-word (&optional arg) ;; TODO: word boundaries in camelCase
  (interactive "^p")
  (setq arg (or arg 1))
  (let ((word-boundary-regex "\\W\\S-\\|\\S-\\W\\|\n.\\|.\n"))
    (if (> arg 0)
        (progn
          (when (re-search-forward word-boundary-regex nil 0)
            (backward-char)))
      (progn
        (when (re-search-backward word-boundary-regex nil 0)
          (forward-char))))))
(defun my/backward-word (&optional arg)
  (interactive "p")
  (my/forward-word (- (or arg 1))))

;; (defun jump-to-char ()
;;   (interactive)
;;   (let ((char (read-key "Jump to:")))
;;     (when (<= 32 char 126)
;;       (when (eq char (char-after))
;;         (forward-char))
;;       (when (or (not (member char '(41 93 125)))
;;                 (progn
;;                   (ignore-errors
;;                     (forward-list)
;;                     (while (not (member char (list (char-after) (char-before))))
;;                       (forward-list)))
;;                   (not (member char (list (char-after) (char-before))))))
;;         (while (not (eq char (char-after)))
;;           (forward-char))))))
;; (defun backward-jump-to-char () ;; TODO: backward-list
;;   (interactive)
;;   (let ((char (read-key "Jump to:")))
;;     (when (<= 32 char 126)
;;       (backward-char)
;;       (while (not (eq char (char-before)))
;;         (backward-char)))))

(defun get-matching-bracket (bracket-char)
  (let ((syntable-value (aref (syntax-table) bracket-char))) ;; TODO: $ in latex
    (if (or (eq (car syntable-value) 4)
            (eq (car syntable-value) 5))
        (cdr syntable-value)
      0)))
(defun my/backward-delete-char (arg)
  (interactive "p")
  (dotimes (i arg)
    (let ((matching-bracket (get-matching-bracket (char-before))))
      (cond ((<= (char-before) matching-bracket)
             (progn
               (execute-kbd-macro (string matching-bracket))
               (backward-delete-char 2)))
            ((and (eq (car (aref (syntax-table) (char-before))) 7)
                  (eq (char-before) (char-after)))
             (progn
               (backward-delete-char 1)
               (forward-char)
               (backward-delete-char 1)))
            (t (backward-delete-char 1))))))
(defun buffer-indentation ()
  tab-width)
(defun backward-delete-char-whitespace-to-column (arg)
  (interactive "p")
  (dotimes (i arg)
    (if mark-active
        (delete-region (point) (mark))
      (let ((movement (% (current-column) (buffer-indentation)))
            (p (point)))
        (when (= movement 0) (setq movement (buffer-indentation)))
        (if (string-match-p "\\` +\\'" (buffer-substring-no-properties (save-excursion (beginning-of-line) (point)) p))
            (backward-delete-char movement)
          (my/backward-delete-char 1))))))
(defun my/backward-delete-word (arg)
  (interactive "p")
  (dotimes (i arg)
    (cond (mark-active
           (delete-region (mark) (point)))
          ((<= (char-before) (get-matching-bracket (char-before)))
           (my/backward-delete-char 1))
          ((and (eq (car (aref (syntax-table) (char-before))) 7)
                (eq (char-before) (char-after)))
           (progn
             ;; (my/backward-delete-char 1)
             ;; (forward-char)
             (my/backward-delete-char 1)))
          (t
           (let ((og-point (point)))
             (delete-region (progn
                              (when (eq (char-before) ?\s)
                                (backward-char))
                              (unless (and (eq (char-before) ?\n)
                                           (eq (char-after) ?\s)
                                           (not (eq (point) og-point)))
                                (my/backward-word))
                              (let ((new-point (point)))
                                (goto-char og-point)
                                new-point))
                            (point)))))))
(defun my/forward-delete-word (arg)
  (interactive "p")
  (dotimes (i arg)
    (let ((og-point (point)))
      (delete-region (point) (if mark-active
                                 (mark)
                               (progn
                                 (when (seq-contains-p '(?\s) (char-after))
                                   (forward-char))
                                 (my/forward-word)
                                 (let ((new-point (point)))
                                   (goto-char og-point)
                                   new-point)))))))
(defun insert-line-below ()
  (interactive)
  (move-end-of-line 1)
  (newline))
(defun insert-line-above ()
  (interactive)
  (move-beginning-of-line 1)
  (newline)
  (forward-line -1))
(defun apply-on-region-or-line (func)
  (let (beg end)
    (if (region-active-p)
        (progn
          (setq beg (region-beginning) end (region-end))
          (save-excursion
            (setq beg (progn (goto-char beg) (line-beginning-position))
                  end (progn (goto-char end) (line-end-position)))))
      (setq beg (line-beginning-position)
            end (line-end-position)))
    (funcall func beg end))
  (setq deactivate-mark nil))
(defun indent-buffer ()
  "Indent entire buffer, keeping point."
  (interactive)
  (indent-region 0 (buffer-end 1))
  (whitespace-cleanup))




;; Editing keybinds
(keyboard-translate ?\C-i ?\H-i)
(keyboard-translate ?\C-m ?\H-m)
(general-define-key
 :keymaps 'key-translation-map
 "C-S-i" "H-S-i"
 "C-M-i" "H-M-i"
 "C-/" "H-/")
(let ((frame (framep (selected-frame))))
  (or (eq t frame)
      (eq 'pc frame)
      (define-key input-decode-map (kbd "C-[") (kbd "H-["))))

(general-define-key
 :keymaps 'cua-global-keymap
 "C-<return>" nil
 "C-S-SPC" nil)

(general-define-key
 "C-l" 'my/forward-word
 "C-j" 'my/backward-word
 "C-k" 'next-line
 "H-i" 'previous-line
 ;; "C-S-l" 'move-end-of-line
 ;; "C-S-j" (lambda () (interactive) (back-to-indentation) (scroll-right))
 "C-S-l" 'forward-char
 "C-S-j" 'backward-char
 "C-S-k" (lambda () (interactive) (execute-kbd-macro (kbd "C-k") 5))
 "H-S-i" (lambda () (interactive) (execute-kbd-macro (kbd "H-i") 5))
 "C-;" 'jump-to-char
 ;; "C-n" 'backward-jump-to-char
 "C-v" 'yank
 "C-S-v" 'yank-pop
 "<backspace>" 'backward-delete-char-whitespace-to-column
 "C-<backspace>" 'my/backward-delete-word
 "C-<delete>" 'my/forward-delete-word
 "C-S-P" 'kill-whole-line
 "H-/" (lambda () (interactive)
         (apply-on-region-or-line 'comment-or-uncomment-region))
 "<backtab>" (lambda () (interactive)
             (apply-on-region-or-line (lambda (beg end)
                                        (indent-rigidly beg end (- (buffer-indentation))))))
 "<tab>" (lambda () (interactive)
           (apply-on-region-or-line (lambda (beg end)
                                      (indent-rigidly beg end (buffer-indentation)))))
 "C-z" 'undo-only
 "C-y" 'undo-redo
 "C-a" 'mark-whole-buffer
 "<C-return>" (lambda () (interactive)
                (move-end-of-line 1)
                (newline-and-indent))
 "<C-S-return>" (lambda () (interactive)
                  (if (eq (line-number-at-pos (point)) 1)
                      (progn
                        (move-beginning-of-line 1)
                        (newline)
                        (forward-line -1))
                    (progn
                      (forward-line -1)
                      (move-end-of-line 1)
                      (newline-and-indent))))
 "C-x w" (lambda () (interactive)
           (if use-formatter
               (lsp-format-buffer)
             (indent-buffer)))
 "C-g" 'keyboard-escape-quit)


(general-define-key
 :keymaps 'override
 "M-x" 'execute-extended-command
 "C-w" (lambda () (interactive)
         (condition-case nil
             (delete-window)
           (error (bury-buffer))))
 "C-o" 'other-window
 "C-S-SPC" 'cua-set-mark
 "C-n" 'find-file)

(general-define-key
 :keymaps 'minibuffer-mode-map
 "C-k" (lambda () (interactive) (execute-kbd-macro (kbd "<down>")))
 "H-i" (lambda () (interactive) (execute-kbd-macro (kbd "<up>"))))

(define-key lisp-interaction-mode-map (kbd "C-j") nil)
(define-key minibuffer-local-map (kbd "C-j") nil)
(general-define-key
 :keymaps 'cua-global-keymap
 "C-<return>" nil
 "C-S-SPC" nil)
(general-define-key
 :keymaps 'cua--cua-keys-keymap
 "C-z" nil
 "C-v" nil)
(general-define-key
 :keymaps 'read--expression-map
 "C-j" nil)
(general-define-key
 :keymaps 'view-mode-map
 "C-j" nil)
(general-define-key
 :keymaps 'custom-field-keymap
 "C-k" nil)
(general-define-key
 :keymaps 'widget-field-keymap
 "C-k" nil)

(setq scroll-conservatively 101)

(use-package swiper
  ;; :config (setq ivy-re-builders-alist '((swiper . regexp-quote)))
  :bind (("C-f" . swiper)
         :map ivy-minibuffer-map
         ("S-SPC" . nil)
         ("C-v" . nil)
         ("C-j" . nil)
         :map swiper-map
         ("C-l" . nil)))
(advice-add 'swiper :before
            (lambda (&rest r)
              (define-key ivy-minibuffer-map (kbd "<return>") 'ivy-done)))
(advice-add 'swiper-query-replace :before
            (lambda (&rest r)
              (define-key ivy-minibuffer-map (kbd "<return>") 'ivy-immediate-done)))

(auto-save-mode -1)
(defun auto-save-all ()
  (let ((inhibit-message t))
    (save-some-buffers t)))
(add-function :after after-focus-change-function 'auto-save-all)
(defvar auto-save-timer (run-with-idle-timer 0.2 t 'auto-save-all))

(electric-pair-mode 1)
(setq electric-pair-skip-whitespace nil)

(setq-default tab-width 3)
(setq standard-indent tab-width)
(add-hook 'python-mode-hook (lambda () (setq tab-width 3)))
(setq-default indent-tabs-mode nil)


(use-package dtrt-indent
  :config
  (dtrt-indent-global-mode))


;; Hack to leave trailing whitespace
(defun my/electric-indent-post-self-insert-function ()
  "Function that `electric-indent-mode' adds to `post-self-insert-hook'.
This indents if the hook `electric-indent-functions' returns non-nil,
or if a member of `electric-indent-chars' was typed; but not in a string
or comment."
  ;; FIXME: This reindents the current line, but what we really want instead is
  ;; to reindent the whole affected text.  That's the current line for simple
  ;; cases, but not all cases.  We do take care of the newline case in an
  ;; ad-hoc fashion, but there are still missing cases such as the case of
  ;; electric-pair-mode wrapping a region with a pair of parens.
  ;; There might be a way to get it working by analyzing buffer-undo-list, but
  ;; it looks challenging.
  (let (pos)
    (when (and
           electric-indent-mode
           ;; Don't reindent while inserting spaces at beginning of line.
           (or (not (memq last-command-event '(?\s ?\t)))
               (save-excursion (skip-chars-backward " \t") (not (bolp))))
           (setq pos (electric--after-char-pos))
           (save-excursion
             (goto-char pos)
             (let ((act (or (run-hook-with-args-until-success
                             'electric-indent-functions
                             last-command-event)
                            (memq last-command-event electric-indent-chars))))
               (not
                (or (memq act '(nil no-indent))
                    ;; In a string or comment.
                    (unless (eq act 'do-indent) (nth 8 (syntax-ppss))))))))
      ;; For newline, we want to reindent both lines and basically behave like
      ;; reindent-then-newline-and-indent (whose code we hence copied).
      (let ((at-newline (<= pos (line-beginning-position))))
        (when at-newline
          (let ((before (copy-marker (1- pos) t)))
            (save-excursion
              (unless (or (memq indent-line-function
                                electric-indent-functions-without-reindent)
                          electric-indent-inhibit)
                ;; Don't reindent the previous line if the indentation function
                ;; is not a real one.
                (goto-char before)
                (indent-according-to-mode))
              ;; We are at EOL before the call to indent-according-to-mode, and
              ;; after it we usually are as well, but not always.  We tried to
              ;; address it with `save-excursion' but that uses a normal marker
              ;; whereas we need `move after insertion', so we do the
              ;; save/restore by hand.
              (goto-char before))))
        (unless (and electric-indent-inhibit
                     (not at-newline))
          (indent-according-to-mode))))))
(eval-after-load 'electric '(fset 'electric-indent-post-self-insert-function 'my/electric-indent-post-self-insert-function))



(use-package prescient
  :config
  (setq prescient-filter-method '(literal)))
(use-package vertico
  :config (vertico-mode))
(use-package vertico-prescient
  :config (vertico-prescient-mode))
(use-package savehist
  :config (savehist-mode))
(use-package marginalia
  :config (marginalia-mode))
(use-package consult)
(general-define-key
 "C-x b" 'consult-buffer
 "C-x C-b" 'consult-buffer)
(setq consult-buffer-filter '("\\` .*" "\\`\\*[^Ms].*\\*"))

(use-package helpful
  :bind (([remap describe-key] . helpful-key)
         ([remap describe-command] . helpful-command)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-function] . helpful-callable)))

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 2))




(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; TODO: css support


;; (desktop-save-mode 1)
;; (setq desktop-load-locked-desktop 'check-pid)
;; (setq desktop-save 'if-exists)
;; (setq desktop-auto-save-timeout 3)
;; (setq desktop-restore-frames nil)

;; (set-frame-size (selected-frame) 90 30)
(setq initial-frame-alist 
   '(
   ;; '((top . 50)        ; pixels from top of screen
     ;; (left . 100)      ; pixels from left
     (width . 90)     ; in characters
     (height . 30)     ; in characters
   )
) ; no title bar/borders if supported

;; (use-package vterm
;;   :config
;;   (split-window-right)
;;   (other-window 1)
;;   (vterm)
;;   (other-window 1)
;; )

(setq-default truncate-lines nil)



;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved obsolete)
;; End:
