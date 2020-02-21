# seed

Create a development environment using a single sexp.

Get setup by downloading Emacs from https://www.gnu.org/software/emacs/

Once open, use M-x eval-expression and paste this in:

```
(url-copy-file
	"https://raw.githubusercontent.com/mikepjb/seed/master/init.el"
	user-init-file t)
```

## Trouble?

If you're trying to download packages you may get a message about RSA signatures, take the hash in the message and use the following command:
`gpg --homedir ~/.emacs.d/elpa/gnupg --receive-keys <RSA key hash in output>`

