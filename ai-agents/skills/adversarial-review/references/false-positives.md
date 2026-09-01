# False-positive gate

Every candidate runs this gauntlet. **A candidate that fails any check is deleted** — not
downgraded, not hedged, not mentioned in passing. Reporting a false positive costs more than
missing a bug: it costs the reader's trust in the entire report.

## Evidence standard

> Prove the code path **exists** and its triggering conditions are **structurally possible**
> — not that they definitely execute on every run.

"Structurally possible" means you can point at code that produces the condition.
"Theoretically possible" and "a caller might" do not qualify.

## The checks

1. **Path exists.** Quote the call chain with `file:line` per link, from an entry point to the
   defect. If a link is "something calls this", the finding dies. Note any condition that
   blocks the path, and explain why it can be false.
2. **Bad outcome is concrete.** Name it: crash, hang, deadlock, corrupted data, wrong result,
   leak, security breach, outage. "This is fragile" is not an outcome. Give the steps to it.
3. **Full context was read.** You read the whole post-change function, its type definitions,
   and at least two levels of callers. If you only ever saw diff context lines, stop and go
   read the file.
4. **It is actually wrong.** Quote the commit message, comment, or `AGENTS.md` rule that shows
   intent. If the flagged behavior is the documented, deliberate intent with a stated
   tradeoff, it is not a regression — at most a design question, and only with a concrete cost.
5. **Multi-condition proof.** If the bug needs several conditions at once, prove they can hold
   *simultaneously on one path*. Independently possible is not jointly possible.
6. **Hallucination check.** Re-read the exact lines and quote them verbatim into the finding.
   Verify identifiers exist, arithmetic is right, and the function you claim is called is the
   one that is called (not a same-named method on a different type). Verify any rule you cite
   from a pattern file or from `AGENTS.md` actually says what you claim.
7. **Pre-existing?** Check `git blame` / the parent revision. If the defect predates the change
   and the change did not make it reachable or worse, it is not a regression from this change.
   Report separately, marked `PRE-EXISTING`, one line.
8. **Already handled elsewhere?** Grep for the validation, guard, or cleanup you think is
   missing — in the caller, in middleware, in a decorator, in a base class, in a schema
   validator, in the type system, in a database constraint, in a policy or admission
   controller. It is usually there.
9. **Repo rules check.** Does the repo's `AGENTS.md`/`CLAUDE.md` document this as intentional
   or known-safe? If so, drop it silently.
10. **Self-debate.** Write the strongest counterargument as if you were the change's author
    defending it. Then refute it with quoted code. **If you cannot refute it, the finding
    dies.** Do this in reasoning, not in the report.

## Standing false-positive classes

Do not report these without extraordinary evidence:

- **Defensive programming requests.** "Should validate / check for nil / handle this case",
  with no caller producing the bad input. Find the caller or drop it.
- **Hypothetical API misuse.** "If someone called this without the lock" — show the someone.
- **Error handling for impossible errors.** Show the operation can fail in a way that matters
  here.
- **Author claims as proof.** A comment saying it is safe is a claim to verify, never
  evidence. This cuts both ways: it is also not evidence of a bug.
- **Ordering changes with no consequence.** A reorder is a finding only if it creates a race,
  breaks a dependency, or changes observable behavior. Name which.
- **Races without a named pair.** Identify the two concurrent paths, the shared object, and the
  missing lock. Without all three, drop it.
- **Deliberate performance tradeoffs** stated in the commit message.
- **Style, naming, structure** — unless `--subjective` was requested.
- **Assignment mistaken for missing initialization.** A variable written before every read is
  initialized. Only flag reads.
- **Removal of assertions or debug-only checks.**
- **Test-only code**, unless it hides a production bug or breaks CI.
- **Missing feature.** "It would be better if it also did X" is not a regression.

## Final filter

Four yeses, or it does not ship:

1. Do I have proof, not suspicion?
2. Would an expert in this codebase recognize this as real?
3. Is it worth the author's time to read?
4. Is it a concrete bug rather than a request for defensive code?
