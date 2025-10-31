if vim.fn.getenv("WSL_INTEROP") ~= vim.NIL then
  -- NOTE: for work use
  require("codecompanion").setup({
    extensions = {
      history = {
        enabledd = true,
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    display = {
      action_palette = {
        provider = "snacks",
      },
      chat = {
        show_settings = false,
      },
    },
    adapters = {
      http = {
        opts = {
          show_defaults = false,
        },
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                -- default = "claude-3.5-sonnet",
                -- default = "claude-3.7-sonnet",
                default = "claude-sonnet-4",
                -- default = "gpt-4.1",
                -- default = "gemini-2.5-pro",
              },
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
        keymaps = {
          options = {
            modes = { n = "g?" },
            callback = "keymaps.options",
            description = "Options",
            hide = true,
            opts = { nowait = true },
          },
        },
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
    extensions = {
      history = {
        enabledd = true,
      },
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    display = {
      chat = {
        show_settings = false,
      },
    },
    adapters = {
      http = {
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
