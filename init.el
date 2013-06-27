;;; init.el --- Emacs Prelude: configuration entry point.
;;
;; Copyright (c) 2011 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar.batsov@gmail.com>
;; URL: http://www.emacswiki.org/cgi-bin/wiki/Prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file simply sets up the default load path and requires
;; the various modules defined within Emacs Prelude.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'cl)

(defconst *emacs-init-start-time* (current-time))
(message ">>> *** STARTING EMACS INIT (with prelude) ***")

;; On OS X Emacs doesn't use the shell PATH if it's not started from
;; the shell. If you're using homebrew modifying the PATH is essential.
;;(if (eq system-type 'darwin)
;;    (push "/usr/local/bin" exec-path))

(defconst emacs-root-dir
  (file-name-directory load-file-name)
  "Path to the current .emacs.d/")
(defconst vendor-dir
  (concat emacs-root-dir "vendor/")
  "misc vendor .el files")
(defconst personal-dir
  (concat emacs-root-dir "personal/")
  "personal init files")
(defconst custom-themes-dir
  (concat emacs-root-dir "themes/")
  "Path to where themes will be loaded")
(defconst personal-init-file
  (concat personal-dir "init.el")
  "File that loads the majority of the personal stuff, after the
standard emacs, elpa, and vendor tools are loaded.")
(defconst custom-file
  (concat personal-dir "custom.el")
  "File where all of the 'customize' settings should be saved.")

(defun fmt-msg (str &rest args)
  (message (apply 'format str args)))

(defun pdkl-info (str &rest args)
  (fmt-msg (concat ">>> " str) args))
(defun pdkl-warn (str &rest args)
  (fmt-msg (concat ">>> !!! " str) args))
(defun pdkl-error (str &rest args)
  (fmt-msg (concat ">>> *** " str " ***") args))

(add-to-list 'load-path vendor-dir)
(add-to-list 'load-path personal-dir)

(add-to-list 'custom-theme-load-path custom-themes-dir)

;; keep track of what libs are missing
(setq missing-packages-list '())

;; attempt to load a feature/library, failing silently
(defmacro try-require (feature &rest forms)
  "Wrapper around 'require' that never fails due to missing packages"
  `(progn
    (if (require ,feature nil t)
      (progn ,@forms)
      (add-to-list 'missing-packages-list ,feature 'append))))

;; exchange one major-mode for another in an alist,
;; without duplicating the entry or touching the regex
(defun replace-alist-mode (alist oldmode newmode)
  (dolist (aitem alist)
    (if (eq (cdr aitem) oldmode)
	(setcdr aitem newmode))))


(defun autoload-mode (name &optional regex file)
  "Automatically loads a language mode
when opening a file of the appropriate type.

`name' is the name of the mode.
E.g. for javascript-mode, `name' would be \"javascript\".

`regex' is the regular expression matching filenames of the appropriate type.

`file' is the name of the file
from which the mode function should be loaded.
By default, it's \"`name'-mode.el\"."
    (let* ((name-mode  (concat name "-mode"))
           (name-sym   (intern name-mode))
           (name-regex (concat "\\." name "$")))
    (autoload name-sym (or file name-mode)
      (format "Major mode for editing %s." name) t)
    (add-to-list 'auto-mode-alist (cons (or regex name-regex) name-sym))))


;; loadable packages
(try-require 'package
  (add-to-list 'package-archives
    '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (package-initialize))

;; load the "customize" settings
(when (file-exists-p custom-file)
  (pdkl-info"customizer settings: %s" custom-file)
  (load custom-file))

;; load the personal settings
(when (file-exists-p personal-init-file)
  (pdkl-info "personal init.el: %s" personal-init-file)
  (load personal-init-file))

;; end init / init-time
(defconst *emacs-init-end-time* (current-time))
(pdkl-info "init.el -  START: %s" (current-time-string *emacs-init-start-time*))
(pdkl-info "init.el - FINISH: %s" (current-time-string *emacs-init-end-time*))

;(message ">>> init.el - seconds elapsed: %ds"
;         (destructuring-bind (hi lo ms) *emacs-init-end-time*
;           (- (+ hi lo)
;              (+ (first *emacs-init-start-time*)
;                 (second *emacs-init-start-time*)))))

(pdkl-info "*** END OF INITI")

;;; init.el ends here
