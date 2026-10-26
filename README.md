# Dotfiles

My personal dotfiles.

## Layout

- `<program>/` — config for one program, mirroring the paths under `$HOME`
- `nix/` — Nix flake for my NixOS hosts and Home Manager configs (see [`nix/AGENTS.md`](nix/AGENTS.md))
- `non-stow/` — files installed by hand

## Usage

**Nix hosts:** Home Manager symlinks the config folders. From `nix/`:

```bash
make home   # apply Home Manager config
make os     # apply NixOS config
```

**Other hosts:** use [stow](https://www.gnu.org/software/stow/manual/stow.html):

```bash
stow neovim      # link
stow -D neovim   # unlink
```

## Screenshots

Neovim + tmux
![image](https://user-images.githubusercontent.com/7985687/210149936-07787e45-082f-4360-903f-fc3e505d3947.png)
![image](https://user-images.githubusercontent.com/7985687/210150012-7cade9cb-7192-4446-96bb-1c3e17d426b4.png)
