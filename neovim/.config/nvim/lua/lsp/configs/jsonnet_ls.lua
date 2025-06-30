local stringtoboolean = { ["true"] = true, ["false"] = false }

return {
  cmd = { "jsonnet-language-server", "-t" },
  settings = {
    formatting = {
      UseImplicitPlus = false,
    },
  },
}
