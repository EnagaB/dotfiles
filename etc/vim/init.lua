local dotvim_dir = vim.fn.expand("<sfile>:p:h")
-- load vimrc
vim.cmd("source " .. dotvim_dir .. "/vimrc")
