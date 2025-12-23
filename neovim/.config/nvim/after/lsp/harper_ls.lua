return {
  filetypes = { "markdown" },
  settings = {
    ["harper-ls"] = {
      diagnosticSeverity = "hint",
      isolateEnglish = false,
      dialect = "American",
      maxFileLength = 120000,
      linters = {
        AvoidCurses = false,
        SentenceCapitalization = false,
        LongSentences = false,
      },
    },
  },
}
