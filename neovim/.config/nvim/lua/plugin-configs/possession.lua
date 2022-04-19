local Path = require('plenary.path')
require('possession').setup {
    session_dir = (Path:new(vim.fn.stdpath('data')) / 'possession'):absolute(),
    silent = false,
    load_silent = true,
    debug = false,
    commands = {
        save = 'SSave',
        load = 'SLoad',
        delete = 'SDelete',
        show = 'SShow',
        list = 'SList',
        migrate = 'SMigrate',
    },
    hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data)
          for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            vim.api.nvim_buf_delete(buffer, {})
          end
          return user_data
        end,
        after_load = function(name, user_data) end,
    },
    plugins = {
        close_windows = {
            hooks = {'before_save', 'before_load'},
            preserve_layout = true,  -- or fun(win): boolean
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false,  -- or fun(win): boolean
            },
        },
        delete_hidden_buffers = {
            hooks = {
                'before_load',
            },
            force = false,
        },
        nvim_tree = true,
        tabby = true,
    },
}
