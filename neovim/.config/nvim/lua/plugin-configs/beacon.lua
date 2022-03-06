local beaconToggle = "beaconToggle"
vim.api.nvim_create_augroup(beaconToggle, {clear = true})
vim.api.nvim_create_autocmd({ "CmdwinEnter", "CmdlineEnter"}, {
  pattern = "*",
  command = "let g:beacon_enable=0",
  desc = "Disable beacon for commands",
  group = beaconToggle
})
vim.api.nvim_create_autocmd({ "CmdwinLeave", "CmdlineLeave"}, {
  pattern = "*",
  command = "let g:beacon_enable=1",
  desc = "Enable beacon back beacon after leaving commands",
  group = beaconToggle
})
vim.g.beacon_ignore_buffers = { "*git*", "*fugitive*", "*defx*" }
