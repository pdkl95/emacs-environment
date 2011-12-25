(load-theme 'pdklburn t)

(menu-bar-mode)
(ido-yes-or-no-mode)
(smex-initialize)
(global-rainbow-delimiters-mode)

(require 'pretty-lambdada)
(pretty-lambda-for-modes)

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


;;(require 'flymake-shell)
;;(add-hook 'sh-set-shell-hook 'flymake-shell-load)
;;(require 'flymake-sass)
;;(add-hook 'sass-shell-hook 'flymake-sass-load)
;;(add-hook 'coffee-mode-hook 'flymake-coffee-load)

;; try and set sh-mode's subtype to bash by default
(add-hook 'sh-mode-hook
  '(lambda () (and buffer-file-name
   (string-match "\\.sh\\'" buffer-file-name)
     (sh-set-shell "bash"))))

(defun prelude-prog-mode-hook ()
  "Default coding hook, useful with any programming language. (overridden)"
  ;;(flyspell-prog-mode)
  ;;(prelude-local-comment-auto-fill)
  (prelude-turn-on-whitespace)
  (prelude-turn-on-abbrev)
  (prelude-add-watchwords)
  (add-hook 'before-save-hook 'whitespace-cleanup nil t))

(defun pdkl-coffee-mode-hook ()
  "personal overrides for coffee-mode"

  (electric-indent-mode -1)
  ;; newline-and-indent gets it wrong here
  ;;(define-key coffee-mode-map "\C-m" 'newline)
  )
(add-hook 'coffee-mode-hook 'pdkl-coffee-mode-hook)

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
2
(global-set-key "\M-;" 'comment-dwim-line)

(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))


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

(add-hook 'emacs-lisp-mode-hook
  (lambda()
    (setq mode-name "el")))
