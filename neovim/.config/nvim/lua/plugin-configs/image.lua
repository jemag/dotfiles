require("image").setup({
  backend = "ueberzug", -- or "kitty"
  processor = "magick_cli", -- or "magick_rock"
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = true,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      floating_windows = false, -- if true, images will be rendered in floating markdown windows
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      resolve_image_path = function(document_path, image_path, fallback)
        local working_dir = vim.fn.getcwd()

        -- Check if the image_path is already an absolute path
        if vim.fn.filereadable(image_path) == 1 then
          return image_path
        else
          local path = working_dir .. "/" .. image_path
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end

        return fallback(document_path, image_path)
      end,
    },
    neorg = {
      enabled = true,
      filetypes = { "norg" },
    },
    typst = {
      enabled = true,
      filetypes = { "typst" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})
