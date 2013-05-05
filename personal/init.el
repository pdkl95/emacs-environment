;;;(load-theme 'pdklburn t)
;;; MOVED TO PRELUDE INIT!!!

;; everything is now being split
;; into topic-specific files

(message "local-init: BEGIN")

(require 'pdkl-init-globals)
(require 'pdkl-server)
(require 'pdkl-defuns)
(require 'pdkl-tramp)
(require 'pdkl-modes)
(require 'pdkl-hooks)
(require 'pdkl-ccmode)
(require 'pdkl-org)
(require 'pdkl-bindings)

(message "local-init: END")
