# Nix configuration — agent guide

Flake for my NixOS hosts and Home Manager configurations. Run every command from this
directory (`~/dotfiles/nix`) and prefer the Makefile targets over raw `nix`/`nh` commands.

## Layout

- `flake.nix` — inputs, `nixosConfigurations` and `homeConfigurations`
- `hosts/<host>/` — per-host `configuration.nix` (NixOS), `home.nix` (Home Manager),
  `hardware-configuration.nix`
- `modules/home-manager/` — shared Home Manager modules (`cli.nix`, `gui.nix`)
- `modules/nixos/` — shared NixOS modules (`base.nix`, `common.nix`, `physical.nix`,
  `live-iso.nix`)
- `pkgs/` — custom packages; `overlays.nix` — overlays applied to `pkgs`
- `docs/` — notes on known pitfalls (e.g. `docs/stale-home-manager-links.md`)

## Testing changes

Validate every change with a build, never with a switch:

- `make test-home` — builds the Home Manager config for the current host
- `make test-os` — builds the NixOS config for the current host

Run `test-home` for changes under `modules/home-manager/` or `hosts/*/home.nix`, `test-os`
for `modules/nixos/` or `hosts/*/configuration.nix`, and both when touching `flake.nix`,
`overlays.nix` or `pkgs/`.

Both targets pick the configuration matching the local hostname. To check another host,
call nh directly with the same flags as the Makefile:

- `nh home build . --show-activation-logs --no-build-output -c jemag@<host>`
- `nh os build . --no-build-output -H <host>`

Do not pass `-o`/`--out-link` to these: without it nh links the result into a temp dir and
leaves nothing behind.

New files must be tracked by git before the flake can see them (`git add -N <file>` is
enough). Otherwise evaluation fails with "path does not exist" or silently ignores the file.

## Never run

- `make home`, `make os`, `make all`, or any `nh home switch` / `nh os switch` /
  `nixos-rebuild switch|boot|test` / `home-manager switch` — I apply changes myself.
- `make clean` / `nix-collect-garbage` — deletes generations.
- `make update` / `nix flake update` / `nix flake lock --update-input` — only when I ask.
  Changes to `flake.lock` must be deliberate.
- `git commit` — I commit myself.

## Other build or eval commands

Prefer `make test-home` / `make test-os`. If you need something narrower (evaluating one
option, building one package from `pkgs/`), keep it artifact-free:

- Evaluate instead of build where possible:
  `nix eval .#nixosConfigurations.<host>.config.<option>`,
  `nix eval .#homeConfigurations."jemag@<host>".config.<option>`
- When you must build, add `--no-link` (`nix build --no-link .#...`), or use `--dry-run`
  to only check what would be built.
- Never leave `result`, `result-*` or other out-links in the repo. If one gets created,
  remove it before finishing (`rm result*` — check it is a symlink first).
- Put any scratch files outside the repo, not in this directory.
