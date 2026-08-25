# Fixing stale Home Manager symlinks

## The problem

When a `home.file` entry is narrowed from a whole directory to individual files inside it, Home
Manager leaves the old directory symlink in place. Every subsequent switch silently does nothing,
so the config keeps behaving the way it did before the change.

Concretely, going from:

```nix
".config/foo" = {
  source = config.lib.file.mkOutOfStoreSymlink ".../dotfiles/foo/.config/foo";
};
```

to:

```nix
".config/foo/bar.json" = { source = ...; };
".config/foo/baz"      = { source = ...; };
```

leaves `~/.config/foo` as a symlink into an old generation, and the new per-file links are never
created.

## Why HM does not clean it up

`cleanOldGen` runs a script that checks each entry of the previous generation:

```bash
if [[ -e "$newGenFiles/$relativePath" ]] ; then
  verboseEcho "Checking $targetPath: exists"      # <-- skips deletion
```

The old entry `.config/foo` *does* still exist in the new generation — as a **directory** rather
than a symlink — so the check passes and the stale link is never removed. HM has no notion of
"was a link, is now a directory".

`linkNewGen` cannot recover from that. It sees the parent `~/.config/foo` is a symlink, routes the
new entries to its slow path, and resolves them *through* the stale link into the dotfiles
directory. Files whose content already matches hit a `cmp -s` check and are skipped; directories
fail on `ln -Tsf`. Either way nothing lands where it should, and the switch reports success.

## Detecting it

Compare every live link in `$HOME` against the active generation. Prints nothing when clean:

```bash
GEN=$(readlink -f ~/.local/state/nix/profiles/home-manager/home-files)
cd "$GEN" && find . \( -type f -o -type l \) -printf '%P\n' | while read -r p; do
  [[ "$(readlink "$HOME/$p" 2>/dev/null)" == "$GEN/$p" ]] || echo "STALE: $p"
done
```

Any `STALE:` line means the live path is missing, is a plain file, or points somewhere other than
the current generation. A group of stale entries sharing one parent directory is the signature of
this bug — check that parent with `ls -ld ~/.config/<parent>`; if it is a symlink into
`/nix/store/…-home-manager-files/`, this runbook applies.

## The fix

**Removing the symlink does not touch the files it points to.** `rm` never follows a symlink, so
`rm ~/.config/foo` unlinks only the link itself and everything stays in `~/dotfiles/…`. Do not add
a trailing slash and do not use `-r` — either one would make `rm` operate on the target directory.

1. **Stash anything worth keeping.** While the stale link was in place, the program wrote its
   runtime state into the dotfiles directory instead of `~/.config`. Copy out whatever should
   survive:

   ```bash
   mkdir -p /tmp/hm-stash
   cp -a ~/dotfiles/<pkg>/.config/<name>/<runtime-bits> /tmp/hm-stash/
   ```

   Skip anything the program regenerates on its own (`node_modules/`, lockfiles, plugin files that
   declare themselves auto-installed).

2. **Remove the stale link:**

   ```bash
   rm ~/.config/<name>
   ```

3. **Switch.** Home Manager now creates a real directory with the per-file links:

   ```bash
   cd ~/dotfiles/nix && make switch
   ```

   On a host that has not switched since `programs.nh` was added, `nh` is not on `PATH` yet — use
   `home-manager switch --flake ~/dotfiles/nix` for that first run, then `make switch` afterwards.

4. **Restore the stashed files** into the new real directory:

   ```bash
   cp -a /tmp/hm-stash/<runtime-bits> ~/.config/<name>/
   ```

5. **Clean the orphans out of the dotfiles working copy.** They are untracked or gitignored, so
   deleting them on one host does not propagate to the others through git:

   ```bash
   cd ~/dotfiles
   git clean -ndx <pkg>/     # review first
   git clean -fdx <pkg>/
   ```

   `-x` is required — the local `.gitignore` hides most of the junk from a plain `git clean`.
   Tracked files are never removed.

6. **Verify** with the detector above; it should print nothing. Then launch the program and confirm
   it still picks up its config, and re-run the detector once more to confirm it does not write
   back into dotfiles.

## Known instance: `.config/opencode`

`8ccd91b5` (2026-08-23) narrowed `.config/opencode` to three per-file links (`agents`,
`opencode.jsonc`, `tui.json`) in `modules/home-manager/cli.nix`, to stop opencode dumping
`node_modules/`, `plugins/` and router state into the repo.

| Host | Status |
| --- | --- |
| `WSQCIML9115246` (work) | fixed 2026-08-25 |
| `desktop` | pending |
| `thinkpad` | pending |
| `laptop` | pending |
| `homelab` | pending |
| `nixvm` | pending |

On a pending host the detector reports:

```
STALE: .config/opencode/opencode.jsonc
STALE: .config/opencode/agents
STALE: .config/opencode/tui.json
```

Run the steps above with `<name>` = `opencode` and `<pkg>` = `opencode`. Nothing needs stashing on
the non-work hosts:

- `plugins/herdr-agent-state.js` declares `// managed by herdr; reinstalling or updating the
  integration overwrites this file` and is reinstalled into the new `~/.config/opencode/plugins/`.
- `opencode-model-router.state.json` holds two fields and only the work host runs the router — its
  plugin activation lives in `hosts/work/home.nix`.
- `node_modules/`, `package.json`, `package-lock.json` and `bun.lock` are regenerated by opencode on
  next launch.

The four tracked files under `opencode/` survive `git clean -fdx`: `agents/teacher.md`,
`opencode.jsonc`, `tui.json`, and `opencode-model-router-tiers.json`.