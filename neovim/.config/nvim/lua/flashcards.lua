-- Flashcards: spaced repetition over cards embedded in Obsidian vault notes.
--
-- A card is "<!-- card: <id> -->", the question, "<!-- answer -->", the answer, in any
-- note (by convention under "## Flashcards"). The id keys the review state.
-- Review state lives in <vault>/.flashcards.jsonl so it syncs with the vault's git.
-- Scheduling is FSRS-4.5 with default weights, day granularity, 90% retention.

local M = {}

---@class flashcards.Card
---@field id string
---@field path string
---@field lnum integer   line of the "<!-- card: -->" marker
---@field front string
---@field back string

M.config = {
  vault = vim.env.OBSIDIAN_VAULT,
  state_file = vim.env.OBSIDIAN_VAULT and (vim.env.OBSIDIAN_VAULT .. "/.flashcards.jsonl"),
  -- vault-relative directories never scanned for cards (dot-directories are always skipped)
  exclude = { ["5-templates"] = true },
  new_per_day = 20,
  width = 90,
  height = 24,
}

-- FSRS-4.5 ------------------------------------------------------------------

local W = { 0.4872, 1.4003, 3.7145, 13.8206, 5.1618, 1.2298, 0.8975, 0.031, 1.6474, 0.1367,
  1.0461, 2.1072, 0.0793, 0.3246, 1.587, 0.2272, 2.8755 }
local DECAY, FACTOR = -0.5, 19 / 81

local function retrievability(elapsed, s)
  return (1 + FACTOR * elapsed / s) ^ DECAY
end

local function clamp_d(d)
  return math.min(10, math.max(1, d))
end

local function init_d(g)
  return clamp_d(W[5] - (g - 3) * W[6])
end

-- mean reversion toward the "good" initial difficulty
local function next_d(d, g)
  return clamp_d(W[8] * init_d(3) + (1 - W[8]) * (d - W[7] * (g - 3)))
end

local function recall_s(d, s, r, g)
  local hard = g == 2 and W[16] or 1
  local easy = g == 4 and W[17] or 1
  return s * (1 + math.exp(W[9]) * (11 - d) * s ^ -W[10] * (math.exp((1 - r) * W[11]) - 1) * hard * easy)
end

local function forget_s(d, s, r)
  return W[12] * d ^ -W[13] * ((s + 1) ^ W[14] - 1) * math.exp((1 - r) * W[15])
end

local function today()
  return math.floor(os.time() / 86400)
end

-- g: 1 again, 2 hard, 3 good, 4 easy
local function schedule(st, g)
  local now = today()
  if not st then
    st = { s = W[g], d = init_d(g), reps = 0, lapses = 0 }
  else
    local r = retrievability(math.max(0, now - st.last), st.s)
    st.s = g == 1 and forget_s(st.d, st.s, r) or recall_s(st.d, st.s, r, g)
    st.d = next_d(st.d, g)
  end
  st.reps = st.reps + 1
  st.lapses = st.lapses + (g == 1 and 1 or 0)
  st.last = now
  -- at 90% target retention the FSRS interval equals stability
  st.due = now + (g == 1 and 1 or math.max(1, math.floor(st.s + 0.5)))
  return st
end

-- Parsing ---------------------------------------------------------------------

-- "<!-- card: <id> -->" opens a card, "<!-- answer -->" splits question from answer.
-- A card ends at the next card marker, the next heading, or EOF; markers and headings
-- inside code fences don't count.
local CARD = "^%s*<!%-%-%s*card:%s*([%w_-]+)%s*%-%->%s*$"
local ANSWER = "^%s*<!%-%-%s*answer%s*%-%->%s*$"

