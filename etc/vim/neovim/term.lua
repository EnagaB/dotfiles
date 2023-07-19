local sh = os.getenv('SHELL')
if sh == nil then
    vim.opt.shell = '/bin/bash'
end
