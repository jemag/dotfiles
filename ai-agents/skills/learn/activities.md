# Activities — formats and grading

Every activity is one turn: pose it, wait, grade, reveal. Log it (SKILL.md → Session log).
Each new instance changes the **surface** (names, numbers, domain specifics) and keeps the
**structure**, so the learner can't pattern-match the text of the last one.

Choose examples from the learner's world where one fits: AKS, Azure, networking, Linux, Nix,
nushell, Go. Never use their actual work repo as the subject of a task (the teacher rule).

## R1 — Brief explanation

- One idea, motivated (Principle ii): the problem first, then the idea that solves it, then the unconditional truth(s) it rests on.
- ≤ ~15 lines. The worked example carries the detail; the explanation only has to make it readable.
- End with one `quiz` check on the core idea. Correct → R2. Miss → re-explain that point differently (another angle or analogy, not louder), then check again.

## R2 — Worked example + self-explanation

Pick the **smallest problem that exercises the whole schema**, with no incidental complexity:
no unrelated flags, config, or syntax the learner would have to decode. That extra load is
pure cost.

```
Worked example — <concept>

Problem: <one or two lines>

1. <one move>
2. <one move>
3. <one move>
4. <one move>

Result: <the answer / final state>
```

- Each step is a single move: one command, one transformation, one decision. Code goes in a fenced block under its step.
- **No justifications in the steps.** The why is what the learner supplies.
- Execute it first if it can be executed (see Accuracy).

Then the prompt (free reply):

> Explain why each step is there: what it achieves and what makes it valid. Steps 2 and 4
> matter most. Add a confidence if you like.

- For examples longer than ~5 steps, name the 2–3 steps that carry the schema instead of asking for all of them.
- **Variant — comparison pair:** two short examples that differ in one feature, where the procedure diverges. Ask: "why does step 3 differ?" Use it when the concept's crux is *when* a rule applies.

**Grading (after their reply):**

```
Step 1 ✓ — <one line confirming the why they gave>
Step 2 ~ — you described what it does; the why: <reference>
Step 4 ✗ — <name the wrong model> ; actually: <reference>
```

| Mark | Meaning |
|---|---|
| ✓ | names the reason: the goal the step serves, or the rule that licenses it |
| ~ | restates the step ("it adds the header") — description, not explanation |
| ✗ | a wrong model of why |
| — | not addressed |

Then the full reference explanation for every step not marked ✓.

- **Sound** = every key step ✓.
- **Lacking** = any ✗, or a ~ on a key step. Say plainly what is missing and why it matters for the goal. Micro-explain only that point (R1-sized or smaller), then give a new worked example built so the missed step is unavoidable, and ask for self-explanation again.
- An ✗ held with high confidence is a misconception: demote to R1 for that point.

## R3 — Faded examples, stepwise retrieval, MCQs

### Backward-faded example

Same format as R2, with a new problem; the final steps are blank:

```
Faded example — <concept>

Problem: …

1. <given>
2. <given>
3. ____
4. ____

Result: ____
```

Fade schedule, one new problem per fade:
1. the last step blank;
2. the last two blank;
3. a middle step blank as well (the step their self-explanations were weakest on);
4. only the problem given — that is a task-sized problem, so promote to R4 instead.

Prompt (free reply): "Fill in the blanks, with a one-line why for each."

Grade each blank ✓/~/✗ as in R2 (the step itself and its why), then show the **complete
solution**.

### Stepwise retrieval

For long procedures or derivations where the *order of moves* is the point. Reveal one step
at a time. Before each reveal, the learner predicts the next step in one line (free reply).
Then reveal it, mark the prediction ✓/✗ in one line, and move on. After the last step, give
one line on which predictions missed and what that says.

### MCQ

The quiz protocol in SKILL.md, unchanged. On this rung use it for **discrimination**: which
approach applies, what this outputs, where this breaks, which of two near-identical configs
does X. Interleaved items from earlier concepts are usually MCQs.

## R4 — Task

Short and self-contained: **5–15 minutes**, one concept plus at most one earlier concept
(interleaving). Stated so they know exactly when they're done:

```
Task — <title>  (~10 min)

Goal: <what to produce or find out>
Given: <starting state; files created for them, if any>
Done when: <observable acceptance criteria — output, test passing, a written answer>
Rules: <e.g. man pages and docs fine; no searching for the solution>

Reply "done" (with a path, or paste your answer). "hint" if stuck.
```

- **Where:** if the task needs files, create a starter in `learn-tasks/<slug>/<task-name>/` in the working directory. Never point a task at their real repos.
- **Hints, if asked:** (1) name the relevant concept; (2) point at the relevant step of an earlier worked example; (3) give a partial solution. Log the hints used. Any hint turns a pass into a partial.

**Review (after "done"):** read the files. Run the work if it's harmless and confined to the
task dir (a script, a test, `nix eval`, `typst compile`). Otherwise reason about it.

```
Task review — <title>
Result: pass | partial | fail

✓ <specific thing done right, and why it's right>
✗ <issue> — <why it matters> — <which concept it reveals>

Model solution:
<complete solution, with a one-line why per non-obvious part>
```

- pass (no hints) → mastered
- partial → hold at R4 with a new task, or drop to R3 if the issue is a whole step they didn't know
- fail → demote by evidence: a missing schema → R2; a misconception → R1 on that point

### Capstone

Same format, sized to the goal sentence (it may run 20–30 min), and combining the concepts.
The review grades per concept, so a fail demotes only the concepts it exposed.
