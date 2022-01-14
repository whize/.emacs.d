# .emacs.d

I used to use the doom emacs. But I rebuild the emacs environment because I want to make it simple.  
(i use doom-theme (doom-one) and doom-modeline. i like that!)  


## Preparation

### Install emacs

I use Mac so I installed [emacs-mac](https://github.com/railwaycat/homebrew-emacsmacport) with options as below.

``` shell
$ brew tap railwaycat/emacsmacport
$ brew install emacs-mac --with-dbus --with-ctags --with-no-title-bars --with-emacs-sexy-icon
```

### Install Font

Download [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode)  
and I set ligatures setting.

### Install all the icon

After launching emacs at first, install the all the icon.

``` shellsession
M-x all-the-icons-install-fonts
```

## Install go modules for go-mode

install modules for using "go-mode".

``` shell
$ go install golang.org/x/tools/gopls@latest
$ go install golang.org/x/tools/cmd/goimports@latest
$ go install golang.org/x/tools/cmd/guru@latest
```

## Execute batch_byte_compile.sh after editing init.el

``` shell
$ cd ~/.emacs.d
$ ./batch_byte_compile.sh
```

Restart emacs.

```
M-x restart-emacs
```

...(I'll add.)
