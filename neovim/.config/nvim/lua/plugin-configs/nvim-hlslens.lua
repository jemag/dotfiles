local map = require'utils'.map_key
map('n', 'n','<cmd>execute("normal! " . v:count1 . "n")<CR><cmd>lua require("hlslens").start()<CR>')
map('n', 'N','<cmd>execute("normal! " . v:count1 . "N")<CR><cmd>lua require("hlslens").start()<CR>')
map('n', '*','*<cmd>lua require("hlslens").start()<CR>')
map('n', '#','#<cmd>lua require("hlslens").start()<CR>')
map('n', 'g*','g*<cmd>lua require("hlslens").start()<CR>')
map('n', 'g#','g#<cmd>lua require("hlslens").start()<CR>')
