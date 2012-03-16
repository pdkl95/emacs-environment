;;;(load-theme 'pdklburn t)
;;; MOVED TO PRELUDE INIT!!!

(message "local-init: BEGIN")


;;;;;;;;;;;;;;;;;;;;;
;; GLOBAL SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;

(setq debug-on-error t)
(fset 'yes-or-no-p 'y-or-n-p)

;; re-enabling disabled stuff
(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)
;; ...and disable some of the VERY annoying stuff
(put 'overwrite-mode 'disabled t)


(add-hook 'before-save-hook 'time-stamp)

;; global minor modes
(menu-bar-mode)
(global-rainbow-delimiters-mode)
(smex-initialize)

(require 'volatile-highlights)
(volatile-highlights-mode t)

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)


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
    '(diminish 'abbrev-mode "Ab")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              MISC FUNCTIONS                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun insert-date ()
  "Insert a time-stamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
          "ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))


;; force all scripts to be executable when saving
(add-hook
  'after-save-hook
  '(lambda ()
    (progn
      (and (save-excursion
          (save-restriction
            (widen)
            (goto-char (point-min))
            (save-match-data
              (looking-at "^#!"))))
        (shell-command (concat "chmod u+x " buffer-file-name))
        (message (concat "Saved as script: " buffer-file-name))
        ))))


(defun popup-yank-menu ()
  (interactive)
  (popup-menu 'yank-menu))

;; easy 'make'
(defun save-all-and-compile ()
  (save-some-buffers 1)
  (sleep-for  ;; let us fall slightly out of sync with
   0.5)       ;; that save for the sake of Makefiles
  (compile compile-command))

;; ignore results from make on success
(defun compilation-exit-autoclose (status code msg)
  (when (and (eq status 'exit)
             (zerop code))
    (bury-buffer)
    (delete-window (get-buffer-window (get-buffer "*compilation*"))))
  ;; Always return the anticipated result of compilation-exit-message-function
  (cons msg code))

(setq compilation-exit-message-function 'compilation-exit-autoclose)
;;(setq compilation-exit-message-function nil)



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
          (if (and (not (region-active-p))
                   (not (looking-at "[ \t]*$")))
              (comment-or-uncomment-region
               (line-beginning-position)
               (line-end-position))
            (comment-dwim arg)))

;; fix some pre Prelude's idiotic settings...
(defun prelude-prog-mode-hook ()
  "Default coding hook, useful with any programming language. (overridden)"
  ;;(flyspell-prog-mode)
  ;;(prelude-local-comment-auto-fill)
  ;; #'(lambda () (projectile-mode))
  ;;(prelude-turn-on-whitespace)
  (prelude-turn-on-abbrev)
  (prelude-add-watchwords)
  ;;(electric-pair-mode -1) ;; removed in prelude
  (add-hook 'before-save-hook 'whitespace-cleanup nil t))


(defun prelude-turn-on-flyspell ()
  (message "prelude-turn-on-flyspell hack-workaround called!"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               KEY BINDINGS                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq keybinding '("<up>" 'foo))

;; stupid must-have-my-way-only attitude in Prelude,
;; at leat for the arrow keys
(mapc (lambda (keybinding)
        (let ((args (list (read-kbd-macro (car keybinding))
                          (car (cdr keybinding)))))
          (apply 'global-set-key args)))
      '(("<up>"        previous-line)
        ("<down>"      next-line)
        ("<left>"      left-char)
        ("<right>"     right-char)
        ("M-x"         smex)
        ("M-X"         smex-major-mode-commands)
        ("M-;"         comment-dwim-line)
        ("C-c y"       popup-yank-menu)
        ("C-c s"       save-all-and-compile)
        ("C-c C-c M-x" execute-extended-command)
        ("C-x C-k"     kill-some-buffers)
        ("C-x C-M-k"   kill-matching-buffers)
        ))

;; C-+ is normally set to increase the font size, which is
;; something I /always/ keep constant. So After one to many
;; stupid failures related t that it's geting rebound to another
;; 'undo key, which is usually what I wnted to do with with C-_
;; when I mistype and hit this atything
(global-set-key (kbd "C-+") 'undo)


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
                (define-key coffee-mode-map
                  (kbd "C-c C-c C-c") 'coffee-compile-file)
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
                (setq ruby-deep-arglist t)
                (setq ruby-deep-indent-paren nil)
                ;; (flymake-ruby-load)
                ;; (setq flymake-ruby-executable "/home/endymion/.rbenv/versions/1.9.3-p0-perf/bin/ruby")
                )


;;;;;;;;;;;;;;;;;
;;  SASS-MODE  ;;
;;;;;;;;;;;;;;;;;

(pdkl-hook-mode sass/
                (require 'flymake-sass)
                (electric-indent-mode -1)
                (flymake-sass-load))

;;;;;;;;;;;;;;;;;
;;  HAML-MODE  ;;
;;;;;;;;;;;;;;;;;

(pdkl-hook-mode haml
                (setq indent-tabs-mode nil)
                (electric-indent-mode -1)
                ;; this fix looks suspiciously related to the <return>
                ;; key's indent in coffee-mode
                (define-key haml-mode-map "\C-m" 'newline-and-indent))


;;;;;;;;;;;;;;;;;;;;;;;
;;  EMACS-LISP-MODE  ;;
;;;;;;;;;;;;;;;;;;;;;;;

(pdkl-hook-mode emacs-lisp
                ;;(disable-paredit-mode)
                (paredit-mode -1)
                (setq mode-name "el")
                ;;(setq (make-local-variable 'rebox-style-loop) '(525 517 521))
                ;;(setq (make-local-variable 'rebox-min-fill-column 40))
                ;;(rebox-mode 1)
                )



;; done...
(message "local-init: END")
