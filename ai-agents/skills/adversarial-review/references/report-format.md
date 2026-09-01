# Report format

The shape of the markdown report written at Step 7. No emoji, no ALL-CAPS severity banners
inside prose. Plain, quotable text — the author should be able to paste a finding straight
into a PR comment unedited. In `--chat` mode this same shape is printed instead of written.

## Header

The file opens with a metadata block, so it stands alone months later without the session
that produced it:

    # Regression analysis: <target>

    | | |
    | --- | --- |
    | Target | `<the git ref, range, or PR, as resolved>` |
    | Analyzed | `<YYYY-MM-DD>` |
    | Mode | `<default / quick / subjective / fix>` |
    | Findings | `<N>` |
    | Severity | `<none / low / medium / high / critical>` |
    | Coverage | `<N of M change categories>` |
    | Gaps | `<what could not be verified, or none>` |

Then one paragraph: what the change does, and the single most important thing found. If
nothing was found, say that plainly and stop — no filler findings, no "minor observations"
section padded to look thorough.

Then one block per confirmed finding, most severe first:

    ### 1. <One-line statement of the defect>  [<PATTERN-ID>] [<severity>]

    Location: path/to/file.ext:120-134

    What happens

    1. `Handler.Create` (api/handler.go:88) calls `store.Insert` with a nil `tx`
    2. `Insert` dereferences it without a guard (store/insert.go:41)
    3. Result: panic on every request where `X-Tenant` is absent.

    Evidence

    (fenced code block, quoted verbatim from the file, with the file:line above it)

        // store/insert.go:41
        func (s *Store) Insert(tx *sql.Tx, r Record) error {
            return tx.QueryRow(...)  // no nil guard
        }

    Why no existing guard covers it

    <Where you looked for a mitigation and why it does not apply. This is the part that shows
    the finding survived the false-positive gate — never omit it.>

    Suggested direction

    <One or two sentences of direction, not a patch. The author knows the code better.>

Rules:

- Every step in "What happens" cites `file:line`. A step without one means the finding was not
  gated properly — go back to Step 6.
- "Evidence" is quoted verbatim from the file, not paraphrased and not reconstructed from the
  diff.
- Cite a violated `AGENTS.md` rule in the rule's own words, with the file it came from.
- A `PRE-EXISTING` issue gets one line under a separate heading, or is omitted.
- Never mention a candidate the gate killed — not as a footnote, not as "also considered".

Close the file with a `## Coverage` section: change categories swept (`N of M`), pattern files
loaded, context gaps, and candidates eliminated by the false-positive gate. The counts in the
header and in this section must agree — if they don't, the report was assembled carelessly and
the reader has no reason to trust the findings either.
