local M = {}

local design = require('ofirkai.design')
M.scheme = design.scheme

local function highlight(group, color)
	local style = color.style and 'gui=' .. color.style or 'gui=NONE'
	local fg = color.fg and 'guifg = ' .. color.fg or 'guifg = NONE'
	local bg = color.bg and 'guibg = ' .. color.bg or 'guibg = NONE'
	local sp = color.sp and 'guisp = ' .. color.sp or ''
	vim.cmd(
		'highlight ' .. group .. ' ' .. style .. ' ' .. fg .. ' ' .. bg .. ' ' .. sp
	)
end

local default_config = {
	scheme = design.scheme,
	custom_hlgroups = {},
	called_from_vim_colorscheme = false
}

M.setup = function(config)
	-- Colorscheme is already loaded, no need to reload
	if vim.g.colors_name == 'ofirkai' and config.called_from_vim_colorscheme then
		return
	end

	vim.cmd('hi clear')
	if vim.fn.exists('syntax_on') then
		vim.cmd('syntax reset')
	end
	vim.o.background = 'dark'
	vim.o.termguicolors = true
	vim.g.colors_name = 'ofirkai'

	config = config or {}
	config = vim.tbl_deep_extend('keep', config, default_config)

	local hl_groups = design.hl_groups(config.scheme)
	hl_groups = vim.tbl_deep_extend('keep', config.custom_hlgroups, hl_groups)

	for group, colors in pairs(hl_groups) do
		highlight(group, colors)
	end
end

return M
