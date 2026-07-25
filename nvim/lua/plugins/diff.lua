local function diffbase(action)
  return function()
    require("util.diffbase")[action]()
  end
end

return {
  {
    "nvim-mini/mini.diff",
    init = function()
      require("util.diffbase").setup()
    end,
    keys = {
      { "<leader>gm", diffbase("toggle_default"), desc = "Toggle Default Branch Base" },
      { "<leader>gx", diffbase("pick"), desc = "Pick Diff Base" },
      { "<leader>gc", diffbase("clear"), desc = "Clear Diff Base" },
    },
  },
}
