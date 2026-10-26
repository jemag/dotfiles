local M = {}

local home = os.getenv("HOME")
if vim.fn.has("mac") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "mac"
elseif vim.fn.has("unix") == 1 then
  WORKSPACE_PATH = home .. "/workspace/"
  CONFIG = "linux"
else
  print("Unsupported system")
end

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

local bundles = {}
local debug_bundles = vim.split(vim.fn.glob(vim.fn.getenv("JAVA_DEBUG_BUNDLE")), "\n")
local test_bundles = vim.split(vim.fn.glob(vim.fn.getenv("JAVA_TEST_BUNDLE")), "\n")
vim.list_extend(bundles, vim.tbl_filter(function(b) return b ~= "" end, debug_bundles))
vim.list_extend(bundles, vim.tbl_filter(function(b) return b ~= "" end, test_bundles))


local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
M.get_config = function()
  return {
    -- javaLspScript is created from nix setup
    cmd = {
      "javaLspScript",
    },
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
    handlers = {},
    root_dir = require("jdtls.setup").find_root({ "build.gradle", "pom.xml", ".git" }),
    capabilities = require("lsp.handlers").capabilities,
    contentProvider = { preferred = "fernflower" },
    on_init = on_init,
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = {
      java = {
        signatureHelp = { enabled = true },
        -- jdtls itself runs on JDK 25 (see javaLspScript); projects build on JAVA_HOME (JDK 21)
        configuration = {
          runtimes = {
            {
              name = "JavaSE-21",
              path = os.getenv("JAVA_HOME"),
              default = true,
            },
          },
        },
        import = {
          gradle = {
            java = { home = os.getenv("JAVA_HOME") },
          },
        },

        eclipse = {
          downloadSources = true,
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all", -- literals, all, none
          },
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
    },
  }
end

return M
