-- Xem trước markdown ngay trong nvim (heading, bảng, code block, checkbox, link...)
-- Dòng đang đứng sẽ hiện text gốc để sửa; các dòng khác hiện bản đã render.
require("render-markdown").setup({
    file_types = { "markdown" },
    completions = { blink = { enabled = true } }, -- gợi ý callout/checkbox qua blink.cmp
})

-- <leader>mp: bật/tắt render (xem dạng text thô khi cần)
vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", { desc = "Markdown preview toggle" })

-- Vẽ ảnh + sơ đồ ```mermaid``` (flowchart, sequence...) ngay trong buffer.
-- render-markdown không vẽ được mermaid, phần này do snacks.image đảm nhận.
-- Cần: kitty (graphics protocol), tmux `allow-passthrough on`, lệnh `mmdc` (@mermaid-js/mermaid-cli).
require("snacks").setup({
    image = {
        enabled = true,
        doc = {
            inline = true, -- vẽ sơ đồ ngay dưới code block
            float = true, -- terminal không hỗ trợ inline thì hiện float khi đứng trên block
            max_width = 120,
            max_height = 40,
        },
    },
})

if vim.fn.executable("mmdc") == 0 then
    vim.schedule(function()
        vim.notify("Thiếu mmdc: npm i -g --prefix ~/.local @mermaid-js/mermaid-cli", vim.log.levels.WARN)
    end)
end
