-- nvim-treesitter nhánh main (cần tree-sitter CLI + gcc để build parser)
local parsers = {
    "bash", "c", "css", "go", "html", "javascript", "json", "lua", "markdown",
    "markdown_inline", "python", "query", "rust", "tsx", "typescript", "vim",
    "vimdoc", "yaml",
}

local ts = require("nvim-treesitter")
if vim.fn.executable("tree-sitter") == 1 then
    ts.install(parsers)
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("KelvinTreesitter", { clear = true }),
    callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
