local cap = require("lsp.handlers").capabilities
cap.offsetEncoding = { "utf-16" }
return {
  capabilities = cap,
}