function M.parse(path)
  local cards = {} ---@type flashcards.Card[]
  local card ---@type { id: string, lnum: integer, front: string[], back: string[]? }?
  local in_fence, lnum = false, 0

  local function finish()
    if card then
      local front = vim.trim(table.concat(card.front, "\n"))
      local back = card.back and vim.trim(table.concat(card.back, "\n")) or ""
      if front ~= "" and back ~= "" then
        table.insert(cards, { id = card.id, path = path, lnum = card.lnum, front = front, back = back })
      else
        vim.notify(("flashcards: %s:%d card %q has an empty question or no <!-- answer -->"):format(
          path, card.lnum, card.id), vim.log.levels.WARN)
      end
    end
    card = nil
  end

  for line in io.lines(path) do
    lnum = lnum + 1
    local id = not in_fence and line:match(CARD)
    if id then
      finish()
      card = { id = id, lnum = lnum, front = {} }
    elseif not in_fence and line:match("^#+%s") then
      finish()
    elseif card and not in_fence and not card.back and line:match(ANSWER) then
      card.back = {}
    elseif card then
      table.insert(card.back or card.front, line)
    end
    if line:match("^%s*```") then
      in_fence = not in_fence
    end
  end
  finish()
  return cards
end

function M.collect()
  local cards = {}
  for name, kind in vim.fs.dir(M.config.vault, { depth = 10, skip = function(dir)
    return not (vim.fs.basename(dir):match("^%.") or M.config.exclude[dir])
  end }) do
    if kind == "file" and name:match("%.md$") then
      local path = M.config.vault .. "/" .. name
      local fd = io.open(path)
      local has = fd and fd:read("*a"):find("<!-- card:", 1, true)
      if fd then
        fd:close()
      end
      if has then
        vim.list_extend(cards, M.parse(path))
      end
    end
  end
  -- ids key the review state, so a duplicate would share history: keep the first one
  local unique, seen = {}, {}
  for _, card in ipairs(cards) do
    if seen[card.id] then
      vim.notify(("flashcards: duplicate id %q in %s and %s, skipping the second"):format(
        card.id, seen[card.id], card.path), vim.log.levels.WARN)
    else
      seen[card.id] = card.path
      table.insert(unique, card)
    end
  end
  return unique
end

-- State -----------------------------------------------------------------------

local function load_state()
  local state = {}
  if vim.fn.filereadable(M.config.state_file) == 0 then
    -- carry over the single-object .flashcards.json written by the first version
    local legacy = M.config.state_file:gsub("%.jsonl$", ".json")
    if vim.fn.filereadable(legacy) == 1 then
      local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(legacy), "\n"))
      return ok and data or state
    end
    return state
  end
  for lnum, line in ipairs(vim.fn.readfile(M.config.state_file)) do
    if vim.trim(line) ~= "" then
      local ok, entry = pcall(vim.json.decode, line)
      if ok and type(entry) == "table" and entry.id then
        state[entry.id] = entry
        entry.id = nil
      else
        vim.notify(("flashcards: %s:%d is not a valid state line, ignoring it"):format(M.config.state_file, lnum),
          vim.log.levels.WARN)
      end
    end
  end
  return state
end

-- One JSON object per card, sorted by id, fixed field order, separated by blank lines.
-- git treats changes on adjacent lines as one conflict; the blank line between entries lets
-- reviews of different cards on two machines merge cleanly.
local function save_state(state)
  local ids = vim.tbl_keys(state)
  table.sort(ids)
  local lines = {}
  for i, id in ipairs(ids) do
    local st = state[id]
    if i > 1 then
      table.insert(lines, "")
    end
    table.insert(lines, ('{"id": %s, "s": %.4f, "d": %.4f, "last": %d, "due": %d, "reps": %d, "lapses": %d}'):format(
      vim.json.encode(id), st.s, st.d, st.last, st.due, st.reps, st.lapses))
  end
  local tmp = M.config.state_file .. ".tmp"
  vim.fn.writefile(lines, tmp)
  assert(os.rename(tmp, M.config.state_file))
end

-- Review UI -------------------------------------------------------------------

