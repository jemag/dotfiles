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

## Screenshots

Neovim + tmux
![image](https://user-images.githubusercontent.com/7985687/210149936-07787e45-082f-4360-903f-fc3e505d3947.png)
![image](https://user-images.githubusercontent.com/7985687/210150012-7cade9cb-7192-4446-96bb-1c3e17d426b4.png)
