-- Quản lý plugin bằng vim.pack (có sẵn từ Neovim 0.12)
--   :lua vim.pack.update()            cập nhật plugin
--   :lua vim.pack.del({ "tên" })      xoá plugin
-- Plugin nằm ở ~/.local/share/nvim/site/pack/core/opt, khoá phiên bản ở nvim-pack-lock.json

-- Chạy :TSUpdate sau khi nvim-treesitter được cài/cập nhật (phải khai báo trước vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("KelvinPack", { clear = true }),
    callback = function(ev)
        local d = ev.data
        if d.spec.name == "nvim-treesitter" and d.kind ~= "delete" then
            if not d.active then vim.cmd.packadd("nvim-treesitter") end
            vim.cmd("TSUpdate")
        end
    end,
})

local gh = function(repo) return "https://github.com/" .. repo end

vim.pack.add({
    { src = gh("rose-pine/neovim"), name = "rose-pine" },
    gh("nvim-lua/plenary.nvim"),
    gh("nvim-telescope/telescope.nvim"),
    { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
    gh("mbbill/undotree"),
    gh("tpope/vim-fugitive"),
    gh("stevearc/conform.nvim"),
    gh("folke/lazydev.nvim"),
    gh("rafamadriz/friendly-snippets"),
    -- tag 1.x để blink tải binary build sẵn, không cần cargo
    { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
    gh("j-hui/fidget.nvim"),
    gh("mason-org/mason.nvim"),
    gh("mason-org/mason-lspconfig.nvim"),
    gh("neovim/nvim-lspconfig"),
    -- Cây thư mục (neo-tree cần plenary + nui, devicons để hiện icon)
    gh("MunifTanjim/nui.nvim"),
    gh("nvim-tree/nvim-web-devicons"),
    { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },
}, { confirm = false }) -- tự cài plugin còn thiếu, không hỏi

require("kelvin.plugins.colors")
require("kelvin.plugins.treesitter")
require("kelvin.plugins.telescope")
require("kelvin.plugins.harpoon")
require("kelvin.plugins.misc")
require("kelvin.plugins.lsp")
require("kelvin.plugins.neotree")
