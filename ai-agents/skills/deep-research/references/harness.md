# Harness capability mapping

This skill needs five capabilities. Tool names differ per harness; the workflow does not.

| Capability                    | Claude Code                | opencode                |
| ----------------------------- | -------------------------- | ----------------------- |
| Web search                    | `WebSearch`                | `websearch`             |
| Fetch a URL                   | `WebFetch`                 | `webfetch`              |
| Spawn a subagent              | `Agent` (`subagent_type`)  | `task` (`subagent_type`)|
| Broad research subagent type  | `general-purpose`          | `general`               |
| Local codebase subagent type  | `Explore`                  | `explore`               |
| Ask a structured question     | `AskUserQuestion`          | `question`              |
| Read / write / edit files     | `Read` / `Write` / `Edit`  | `read` / `write` / `edit` |
| Run a shell command           | `Bash`                     | `bash`                  |

In an unlisted harness, map by capability: use whatever provides web search, and whatever spawns a parallel subagent.

## Step 1 preflight — verify web search before scoping

Do this **before** interviewing the user or writing the report header. Discovering the gap at Step 2, after
scoping and fanning out sub-agents, wastes an entire planning cycle.

1. Check whether a web search tool is present in your own tool list.
2. If it is absent, do not assume it is merely misnamed and do not substitute `webfetch` against a search
   engine — Google, Bing, DuckDuckGo, and Mojeek all return CAPTCHA or JS challenges to non-browser clients.
3. Report the exact remedy for the harness (below) and let the user decide before proceeding.

## opencode: `websearch` is gated

`websearch` is a built-in tool but is **not registered by default**. The gate is:

```js
providerID === "opencode" || enableExa || enableParallel
```

So it is available only when using the first-party `opencode` provider, or when an enable flag is set.
On any third-party provider (`github-copilot`, `anthropic`, `openai`, ...) it is missing entirely and
**will not appear in your tool list**.

| Variable | Effect |
| -------- | ------ |
| `OPENCODE_ENABLE_EXA=1` | Enables `websearch` via Exa. No API key required. |
| `OPENCODE_EXPERIMENTAL=1` | Also enables it (plus other experimental tools). |
| `OPENCODE_ENABLE_PARALLEL=1` | Enables it via Parallel instead. |
| `OPENCODE_WEBSEARCH_PROVIDER` | `exa` or `parallel` — forces provider choice. |
| `EXA_API_KEY` | Optional; lifts Exa's free-tier rate limits. |

Remedy to give the user: `OPENCODE_ENABLE_EXA=1 opencode`, or persist the export in their shell env.

Note `permission.websearch` in `opencode.json` controls whether an *available* tool may run — it does
**not** enable a gated one. Setting it on an ungated build is a no-op.

**Alternative:** any MCP search server also works and bypasses the gate entirely (Exa, Brave, a
self-hosted SearXNG bridge). MCP tools are namespaced, so the capability will appear under a name like
`brave_brave_web_search` rather than `websearch` — map by capability, not by name.

## Degradations

- **No structured-question tool** (e.g. headless `opencode run`, where `question` is denied): ask the questions as plain numbered text and wait for a reply.
- **No subagent tool:** run axes sequentially in the main loop. Coverage is unchanged; wall-clock and context pressure get worse. Cut to the 3–5 best axes.
- **Extended reasoning:** Claude Code supports `ultrathink`. Elsewhere there is no keyword — just reason deliberately before writing.
- **No web search:** halt. This skill cannot run on training data alone. Check the gating table above
  first — in opencode the tool is usually absent because it is gated, not because it is unsupported.
  Scraping a search engine via the fetch tool is **not** a viable substitute; they serve CAPTCHAs to
  non-browser clients. If the user explicitly overrides the halt, say so in the report's methodology
  section, mark every discovery-dependent section "No sources found" rather than filling it from
  training data, and consider compensating with machine verification (compiling code, running the
  tool under test) so that mechanical claims still have a second, non-documentary source.