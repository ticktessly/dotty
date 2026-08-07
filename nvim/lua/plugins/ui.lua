return {
	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	{
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		dependencies = {
			{ "romgrk/fzy-lua-native", build = "make" },
		},
		config = function()
			local wilder = require("wilder")

			wilder.setup({ modes = { ":", "/", "?" } })

			wilder.set_option("pipeline", {
				wilder.branch(
					wilder.cmdline_pipeline({
						fuzzy = 1,
						fuzzy_filter = wilder.lua_fzy_filter(),
					}),
					wilder.vim_search_pipeline()
				),
			})

			wilder.set_option(
				"renderer",
				wilder.popupmenu_renderer(
					wilder.popupmenu_border_theme({
						highlighter = wilder.lua_fzy_highlighter(),
						left = { " ", wilder.popupmenu_devicons() },
						right = { " ", wilder.popupmenu_scrollbar() },
						border = "rounded",
						max_height = "20%",
						min_width = "50%",
						reverse = 0,
					})
				)
			)
		end,
	},
}