function M.review()
  if not M.config.vault then
    vim.notify("flashcards: OBSIDIAN_VAULT is not set", vim.log.levels.ERROR)
    return
  end
  local state, now = load_state(), today()
  local queue, new = {}, 0
  for _, card in ipairs(M.collect()) do
    local st = state[card.id]
    if st and st.due <= now then
      table.insert(queue, card)
    elseif not st and new < M.config.new_per_day then
      new = new + 1
      table.insert(queue, card)
    end
  end
  if #queue == 0 then
    vim.notify("flashcards: nothing due")
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  local width = math.min(M.config.width, vim.o.columns - 4)
  local height = math.min(M.config.height, vim.o.lines - 4)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    style = "minimal",
  })
  vim.wo[win].wrap = true
  vim.wo[win].conceallevel = 2

  local current ---@type flashcards.Card
  local revealed = false
  local function render()
    local lines = vim.split(current.front, "\n")
    vim.list_extend(lines, { "", "---", "" })
    if revealed then
      vim.list_extend(lines, vim.split(current.back, "\n"))
      vim.list_extend(lines, { "", "_1 again · 2 hard · 3 good · 4 easy · e edit · q quit_" })
    else
      table.insert(lines, "_<space> reveal · e edit · q quit_")
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.api.nvim_win_set_config(win, {
      title = (" Flashcards · %d left · %s "):format(#queue + 1, vim.fs.basename(current.path)),
      title_pos = "center",
    })
  end

  local function next_card()
    local card = table.remove(queue, 1) --[[@as flashcards.Card?]]
    if not card then
      vim.api.nvim_win_close(win, true)
      vim.notify("flashcards: session done")
      return
    end
    current, revealed = card, false
    render()
  end

  local function map(lhs, fn)
    vim.keymap.set("n", lhs, fn, { buffer = buf, nowait = true })
  end
  map("<space>", function()
    revealed = true
    render()
  end)
  for g = 1, 4 do
    map(tostring(g), function()
      if not revealed then
        return
      end
      state[current.id] = schedule(state[current.id], g)
      save_state(state)
      if g == 1 then
        table.insert(queue, current)
      end
      next_card()
    end)
  end
  map("e", function()
    vim.api.nvim_win_close(win, true)
    vim.cmd.edit(vim.fn.fnameescape(current.path))
    vim.api.nvim_win_set_cursor(0, { current.lnum, 0 })
  end)
  map("q", function()
    vim.api.nvim_win_close(win, true)
  end)

  next_card()
end

-- Drop review state for ids that no longer exist in the vault (asks first).
function M.prune()
  local state, live = load_state(), {}
  for _, card in ipairs(M.collect()) do
    live[card.id] = true
  end
  local orphans = vim.tbl_filter(function(id)
    return not live[id]
  end, vim.tbl_keys(state))
  if #orphans == 0 then
    vim.notify("flashcards: no orphaned review state")
    return
  end
  table.sort(orphans)
  local prompt = ("Remove review state for %d deleted card(s)? %s"):format(#orphans, table.concat(orphans, ", "))
  vim.ui.select({ "Yes", "No" }, { prompt = prompt }, function(choice)
    if choice ~= "Yes" then
      return
    end
    for _, id in ipairs(orphans) do
      state[id] = nil
    end
    save_state(state)
    vim.notify(("flashcards: pruned %d entr%s"):format(#orphans, #orphans == 1 and "y" or "ies"))
  end)
end

vim.api.nvim_create_user_command("Flashcards", function(opts)
  if opts.args == "prune" then
    M.prune()
  else
    M.review()
  end
end, {
  nargs = "?",
  complete = function()
    return { "prune" }
  end,
  desc = "Review due flashcards from the vault (:Flashcards prune drops state of deleted cards)",
})
vim.keymap.set("n", "<leader>of", M.review, { desc = "Review flashcards" })

return M
