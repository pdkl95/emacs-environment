(load-theme 'pdklburn t)

(menu-bar-mode)

(defun prelude-coding-hook ()
  "Default coding hook, useful with any programming language. (overridden)"
  ;;(flyspell-prog-mode)
  ;;(prelude-local-comment-auto-fill)
  (prelude-turn-on-whitespace)
  (prelude-turn-on-abbrev)
  (prelude-add-watchwords))

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
