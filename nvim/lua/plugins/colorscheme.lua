return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			default_integrations = false,
			integrations = {
				treesitter = true,
				native_lsp = { enabled = true },
				mason = false,
				mini = true,
				flash = true,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
