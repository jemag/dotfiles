# Dotfiles
 My personal dotfiles.

## Management

Everything is currently managed through [stow](https://www.gnu.org/software/stow/manual/stow.html), hence the current folder hierarchy. To add dotfiles in their proper location, make sure they do not already exist in that location and then simply run the command:

```bash
stow {folder_name}
```

 For example:
```bash
stow neovim
```
 
To remove dotfiles, you can simply use:
```bash
 stow -D {folder_name}
```
This allows keeping the dotfiles properly in the git repo while creating symlinks to the expected location by their respective program.
