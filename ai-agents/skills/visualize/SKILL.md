---
name: visualize
description: "Add a correct, minimal visual to a lesson — a diagram or geometric picture — rendered to a PNG the learner can open. Use when an idea is genuinely clearer as a picture: a dependency graph, system/flow, sequence, state machine, tree, comparison, or a spatial/geometric thing (coordinate geometry, number line, vectors, a plot, a physical layout). Outsources authoring+rendering to a maker subagent that verifies the image by looking at it, then you embed the returned file."
---

# Visualize

A picture earns its place only when it shows something words can't — shape, structure, direction, relationship, geometry. This skill produces ONE such picture, guarantees it is **correct** (the maker renders it and looks at it before returning), and hands it to the lesson as a PNG file the learner can open.

You are the **creative director**. You decide the exact idea and distill it to its fewest carrying elements. A **maker subagent** does the authoring, rendering, visual verification, and saving, then returns a filename. You embed that filename in your reply.

## When to visualize (and when not to)

This teaching system builds a **dependency graph in the learner's head** — axioms at the root, derived facts hanging off them. A visual is powerful exactly when it makes that structure (or a geometry) visible. Reach for one when:

- The idea is a **structure or relationship**: dependencies, a system with parts and arrows, a flow/pipeline, a sequence of exchanges, a state machine, a tree/hierarchy, a comparison, a containment (what's inside vs outside).
- The idea is **spatial or geometric**: coordinate geometry, a number line, vectors, a function's shape, a physical arrangement.

Do NOT visualize when prose or a single equation already carries it. A decorative diagram that just restates the sentence next to it adds noise and a chance to be wrong. When in doubt, don't — a missing visual is cheaper than a false one.

## Choose the maker

Two maker subagents:

- **`mermaid-maker`** — structural/relational visuals: dependency graphs, flowcharts, sequence/state/ER/class diagrams, trees, mindmaps, timelines. This is the default and fits the dependency-graph pedagogy directly.
- **`svg-maker`** — spatial/geometric visuals Mermaid can't lay out: exact coordinates, geometry figures, number lines, vectors, plots, custom shapes.

Rule of thumb: if it's *nodes-and-edges / relationships*, use mermaid-maker. If it's *positions-and-shapes / geometry*, use svg-maker.

## Brief the maker well: one idea, fewest elements

The most common failure is **cramming** — every extra label makes the picture harder to read AND harder to lay out correctly. Before briefing, prune to the fewest elements that carry the idea, and for each ask: *"if I delete this, is the idea still clear?"* If yes, delete it.

Give the maker the concept AND the concrete elements you want — not a vague topic, and not a long checklist.

- BAD: "make a diagram about how TCP works"
- GOOD: "graph TD: a node 'packet' at the top; arrows down to 'ordering' and 'retransmit on loss'; both arrows down into 'reliable stream'. No title. Show that reliability is built FROM packets, not alongside them."

Keep the idea intact but trust the maker to compose; if your brief lists more than ~5–7 elements, cut it first.

## Invoke

Dispatch the maker as a subagent:

- opencode: `task(subagent_type="mermaid-maker", prompt="<your minimal, concrete brief>")`
- Claude Code: `Task(subagent_type="svg-maker", prompt="<your minimal, concrete brief>")`

The maker authors the source under `viz/`, renders it to a PNG with `mmdc` / `rsvg-convert`,
**reads the PNG back to look at it and iterates until it is correct and clean**, then returns:

```
RESULT:
filename: viz-<slug>-<timestamp>.png
path: <cwd>/viz/viz-<slug>-<timestamp>.png
```

If it returns `RESULT: NONE`, it couldn't make a correct picture of the brief — simplify or rethink, or decide the visual isn't worth it. Never hand-author or fake a diagram yourself; correctness depends on the maker's render-and-inspect loop.

## Hand it to the learner

**Neither the terminal nor you can display the image — only the learner's image viewer can.**
So say where it is, in one line, and then say what it shows:

```
Diagram: viz/viz-packet-reliability-1730490000.png — open it alongside.
```

Introduce the visual in a sentence, then let it carry the idea — don't narrate every element back in prose.

If a `lesson.md` is open (see the `teach` skill's "Long or math-heavy lessons" section), also
append an Obsidian wikilink embed to that file, using the **filename** and a display width:

```
![[viz-<slug>-<timestamp>.png|500]]
```

Obsidian resolves the embed by filename anywhere in the vault, so this renders inline as long as `viz/` sits inside it. Width `|500` is a good default; larger for dense diagrams.

## Why this is reliable

- The maker never returns a picture it hasn't **looked at**, so "renders fine but says something false" is caught before it reaches the learner.
- A PNG means **what the maker verified is pixel-identical to what the learner sees** — no re-render drift.
- Unique filenames keep by-filename embed resolution unambiguous.

> The makers render with `mmdc` (mermaid-cli) and `rsvg-convert` (fallback ImageMagick `magick`) straight from `bash`, and verify with `read`, which returns the PNG to them as an image. You don't render anything yourself — you only brief the maker and pass on the filename it returns.
