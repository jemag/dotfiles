local clipipe = require("clipipe")
clipipe.setup({
  -- Optional configuration, defaults shown here:
  path = "/mnt/c/Users/brassarddesjardinsa/AppData/Local/clipipe/clipipe.exe", -- clipipe binary
  keep_line_endings = false, -- Set to true to disable \r\n conversion on Windows
  enable = true, -- Automatically set g:clipboard to enable clipipe
  start_timeout = 5000, -- Timeout for starting background process (ms)
  timeout = 500, -- Timeout for responses from background process (ms)
  interval = 50, -- Polling interval for responses (ms)
  download = false, -- Download pre-built binary if needed
  build = false, -- Build from source if needed
})

vim.g.clipboard = {
  name = "clipipe",
  copy = {
    ["+"] = function(lines)
      clipipe.copy(lines, "+")
    end,
    ["*"] = function(lines)
      clipipe.copy(lines, "*")
    end,
  },
  paste = {
    ["+"] = function()
      return clipipe.paste("+")
    end,
    ["*"] = function()
      return clipipe.paste("*")
    end,
  },
}
