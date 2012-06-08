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

(defvar *emacs-init-start-time* (current-time))
(message ">>> *** STARTING EMACS INIT (with prelude) ***")

;; On OS X Emacs doesn't use the shell PATH if it's not started from
;; the shell. If you're using homebrew modifying the PATH is essential.
(if (eq system-type 'darwin)
    (push "/usr/local/bin" exec-path))

(defvar prelude-dir (file-name-directory load-file-name)
  "The root dir of the Emacs Prelude distribution.")
(defvar prelude-modules-dir (concat prelude-dir "modules/")
  "This directory houses all of the built-in Prelude module. You should
avoid modifying the configuration there.")
(defvar prelude-vendor-dir (concat prelude-dir "vendor/")
  "This directory house Emacs Lisp packages that are not yet available in
ELPA (or Marmalade).")
(defvar prelude-personal-dir (concat prelude-dir "personal/")
  "Users of Emacs Prelude are encouraged to keep their personal configuration
changes in this directory. All Emacs Lisp files there are loaded automatically
by Prelude.")

(add-to-list 'load-path prelude-modules-dir)
(add-to-list 'load-path prelude-vendor-dir)
(add-to-list 'load-path prelude-personal-dir)

(defconst personal-init-file (concat prelude-personal-dir "init.el"))
(defconst custom-file (concat prelude-personal-dir "custom.el"))

(defun xxpdkl-require (feature)
      (progn
        (message  ">>> LOAD: %s" feature)
        (if (stringp feature)
            (load-library feature)
          (require feature))
        (message (format ">>> LOAD: %s <success>" feature)))
)
(defun pdkl-require (feature)
  "Same as require, but with some debug output"
  (condition-case err
      (progn
        (message  ">>> LOAD: %s" feature)
        (if (stringp feature)
            (load-library feature)
          (require feature))
        (message (format ">>> LOAD: %s <success>" feature)))
      ('error (progn
          (message (format ">>> *** FAILURE IN LOAD: %s ***" feature))
          (message (format ">>> *** ERROR WAS: %s ***" err))
      ))
    nil))

(message ">>> customizer settings: %s" custom-file)

;; the core stuff
;(require 'prelude-packages)
(pdkl-require 'prelude-packages)
(pdkl-require 'prelude-el-get)
(pdkl-require 'prelude-ui)
(pdkl-require 'prelude-core)
(pdkl-require 'prelude-editor)
(pdkl-require 'prelude-global-keybindings)

;; programming & markup languages support
(pdkl-require 'prelude-programming)
;;(pdkl-require 'prelude-c)
;;(pdkl-require 'prelude-clojure)
(pdkl-require 'prelude-coffee)
(pdkl-require 'prelude-common-lisp)
(pdkl-require 'prelude-emacs-lisp)
(pdkl-require 'prelude-erc)
(pdkl-require 'prelude-groovy)
;;(pdkl-require 'prelude-haskell)
(pdkl-require 'prelude-js)
;;(pdkl-require 'prelude-latex)
(pdkl-require 'prelude-markdown)
(pdkl-require 'prelude-perl)
;;(pdkl-require 'prelude-python)
(pdkl-require 'prelude-ruby)
;;(pdkl-require 'prelude-scheme)
(pdkl-require 'prelude-xml)

(load custom-file)

;; load the personal settings
(when (file-exists-p prelude-personal-dir)
  ;;(mapc 'load (directory-files prelude-personal-dir nil "^[^#].*el$"))
  (load personal-init-file))

(defvar *emacs-init-end-time* (current-time))
(message ">>> init.el -  START: %s" (current-time-string *emacs-init-start-time*))
(message ">>> init.el - FINISH: %s" (current-time-string *emacs-init-end-time*))
(message ">>> init.el - seconds elapsed: %ds"
         (destructuring-bind (hi lo ms) *emacs-init-end-time*
           (- (+ hi lo)
              (+ (first *emacs-init-start-time*)
                 (second *emacs-init-start-time*)))))
;;; init.el ends here
(put 'ido-exit-minibuffer 'disabled nil)
(put 'overwrite-mode 'disabled nil)
