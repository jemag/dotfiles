# Harness capability mapping

This skill needs four capabilities. Tool names differ per harness; the protocol does not.

| Capability            | Claude Code                | opencode                  |
| --------------------- | -------------------------- | ------------------------- |
| Read a file           | `Read`                     | `read`                    |
| Search the tree       | `Grep` / `Glob`            | `grep` / `glob`           |
| Run a shell command   | `Bash`                     | `bash`                    |
| Spawn a subagent      | `Agent` (`subagent_type`)  | `task` (`subagent_type`)  |
| Broad subagent type   | `general-purpose`          | `general`                 |
| Read-only search type | `Explore`                  | `explore`                 |
| Task list             | `TodoWrite`                | `todowrite`               |

In an unlisted harness, map by capability, not by name.

## Degradations

- **No subagent tool** (or spawning denied): process chunks sequentially in the main loop.
  Coverage is unchanged; context pressure is worse. After each chunk, keep only its
  confirmed-candidate list and discard the rest of that chunk's context before starting the
  next. Say in the report that chunks were processed sequentially.
- **No task-list tool:** keep the `CHANGE-N` list in printed output and re-print it at Step 5
  with each item ticked. The coverage contract is the point; the tool is not.
- **No shell / not a git repo:** the user must name the files. Read them in full and skip
  Step 0's git plumbing, `git blame` (false-positive check 7), and range handling. Note the
  limitation in `GAPS`.
- **Extended reasoning:** Claude Code has `ultrathink`; elsewhere just reason deliberately
  before Step 6 rather than assuming a keyword exists.
- **Subagent findings are inputs, not verdicts.** Always re-run Step 6 centrally: a subagent
  cannot see a mitigation that lives in another chunk.
