require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
	float = {
		transparent = true,
	},
	no_bold = true,
	no_italic = true,
	custom_highlights = function(colors)
		return {
			MiniIndentscopeSymbol = { link = "LineNr" },
			LspInlayHint = { bg = colors.base, fg = colors.overlay0, italic = true },
			NotificationInfo = { bg = "NONE", fg = colors.text },
			NotificationWarning = { bg = "NONE", fg = colors.overlay2 },
			NotificationError = { bg = "NONE", fg = colors.red },
		}
	end,
})

-- Active theme: rose-pine moon (same palette as tmux + starship)
require("rose-pine").setup({
	styles = { bold = false, italic = false },
})
vim.cmd("colorscheme rose-pine-moon")
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- Switch back to catppuccin: comment the rose-pine block above, then:
-- vim.cmd("colorscheme catppuccin-mocha")
