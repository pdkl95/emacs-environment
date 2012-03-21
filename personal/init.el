;;;(load-theme 'pdklburn t)
;;; MOVED TO PRELUDE INIT!!!

;; everything is now being split
;; into topic-specific files

(message "local-init: BEGIN")

(require 'pdkl-init-globals)
(require 'pdkl-server)
(require 'pdkl-defuns)
(require 'pdkl-tramp)
(require 'pdkl-bindings)
(require 'pdkl-mode-hooks)
(require 'pdkl-ccmode)

(message "local-init: END")
