# Wrap-up — goal reached, or the learner stops

## 0. Where things stand, then one offer

Show the state in a few lines, from the log's Concepts table:

```
Mastered: tcp-seq-numbers, tcp-acks
In progress: tcp-window (R3) · not started: tcp-congestion
Open misconceptions: <any still open>
```

If the capstone hasn't passed, say so in one line ("goal not verified — the capstone hasn't
been run"). Don't push.

Then one `ask`, multi-select:

- **Wiki note** — a reference note in `~/obsidian` (§1)
- **Flashcards** — for `:Flashcards` review (§2)
- **Pause** — keep the log to resume later with `/learn <topic>`

Run what they pick, in order. Picking nothing (or only Pause) writes nothing to the vault;
go to §3.

- **Flashcards without a note:** cards have to live in a vault note. Write a minimal one
  under §1's naming and location rules: H1, a 1–3 bullet `## Overview`, then
  `## Flashcards`. Say that's what you're doing.
- **Stopped early:** the note covers only what was taught. Concepts not reached go in a
  closing `## Not covered yet` list (one line each), so future-you knows the note's edge.
  Cards come only from taught concepts.

## 1. Wiki reference note(s) — if picked in §0

**Read `~/obsidian/AGENTS.md` first and follow it.** It is authoritative over anything below.
Key points it imposes:
- lowercase kebab-case filenames;
- one `# <Readable Title>` H1;
- standard markdown links with relative `.md` paths, never `[[wikilinks]]`;
- attachments in `_attachments/` with vault-root embeds;
- the language of the request;
- no new top-level folders;
- never commit.

1. **Look for an existing note first:** `rg -il '<key terms>' ~/obsidian/2-resources ~/obsidian/3-mocs`. If a note covers the topic, propose extending it (show the sections you'd add) instead of creating a duplicate, and wait for a yes.
2. **Where:** `2-resources/work/dfo/` if the material is specific to DFO's environment, otherwise `2-resources/`. One note per coherent topic; a goal that spans distinct topics gets one note each, linked to each other.
3. **Content: a reference for future recall, not a lesson transcript.** No grades, no session narrative, no "we learned". Suggested shape (structure follows content, per AGENTS.md):
   - `## Overview` — what it is and the problem it solves, 2–4 bullets.
   - `## Core truths` — the unconditional truths the map rests on.
   - `## How it fits together` — the mermaid concept map, then one subsection per concept: the schema in a few bullets plus its canonical worked example, **with** the why of each step (drawn from the reference explanations in the log).
   - `## Gotchas` — each misconception the learner actually had during the session, phrased as the trap and its correction.
   - `## References` — the sources the researcher cited.
4. Math in ```typst fences, diagrams in ```mermaid. Copy `visualize` PNGs that earned a place to `_attachments/<kebab-name>.png`.
5. **MOC:** if one in `3-mocs/` clearly fits, add the link in its most specific section, in the same change. Don't force one.
6. Tell the learner the path(s) of what you wrote.

## 2. Flashcards — if picked in §0

Draft them **in chat first**; drop or edit on request; then append a `## Flashcards`
section at the end of each note.

```markdown
## Flashcards

<!-- card: <topic>-<slug> -->
<question — any markdown, no headings>
<!-- answer -->
<answer — any markdown, no headings>
```

Card rules (the parser is `neovim/.config/nvim/lua/flashcards.lua` in the dotfiles):
- `<!-- card: <id> -->` / `<!-- answer -->` on lines of their own. Both sides may hold code, ```typst, and ```mermaid, but never headings. Cards are separated by a blank line.
- The id is kebab-case, prefixed with the topic, and unique in the vault: check with `rg -F '<!-- card: <id>' ~/obsidian`. Never change an existing id (it keys the review history).
- Atomic: one fact or one reasoning step per card.

Where cards come from:
- each core truth → a *why / what follows* card, not a definition;
- each misconception in the log → a card whose question is the one that separates the wrong model from the right one;
- each concept's key worked-example step → "In <problem>, why does step N <do X>?";
- each procedure → a fade card: the problem plus the first steps on the front, the remaining steps and their whys on the back.

Aim for 5–15 cards per note, weighted toward what was hard.

## 3. Close the log

Set **Status** to one of:
- `goal reached` — the capstone passed;
- `stopped — <date>` — they stopped before the capstone;
- `paused — <date>` — they picked Pause.

Add the wiki note path(s), if any, and list Open doubts that are still unresolved. A paused log
is the resume point; §0 of SKILL.md picks it up. Leave the log in place; deleting it is the
learner's call.
