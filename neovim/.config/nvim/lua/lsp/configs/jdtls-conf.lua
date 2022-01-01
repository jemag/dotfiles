local M = {}

local function on_init(client)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = "/home/jemag/.local/share/eclipse/" .. project_name
local bundles = {
  vim.fn.glob(
    "/home/jemag/dev/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob("/home/jemag/dev/vscode-java-test/server/*.jar"), "\n"))

M.get_config = function()
  return {
    cmd = { "java-lsp.sh", workspace_dir },
    flags = {
      debounce_text_changes = 150,
      allow_incremental_sync = true,
    },
    handlers = {},
    root_dir = require("jdtls.setup").find_root({ "build.gradle", "pom.xml", ".git" }),
    capabilities = require("lsp.handlers").capabilities,
    on_init = on_init,
    on_attach = require("lsp.handlers").on_attach,
    init_options = {
      bundles = bundles,
    },
    settings = {
      java = {
        signatureHelp = { enabled = true },
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
        },
      },
    },
  }
end

return M
