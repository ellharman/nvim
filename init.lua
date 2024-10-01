-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{ "neovim/nvim-lspconfig" },
		{ "mhartington/formatter.nvim" },
		{ "Mofiqul/dracula.nvim" },
		{ "gelguy/wilder.nvim" },
		{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
		{ "echasnovski/mini.nvim", version = "*" },
		{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "gaoDean/autolist.nvim" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "dracula" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- General config
vim.cmd("colorscheme dracula")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.mouse = ""

-- Unbind arrow keys
vim.cmd("noremap <Left> <Nop>")
vim.cmd("noremap <Right> <Nop>")
vim.cmd("noremap <Up> <Nop>")
vim.cmd("noremap <Down> <Nop>")
vim.cmd("inoremap <Left> <Nop>")
vim.cmd("inoremap <Right> <Nop>")
vim.cmd("inoremap <Up> <Nop>")
vim.cmd("inoremap <Down> <Nop>")

-- Lualine config
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
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
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

-- Formatter config
-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
require("autolist").setup()

vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
-- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")
vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
