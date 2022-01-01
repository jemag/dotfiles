local custom_ayu_mirage = require'lualine.themes.ayu_mirage'
-- Change the background of lualine_c section for normal mode
custom_ayu_mirage.inactive.c.bg = '#111111'
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = custom_ayu_mirage,
		component_separators = { "", "" },
		section_separators = { "", "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
