vim.opt_local.conceallevel = 2
vim.opt_local.expandtab = true

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Render the ```typst block under the cursor to SVG and open it with the system viewer.
-- For terminals without kitty graphics (Windows Terminal); Ghostty renders inline via snacks.
vim.keymap.set("n", "<localleader>tmv", function()
  local node = vim.treesitter.get_node()
  while node and node:type() ~= "fenced_code_block" do
    node = node:parent()
  end
  local lang, body
  if node then
    for child in node:iter_children() do
      if child:type() == "info_string" then
        lang = vim.trim(vim.treesitter.get_node_text(child, 0))
      elseif child:type() == "code_fence_content" then
        body = vim.treesitter.get_node_text(child, 0)
      end
    end
  end
  if lang ~= "typst" or not body then
    vim.notify("cursor is not in a ```typst block", vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.stdpath("cache") .. "/typst-block"
  vim.fn.mkdir(dir, "p")
  local src, out = dir .. "/block.typ", dir .. "/block.svg"
  local page = dir .. "/block.html"
  local lines = { "#set page(width: auto, height: auto, margin: 8pt)", "#set text(size: 14pt)" }
  vim.fn.writefile(vim.list_extend(lines, vim.split(body, "\n")), src)

  vim.system({ "typst", "compile", "--format", "svg", src, out }, {}, vim.schedule_wrap(function(res)
    if res.code ~= 0 then
      vim.notify(res.stderr, vim.log.levels.ERROR)
      return
    end
    -- open through an .html page: on Windows .svg is often bound to Edge, .html to the default browser
    vim.fn.writefile({
      "<!doctype html><meta charset='utf-8'><title>typst block</title>",
      "<body style='margin:2em'><img src='block.svg' style='zoom:2'>",
    }, page)
    if vim.env.WSL_INTEROP then
      -- vim.ui.open prefers xdg-open (present on NixOS-WSL), which can't open Windows paths
      vim.system({ "explorer.exe", vim.trim(vim.fn.system({ "wslpath", "-w", page })) }, { detach = true })
    else
      vim.ui.open(page)
    end
  end))
end, { buffer = true, desc = "Preview typst block" })
