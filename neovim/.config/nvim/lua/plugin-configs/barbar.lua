--[[ let bufferline = {}
let bufferline.icons = "both"
" Enable/disable animations
let bufferline.animation = true
" Enable/disable close button
let bufferline.closable = true

" Enables/disable clickable tabs
"  - left-click: go to buffer
"  - middle-click: delete buffer
let bufferline.clickable = true

" If set, the letters for each buffer in buffer-pick mode will be
" assigned based on their name. Otherwise or in case all letters are
" already assigned, the behavior is to assign letters in order of
" usability (see order below)
let bufferline.semantic_letters = true

" New buffer letters are assigned in this order. This order is
" optimal for the qwerty keyboard layout but might need adjustement
" for other layouts.
let bufferline.letters =
  \ 'asdfjkl;ghnmxcbziowerutyqpASDFJKLGHNMXCBZIOWERUTYQP'

" Sets the maximum padding width with which to surround each tab
let bufferline.maximum_padding = 4 ]]
vim.g.bufferline = {
	animation= false,
	auto_hide= false,
	closable= true,
	clickable= true,
	icon_separator_active= '▊ ',
	icons= "both",
	maximum_padding= 4,
	semantic_letters= true,
}
