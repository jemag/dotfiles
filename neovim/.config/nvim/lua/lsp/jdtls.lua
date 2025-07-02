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

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
)
-- print(vim.inspect(bundles))

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
M.get_config = function()
  return {
    cmd = {

      -- 💀
      "java", -- or '/path/to/java11_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-javaagent:" .. "/nix/store/9xnw0vx6d1y2j23jq51jk3lz0ymv5pg9-lombok-1.18.38/share/java/lombok.jar",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      -- 💀
      "-jar",
      vim.fn.glob(
        "/nix/store/vdqlz8dqd3n8iq24j4vbypi8fbjrggcc-jdt-language-server-1.47.0/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
      ),
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation                                           the actual version

      -- 💀
      "-configuration",
      -- "$(nix eval --raw nixpkgs#jdt-language-server)/share/java/jdtls/config_linux",
      "$(nix eval --raw nixpkgs#jdt-language-server)/share/java/jdtls/config_linux",
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
      -- Must point to the                      Change to one of `linux`, `win` or `mac`
      -- eclipse.jdt.ls installation            Depending on your system.

      -- 💀
      -- See `data directory configuration` section in the README
      "-data",
      workspace_dir,
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
    on_attach = require("lsp.handlers").on_attach,
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = extendedClientCapabilities,
    },
    settings = {
      java = {
        signatureHelp = { enabled = true },
        configuration = {
          updateBuildConfiguration = "interactive",
          runtimes = {
            {
              name = "JavaSE-11",
              path = "/usr/lib/jvm/java-11-openjdk/",
              default = true,
            },
            -- {
            --   name = "JavaSE-17",
            --   path = "/usr/lib/jvm/java-17-openjdk/",
            -- },
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
