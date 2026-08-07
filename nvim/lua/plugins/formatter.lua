return {
	{
		"stevearc/conform.nvim",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"json",
			"jsonc",
			"css",
			"html",
			"markdown",
			"python",
		},
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				python = { "ruff_organize_imports", "ruff_format" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		},
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			run_on_start = true,
			debounce_hours = 0,
			ensure_installed = {
				"prettier",
				"eslint_d",
				"ruff",
			},
		},
	},
}
