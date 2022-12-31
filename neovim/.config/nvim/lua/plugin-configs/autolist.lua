require('autolist').setup({
	enabled = true,
	create_enter_mapping = true,
	new_entry_on_o = true,
	list_cap = 50,
	colon = {
		indent_raw = true,
		indent = true,
		preferred = "-"
	},
	invert = {
		normal_mapping = "",
		toggles_checkbox = true,
		ul_marker = "-",
		ol_incrementable = "1",
		ol_delim = ".",
	},
  insert_mappings = {
    invert = {},
  },
	lists = {
		preloaded = {
			generic = {
				"unordered",
				"digit",
				"ascii",
			},
			latex = {
				"latex_item",
			},
		},
		filetypes = {
			generic = {
				"markdown",
				"text",
			},
			latex = {
				"tex",
				"plaintex",
			},
		},
	},
	recal_hooks = {
		"invert",
		"new",
	},
	checkbox = {
		left = "%[",
		right = "%]",
		fill = "x",
	},
})
