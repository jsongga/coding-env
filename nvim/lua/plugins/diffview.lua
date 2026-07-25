return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", group = "diffview" },
      { "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Open" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Close" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
    },
    opts = {},
  },
}
