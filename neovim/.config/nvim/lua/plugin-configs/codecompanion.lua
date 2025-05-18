if vim.fn.getenv("WSL_INTEROP") ~= vim.NIL then
  -- NOTE: for work use
  require("codecompanion").setup({
    display = {
      chat = {
        show_settings = false,
      },
    },
    adapters = {
      opts = {
        show_defaults = false,
      },
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = "claude-3.5-sonnet",
              -- default = "gemini-2.5-pro",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
      agent = {
        adapter = "copilot",
      },
    },
  })
else
  -- NOTE: for home use
  require("codecompanion").setup({
    display = {
      chat = {
        show_settings = false,
      },
    },
    adapters = {
      opts = {
        show_defaults = false,
      },
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = vim.fn.getenv("GEMINI_API_KEY"),
          },
          schema = {
            model = {
              default = "gemini-2.0-flash",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
      agent = {
        adapter = "gemini",
      },
    },
  })
end
