return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		config = true,
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		ft = { "python", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "basedpyright", "vtsls" },
			automatic_enable = false,
		},
	},
	{
		"neovim/nvim-lspconfig",
		ft = { "python", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
			})
			vim.lsp.config("vtsls", {
				capabilities = capabilities,
			})

			vim.lsp.enable({ "basedpyright", "vtsls" })

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})
		end,
	},
}
