local sym = require("core.symbols")

local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "none" end
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return sym.lsp .. " " .. sym.check .. " " .. table.concat(names, ",")
end

local function diagnostics_count()
  local counts = vim.diagnostic.count(0)
  local parts = {}
  if counts[1] and counts[1] > 0 then
    table.insert(parts, sym.diag_err .. " " .. counts[1])
  end
  if counts[2] and counts[2] > 0 then
    table.insert(parts, sym.diag_warn .. " " .. counts[2])
  end
  if counts[3] and counts[3] > 0 then
    table.insert(parts, sym.diag_info .. " " .. counts[3])
  end
  if counts[4] and counts[4] > 0 then
    table.insert(parts, sym.diag_hint .. " " .. counts[4])
  end
  if #parts > 0 then
    return "[ " .. table.concat(parts, " ") .. " ]"
  end
  return ""
end

local function branch_name()
  local ok, out = pcall(vim.fn.system, "git branch --show-current 2>/dev/null")
  if ok and out and out ~= "" then
    return sym.branch .. " " .. vim.trim(out)
  end
  return ""
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
  config = function()
    require("lualine").setup({
      options = {
        theme = "gruvbox",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree", "TelescopePrompt" },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { branch_name, "diff" },
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {
          diagnostics_count,
          lsp_status,
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
    })
  end,
}
