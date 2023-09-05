local dotvim_dir = vim.fn.expand("<sfile>:p:h")

-- load vimrc
vim.cmd('source ' .. dotvim_dir .. '/vimrc')

-- load neovim configs
local nvim_dir = dotvim_dir .. '/neovim'
dofile(nvim_dir .. '/term.lua')

-- hop.nvim
local ok, hop = pcall(require, 'hop')
if ok then
    hop.setup()
end
