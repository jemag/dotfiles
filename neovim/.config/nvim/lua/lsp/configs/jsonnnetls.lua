local stringtoboolean = { ["true"] = true, ["false"] = false }

return {
  cmd = { "jsonnet-language-server", "-t" },
  settings = {
    formatting = {
      UseImplicitPlus = stringtoboolean[os.getenv("JSONNET_IMPLICIT_PLUS")] or false,
    },
  },
}
