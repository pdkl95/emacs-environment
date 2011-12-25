Emacs Reconstruction
====================

Early NOV-2011, I unfortunately suffered the Great Emacs Apocalypse, and
wiped out my entire `~/.emacs.d` due to a rather serious mistake on my
part.

### Important lesson

It doesn't matter how good you get BASH, and how
efficient your are at the shell... if your command involves insane stuff like
a powerful features like `find` combined with `xargs`, it's _incredibly_
important to sit on your hand for a bit and re-read your work before
hitting `<enter>`. Prefix all the actions with `echo` and make sure they
really generate as what you _thought_ it would generate as. Work in a
sandbox-environment. Have other people check it for sanity. Anything.

Just don't ever assume that "meh... _it's probably right **this time**_"

Especially if you're like me and forgot to
[mount](http://www.catb.org/jargon/html/S/scratch-monkey.html) a
[scratch monkey](http://www.cs.utah.edu/~elb/folklore/scrtch.monkey).


Emacs Prelude
-------------

So in an effort to save a rather significant amount of time and sanity,
I am starting my reconstruction from
[Emacs Prelude](https://github.com/bbatsov/emacs-prelude).
(I forgot to fork it here when I started, unfortunately)

The master branch is following that with only a _few_ minor changes.
The main "primary" bran is therefore the `pdkl` branch instead, with
_most_ of the change from Prelude's base being in the `~/.emacs.d/personal/`
subdir.

It seems to being going decently for now, except for Emacs24 deciding to
forget which font to use all the time. Ann that nothing derived from c-mode
indents properly anymore.  Or.... or..

*&laquo;sigh&raquo;*

I suppose it'll be another decade before it get things back to the way
I had them...
