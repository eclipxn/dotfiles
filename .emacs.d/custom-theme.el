(require 'autothemer)

(autothemer-deftheme awu^2 "awu^2"
                     ((((class color) (min-colors #xFFFFFF)))
                      ;; (bg "#302b40")
                      ;; (bg "#1d203a")
                      (bg "#1c1c31")
                      ;; (text "#e7dfee")
                      (text "#cbd5f6")
                      (select "#303355")
                      (comment "#62698d")
                      (str "#acfab5")
                      (func "#93e5e0")
                      (num "#94b1ff")
                      (keyword "#da96ff")
                      (type "#ff8dd7")
                      (hl "#515576")
                      (border "#2d2f48")
                      )

                     ;; Customize faces
                     ((default (:foreground text :background bg))
                      (tree-sitter-hl-face:property (:slant 'normal :inherit 'default))
                      (tree-sitter-hl-face:operator (:inherit 'default))
                      (font-lock-variable-name-face (:foreground nil))

                      (font-lock-comment-face (:foreground comment))

                      (font-lock-string-face (:foreground str))

                      (font-lock-keyword-face (:foreground keyword))
                      (tree-sitter-hl-face:variable.builtin (:inherit 'font-lock-keyword-face))

                      (font-lock-builtin-face (:foreground type))
                      (font-lock-constant-face (:foreground type))
                      (font-lock-type-face (:foreground type))

                      (font-lock-function-name-face (:foreground func))
                      (font-lock-function-call-face (:inherit 'font-lock-function-name-face))
                      (tree-sitter-hl-face:function.call (:inherit 'font-lock-function-name-face))

                      (font-lock-number-face (:foreground num))
                      (highlight-numbers-number (:inherit 'font-lock-number-face))
                      (tree-sitter-hl-face:number (:inherit 'font-lock-number-face))

                      (preview-face (:background nil))
                      (font-latex-math-face (:inherit 'font-lock-string-face :foreground nil))
                      (font-latex-verbatim-face (:inherit 'font-latex-math-face :foreground nil))
                      (font-latex-warning-face (:inherit 'font-lock-keyword-face :foreground nil))
                      (font-latex-script-char-face (:inherit 'font-lock-keyword-face :foreground nil))

                      (region (:background select))
                      (hl-line (:background "#2d2f48"))

                      (highlight (:background hl))
                      (ivy-current-match (:inherit 'highlight))
                      (lsp-ui-doc-highlight-hover (:inherit 'highlight))
                      (show-paren-match (:inherit 'highlight))
                      (show-paren-mismatch (:foreground "#ff0000" :background nil))

                      (lazy-highlight (:inherit 'highlight))
                      (isearch (:background "#5fb0aa"))
                      (match (:background "#6fb076"))
                      (isearch-fail (:background "#cc5aa4"))
                      (ivy-minibuffer-match-face-1 (:inherit 'swiper-match-face-1))
                      (ivy-minibuffer-match-face-2 (:inherit 'swiper-match-face-2))
                      (ivy-minibuffer-match-face-3 (:inherit 'swiper-match-face-3))
                      (ivy-minibuffer-match-face-4 (:inherit 'swiper-match-face-4))

                      (fringe (:background bg))
                      (minibuffer-prompt (:foreground func))
                      (link (:foreground keyword :underline t))
                      (button (:foreground keyword))
                      (line-number (:foreground "#979cc1"))
                      (linum (:inherit 'line-number
                            :background bg))

                      (vertical-border (:foreground border))
                      (custom-button (:foreground keyword :box nil :background border))

                      (mode-line (:foreground text :background "#8f3f8d"))
                      (mode-line-inactive (:foreground text :background "#5c5c5c"))

                      (lsp-ui-doc-background (:background "#2c263f"))

                      (company-tooltip (:background "#2c263f"))
                      (company-tooltip-selection (:background "#3a3252"))
                      (company-tooltip-mouse (:background "#433a59"))
                      ))

(provide-theme 'awu^2)
