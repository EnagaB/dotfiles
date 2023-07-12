local dotvim_dir = vim.fn.expand("<sfile>:p:h")

-- load vimrc
vim.cmd('source ' .. dotvim_dir .. '/vimrc')

-- load neovim configs
local init_nvim_dir = dotvim_dir .. '/init/nvim'
dofile(init_nvim_dir .. '/term.lua')
