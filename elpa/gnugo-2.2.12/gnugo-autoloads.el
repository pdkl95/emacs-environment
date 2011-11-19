;;; gnugo-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (gnugo) "gnugo" "gnugo.el" (20167 12870))
;;; Generated autoloads from gnugo.el

(autoload 'gnugo "gnugo" "\
Run gnugo in a buffer, or resume a game in progress.
Prefix arg means skip the game-in-progress check and start a new
game straight away.

You are queried for additional command-line options (Emacs supplies
\"--mode gtp --quiet\" automatically).  Here is a list of options
that gnugo.el understands and handles specially:

    --boardsize num   Set the board size to use (5--19)
    --color <color>   Choose your color ('black' or 'white')
    --handicap <num>  Set the number of handicap stones (0--9)

If there is already a game in progress you may resume it instead of
starting a new one.  See `gnugo-board-mode' documentation for more info.

\(fn &optional NEW-GAME)" t nil)

;;;***

;;;### (autoloads nil nil ("gnugo-pkg.el") (20167 12871 25491))

;;;***

(provide 'gnugo-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gnugo-autoloads.el ends here
