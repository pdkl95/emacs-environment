;;;(load-theme 'pdklburn t)
;;; MOVED TO PRELUDE INIT!!!

(message "local-init: BEGIN")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; settings that are high level, but don't
;; really fit anywhere else
(menu-bar-mode)
(ido-yes-or-no-mode)
(smex-initialize)
(global-rainbow-delimiters-mode)

(require 'pretty-lambdada)
(pretty-lambda-for-modes)

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; running emacs itself...
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(setq frame-title-format
      '("emacs: "  (:eval (if (buffer-file-name)
                              (abbreviate-file-name (buffer-file-name))
                            "%b")) " [%*]"))

(when (require 'diminish nil 'noerror)
  (eval-after-load "company"
      '(diminish 'company-mode "Cmp"))
  (eval-after-load "abbrev"
    '(diminish 'abbrev-mode "Ab"))
  (eval-after-load "yasnippet"
    '(diminish 'yas/minor-mode "Y")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               KEY BINDINGS                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; stupid must-have-my-way-only attitude in Prelude,
;; at leat for the arrow keys
(global-set-key (kbd "<up>") 'previous-line)
(global-set-key (kbd "<down>") 'next-line)
(global-set-key (kbd "<left>") 'left-char)
(global-set-key (kbd "<right>") 'right-char)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(global-set-key (kbd "C-x C-k")   'kill-some-buffers)
(global-set-key (kbd "C-x C-M-k") 'kill-matching-buffers)

;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key "\C-cy" '(lambda () (interactive)
                           (popup-menu 'yank-menu)))

;; C-+ is normally set to increase the font size, which is
;; something I /always/ keep constant. So After one to many
;; stupid failures related t that it's geting rebound to another
;; 'undo key, which is usually what I wnted to do with with C-_
;; when I mistype and hit this atything
(global-set-key (kbd "C-+") 'undo)


;;(require 'drag-stuff)
;;(drag-stuff-global-mode t)
;;(add-to-list 'drag-stuff-except-modes 'conflicting-mode)
;;(setq drag-stuff-modifier '(meta shift))
;;(setq drag-stuff-modifier '(control))

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
   "Replacement for the comment-dwim command.
        If no region is selected and current line is not  blank and we
        are not at the end of the line, then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment
        at the end of the line."
          (interactive "*P")
          (comment-normalize-vars)
          (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
              (comment-or-uncomment-region (line-beginning-position) (line-end-position))
            (comment-dwim arg)))
(global-set-key "\M-;" 'comment-dwim-line)


;; fix some pre Prelude's idiotic settings...
(defun prelude-prog-mode-hook ()
  "Default coding hook, useful with any programming language. (overridden)"
  ;;(flyspell-prog-mode)
  ;;(prelude-local-comment-auto-fill)
  #'(lambda () (projectile-mode))
  ;;(prelude-turn-on-whitespace)
  (prelude-turn-on-abbrev)
  (prelude-add-watchwords)
  ;;(electric-pair-mode -1) ;; removed in prelude
  (add-hook 'before-save-hook 'whitespace-cleanup nil t))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                    MODE-SPECIFIC SECTIONS                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; make defining mode-specific settings easier
(defmacro pdkl-hook-mode (name &rest body)
  "Reduce some of the insane repetition making all these
mode hooks... with an even more insane macro."
  (let* ((hook   (intern (concat         (symbol-name name) "-mode-hook")))
         (myfunc (intern (concat "pdkl-" (symbol-name name) "-mode-hook"))))
    `(progn
       (defun ,myfunc ()
         (progn ,@body))
       (add-hook ',hook ',myfunc)
       )))


;;;;;;;;;;;;;;;;;;;;
;;  COFFEE-MODE   ;;
;;;;;;;;;;;;;;;;;;;;

(pdkl-hook-mode coffee
                (define-key coffee-mode-map (kbd "<ret>") 'newline)
                ;; at least until i can setup some file-optional save hook
                (define-key coffee-mode-map (kbd "C-c C-c C-c") 'coffee-compile-file)
                (electric-indent-mode -1))


;;;;;;;;;;;;;;;
;;  SH-MODE  ;;
;;;;;;;;;;;;;;;

(pdkl-hook-mode sh
                (require 'flymake-shell)
                (flymake-shell-load)
                '(lambda () (and buffer-file-name
                            (string-match "\\.sh\\'" buffer-file-name)
                            (sh-set-shell "bash"))))

;;;;;;;;;;;;;;;;;
;;  RUBY-MODE  ;;
;;;;;;;;;;;;;;;;;

(pdkl-hook-mode ruby
                (flymake-ruby-load))


;;;;;;;;;;;;;;;;;
;;  SASS-MODE  ;;
;;;;;;;;;;;;;;;;;

(pdkl-hook-mode sass
                (require 'flymake-sass)
                (flymake-sass-load))

;;;;;;;;;;;;;;;;;
;;  HAML-MODE  ;;
;;;;;;;;;;;;;;;;;

(pdkl-hook-mode haml
                (setq indent-tabs-mode nil)
                ;; this fix looks suspiciously related to the <return>
                ;; key's indent in coffee-mode
                (define-key haml-mode-map "\C-m" 'newline-and-indent))


;;;;;;;;;;;;;;;;;;;;;;;
;;  EMACS-LISP-MODE  ;;
;;;;;;;;;;;;;;;;;;;;;;;

(pdkl-hook-mode emacs-lisp
                ;;(disable-paredit-mode)
                (paredit-mode -1)
                (setq mode-name "el"))





;; done...
(message "local-init: END")
(setq debug-on-error t)
