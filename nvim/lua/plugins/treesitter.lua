return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSInstallSync", "TSUpdate", "TSUninstall" },
		config = function()
			require("nvim-treesitter").setup()

			local langs = {
				"vim",
				"vimdoc",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"html",
				"css",
				"markdown",
			}
			vim.api.nvim_create_autocmd("FileType", {
				pattern = langs,
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
