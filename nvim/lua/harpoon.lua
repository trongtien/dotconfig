-- Danh sach file nhanh (giong Harpoon): chi add tay, khong tu dong
local M = {}

local store = vim.fn.stdpath("data") .. "/harpoon.json"
local list = {}

local function load_list()
  local f = io.open(store, "r")
  if not f then
    return
  end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" then
    list = data
  end
end

local function save()
  local f = io.open(store, "w")
  if not f then
    return
  end
  f:write(vim.json.encode(list))
  f:close()
end

local function short(path)
  return vim.fn.fnamemodify(path, ":~:.")
end

function M.add()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Buffer khong co ten file")
    return
  end
  for _, p in ipairs(list) do
    if p == path then
      vim.notify("Da co trong list: " .. short(path))
      return
    end
  end
  table.insert(list, path)
  save()
  vim.notify("Da add (slot " .. #list .. "): " .. short(path))
end

function M.open(index)
  local path = list[index]
  if not path then
    vim.notify("Slot " .. index .. " dang trong")
    return
  end
  if vim.fn.filereadable(path) == 0 then
    vim.notify("File khong ton tai: " .. short(path))
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
end

-- Menu kieu oil: buffer float, dung key normal-mode
local menu_buf = nil
local menu_win = nil

local function menu_lines()
  local lines = {}
  for i, p in ipairs(list) do
    lines[i] = string.format("%d  %s", i, short(p))
  end
  return lines
end

local function menu_close()
  if menu_win and vim.api.nvim_win_is_valid(menu_win) then
    vim.api.nvim_win_close(menu_win, true)
  end
  if menu_buf and vim.api.nvim_buf_is_valid(menu_buf) then
    vim.api.nvim_buf_delete(menu_buf, { force = true })
  end
  menu_buf = nil
  menu_win = nil
end

local function menu_delete()
  local row = vim.api.nvim_win_get_cursor(menu_win)[1]
  if not list[row] then
    return
  end
  table.remove(list, row)
  save()
  if #list == 0 then
    menu_close()
    vim.notify("List trong — bam <leader>a de add file")
    return
  end
  vim.bo[menu_buf].modifiable = true
  vim.api.nvim_buf_set_lines(menu_buf, 0, -1, false, menu_lines())
  vim.bo[menu_buf].modifiable = false
  vim.api.nvim_win_set_cursor(menu_win, { math.min(row, #list), 0 })
end

local function menu_choose()
  -- Co count (vd 3 + Enter) thi mo slot do, khong thi mo dong dang dung
  local row = vim.v.count
  if row == 0 then
    row = vim.api.nvim_win_get_cursor(menu_win)[1]
  end
  row = math.min(row, #list)
  menu_close()
  M.open(row)
end

function M.menu()
  if vim.tbl_isempty(list) then
    vim.notify("List trong — bam <leader>a de add file")
    return
  end
  if menu_buf and vim.api.nvim_buf_is_valid(menu_buf) then
    menu_close()
    return
  end

  local lines = menu_lines()
  local width = 100
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 2, vim.o.columns - 4)

  menu_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(menu_buf, 0, -1, false, lines)
  vim.bo[menu_buf].bufhidden = "wipe"
  vim.bo[menu_buf].modifiable = false
  menu_win = vim.api.nvim_open_win(menu_buf, true, {
    relative = "editor",
    width = width,
    height = #lines + 10,
    row = math.floor(0.5 * (vim.o.lines - #lines)),
    col = math.floor(0.5 * (vim.o.columns - width)),
    style = "minimal",
  })

  local opts = { buffer = menu_buf, silent = true, nowait = true }
  vim.keymap.set("n", "<CR>", menu_choose, opts)
  vim.keymap.set("n", "o", menu_choose, opts)
  vim.keymap.set("n", "dd", menu_delete, opts)
  vim.keymap.set("n", "x", menu_delete, opts)
  vim.keymap.set("n", "q", menu_close, opts)
  vim.keymap.set("n", "<Esc>", menu_close, opts)
end

load_list()

vim.keymap.set("n", "<leader>a", M.add, { silent = true, desc = "Harpoon: add file" })
vim.keymap.set("n", "<C-e>", M.menu, { silent = true, desc = "Harpoon: show list" })
for i = 1, 4 do
  vim.keymap.set("n", "<leader>" .. i, function()
    M.open(i)
  end, { silent = true, desc = "Harpoon: slot " .. i })
end

return M
