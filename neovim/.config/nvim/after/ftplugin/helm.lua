local clients = vim.lsp.get_active_clients()
for client_id, client in pairs(clients) do
  if client.name == "yamlls" then
    vim.lsp.buf_detach_client(0, client_id)
  end
end
