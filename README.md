# File System Navigation with ZSH

Adds functions and keybindings for easily navigating the file system.
Uses the _skim_ fuzzy finder.

To use it, add `zsh-fs-navigation` to the plugins array in your zshrc file:

```zsh
plugins=(... zsh-fs-navigation)
```

## Keyboard Shortcuts

| Shortcut                          | Description                                               |
|-----------------------------------|-----------------------------------------------------------|
| <kbd>Alt</kbd> + <kbd>Left</kbd>  | Go to previous sibling in FS tree                         |
| <kbd>Alt</kbd> + <kbd>Right</kbd> | Go to next sibling in FS tree                             |
| <kbd>Alt</kbd> + <kbd>Up</kbd>    | Go to parent directory                                    |
| <kbd>Alt</kbd> + <kbd>Down</kbd>  | Choose sub directory in current director                  |
