return {
  settings = {
    gopls = {
      buildFlags = { "-tags=integration" },
      completeFunctionCalls = false,
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
