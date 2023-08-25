local M = {}

M.telescope = {
  -- <C-x> open in split
  -- <C-v> open in vsplit
  -- <C-t> open in new tab
  n = {
    ['<leader>fa'] = { ":Telescope find_files <CR>", "Telescope find files" },
    ['<leader>ff'] = { ":Telescope git_files <CR>", "Telescope find git files" },
    ['<leader>fg'] = { ":Telescope live_grep <CR>", "Telescope grep" },
  }
}

M.nvim_tree = {
  n = {
    ['<leader>pv'] = { "<cmd> NvimTreeToggle <CR>", "Toogle nvim tree" },
  }
}

M.harpoon = {
  n = {
    ["<leader>a"] = {
      function()
        require("harpoon.mark").add_file()
      end,
      "Add current file to harpoon" },
    ["<leader>o"] = {
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      "Open harpoon ui" },
  }
}

M.default = {
  n = {
    -- Page down/up with cursor in the middle
    ["<C-d>"] = { "<C-d>zz", "Page down and center view" },
    ["<C-u>"] = { "<C-u>zz", "Page up and center view" },

    -- When search next put cursor in the middle
    ["n"] = { "nzzzv", "Center view on next found" },
    ["N"] = { "Nzzzv", "Center view on previous found" },


    ["<leader>x"] = { ":bd <CR>", "Close current buffer" },
    ["<leader>n"] = { ":bn <CR>", "Go to next buffer" },
    ["<leader>b"] = { ":bp <CR>", "Go to previous buffer" },


    ["mc"] = { "ma%zf'a", "Fold" },
    ["mz"] = { "zf'a", "Add clod mark and fold" },

    ["<leader>p"] = { '"+p', "Past from clipboard" },
  },

  v = {
    -- Move selected up/down
    ["J"] = { ":m '>+1<CR>gv=gv", "Move selected line(s) up" },
    ["K"] = { ":m '<-2<CR>gv=gv", "Move selected line(s) down" },

    ["<leader>y"] = { '"+y', "Yank to clipboard" },
    ["<leader>p"] = { '"+p', "Past from clipboard" },
  }
}



return M
