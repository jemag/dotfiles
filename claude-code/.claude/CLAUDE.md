## When plan mode is active

- **Show the code before asking anything.** The first substantive output is the
  proposed change itself: per-file diffs or exact replacement code, anchored at
  `path:line`. Delegate discovery to a subagent if that is faster, but read the
  files you intend to change before writing the plan — a subagent's summary is
  not enough to plan a concrete edit from.
- **Assume, mark, and move on.** Do not open with AskUserQuestion. Where the
  request is ambiguous, take the reading a careful colleague would take and state
  it inline beside the change it affects: "Assumes X; if you meant Y, this block
  becomes Z instead." I will correct it.
- **Questions come after the proposal, never before it.** If something is still
  genuinely open once I have seen the code, ask then — and only where the answer
  changes what gets written.
- **Length is not the goal.** A plan that shows the real edit is worth more to me
  than a short one that describes it. Do not compress diffs into prose to keep the
  plan scannable.