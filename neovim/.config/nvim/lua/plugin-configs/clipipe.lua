local clipipe = require("clipipe")

-- Extract Windows username from PATH environment variable
local path = os.getenv("PATH") or ""
local windows_username = path:match("/mnt/c/Users/([^/]+)/")

local clipipe_path = string.format("/mnt/c/Users/%s/AppData/Local/clipipe/clipipe.exe", windows_username)

clipipe.setup({
  -- Optional configuration, defaults shown here:
  path = clipipe_path, -- clipipe binary
  keep_line_endings = false, -- Set to true to disable \r\n conversion on Windows
  enable = true, -- Automatically set g:clipboard to enable clipipe
  start_timeout = 5000, -- Timeout for starting background process (ms)
  timeout = 500, -- Timeout for responses from background process (ms)
  interval = 50, -- Polling interval for responses (ms)
  download = false, -- Download pre-built binary if needed
  build = false, -- Build from source if needed
})
