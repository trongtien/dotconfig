-- nvim-treesitter nhánh main (cần tree-sitter CLI + gcc để build parser)
local parsers = {
    "bash", "c", "css", "go", "html", "javascript", "json", "lua", "markdown",
    "markdown_inline", "python", "query", "rust", "tsx", "typescript", "vim",
    "vimdoc", "yaml",
}

local ts = require("nvim-treesitter")
if vim.fn.executable("tree-sitter") == 1 then
    ts.install(parsers)

    -- install() bỏ qua parser đã có, kể cả khi query của nó hỏng (vd. symlink còn trỏ về
    -- thư mục plugin cũ của lazy.nvim) -> treesitter chạy nhưng không có màu. Cài lại những cái đó.
    local qdir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "queries")
    local broken = vim.tbl_filter(function(lang)
        return vim.uv.fs_lstat(vim.fs.joinpath(qdir, lang)) ~= nil
            and vim.uv.fs_stat(vim.fs.joinpath(qdir, lang, "highlights.scm")) == nil
    end, parsers)
    if #broken > 0 then ts.install(broken, { force = true }) end
end

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("KelvinTreesitter", { clear = true }),
    callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})
