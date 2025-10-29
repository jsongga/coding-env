-- use a user/user_config.lua file to provide your own configuration
local M = {}

-- add any null-ls sources you want here
M.setup_sources = function(b)
  local sources = {}

  -- Safe helper function to insert if exists
  local function safe_insert(src)
    if src ~= nil then
      table.insert(sources, src)
    end
  end

  -- Git actions
  safe_insert(b.code_actions.gitsigns)

  -- Go diagnostics
  safe_insert(b.diagnostics.golangci_lint)

  -- C++ diagnostics
  safe_insert(b.diagnostics.cppcheck)
  safe_insert(b.diagnostics.clang_check)

  -- ESLint diagnostics and code actions (eslint_d preferred, fallback to eslint)
  if b.diagnostics.eslint_d and b.code_actions.eslint_d then
    safe_insert(b.diagnostics.eslint_d.with({
      filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      },
      cwd = function(params)
        return require("lspconfig.util").root_pattern("package.json", ".eslintrc.js", ".eslintrc.json")(
          params.bufname
        )
      end,
    }))
    safe_insert(b.code_actions.eslint_d)
  elseif b.diagnostics.eslint and b.code_actions.eslint then
    safe_insert(b.diagnostics.eslint)
    safe_insert(b.code_actions.eslint)
  end

  return sources
end

-- add mason sources to auto-install
M.mason_ensure_installed = {
  null_ls = {
    "stylua",
    "jq",
    "prettier",
    "eslint_d",
    "clang-format",     -- C++
    "google-java-format", -- Java
  },
  dap = {
    "python",
    "delve",
    "js-debug-adapter",
    "codelldb",         -- C++
    "java-debug-adapter", -- Java
  },
  lsp = {
    "gopls",
    "tsserver",
    "eslint",
    "lua_ls",
    "clangd",
    "jdtls",     -- Java
    "tailwindcss", -- JSX/TSX (if you use TailwindCSS)
    "emmet_ls",  -- JSX/HTML productivity
    "thriftls",
  },
}

-- add servers to be used for auto formatting here
M.formatting_servers = {
  ["rust_analyzer"] = { "rust" },
  ["lua_ls"] = { "lua" },
  ["null_ls"] = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "go",
    "cpp", -- enable clang-format
    "java", -- enable google-java-format
  },
}

-- options you put here will override or add on to the default options
M.options = {
  opt = {
    confirm = true,
  },
}

-- Set any to false that you want disabled in here.
-- take a look at the autocommands file in lua/core for more information
-- Default value is true if left blank
M.autocommands = {
  alpha_folding = true,
  treesitter_folds = true,
  trailing_whitespace = true,
  remember_file_state = true,
  session_saved_notification = true,
  css_colorizer = true,
  cmp = true,
}

-- set to false to disable plugins
-- Default value is true if left blank
M.enable_plugins = {
  -- aerial: Code outline window for skimming and quick navigation
  -- https://github.com/stevearc/aerial.nvim
  aerial = true,

  -- alpha: Customizable start screen for Neovim
  -- https://github.com/goolord/alpha-nvim
  alpha = true,

  -- autotag: Automatically close and rename HTML/XML tags
  -- https://github.com/windwp/nvim-ts-autotag
  autotag = true,

  -- bufferline: Snazzy buffer line for Neovim
  -- https://github.com/akinsho/bufferline.nvim
  bufferline = true,

  -- context: Shows the current function context in the command line
  -- https://github.com/wellle/context.vim
  context = true,

  -- copilot: AI-powered code completion and suggestion
  -- https://github.com/github/copilot.vim
  copilot = true,

  -- dressing: Improve the default Neovim UI
  -- https://github.com/stevearc/dressing.nvim
  dressing = true,

  -- gitsigns: Git signs in the sign column
  -- https://github.com/lewis6991/gitsigns.nvim
  gitsigns = true,

  -- hop: Easy motion-like navigation
  -- https://github.com/phaazon/hop.nvim
  hop = true,

  -- img_clip: Paste images from clipboard into Neovim
  -- https://github.com/ekickx/clipboard-image.nvim
  img_clip = true,

  -- indent_blankline: Indentation guides for Neovim
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  indent_blankline = true,

  -- lsp_zero: Lightweight LSP configuration for Neovim
  -- https://github.com/VonHeikemen/lsp-zero.nvim
  lsp_zero = true,

  -- lualine: Fast and easy-to-configure statusline
  -- https://github.com/nvim-lualine/lualine.nvim
  lualine = true,

  -- neodev: Neovim setup for init.lua and plugin development
  -- https://github.com/folke/neodev.nvim
  neodev = true,

  -- neoscroll: Smooth scrolling for Neovim
  -- https://github.com/karb94/neoscroll.nvim
  neoscroll = true,

  -- neotree: File explorer tree for Neovim
  -- https://github.com/nvim-neo-tree/neo-tree.nvim
  neotree = true,

  -- session_manager: Session management for Neovim
  -- https://github.com/Shatur/neovim-session-manager
  session_manager = true,

  -- noice: Highly experimental plugin that replaces UI components
  -- https://github.com/folke/noice.nvim
  noice = true,

  -- null_ls: Use Neovim as a language server to inject LSP diagnostics, code actions, and more
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  null_ls = true,

  -- autopairs: Autopairs for Neovim
  -- https://github.com/windwp/nvim-autopairs
  autopairs = true,

  -- cmp: Completion engine for Neovim
  -- https://github.com/hrsh7th/nvim-cmp
  cmp = true,

  -- colorizer: Color highlighter for Neovim
  -- https://github.com/norcalli/nvim-colorizer.lua
  colorizer = true,

  -- dap: Debug Adapter Protocol client implementation for Neovim
  -- https://github.com/mfussenegger/nvim-dap
  dap = true,

  -- notify: Fancy, configurable notification manager for Neovim
  -- https://github.com/rcarriga/nvim-notify
  notify = true,

  -- surround: Surround selections, stylishly
  -- https://github.com/kylechui/nvim-surround
  surround = true,

  -- treesitter: Nvim Treesitter configurations and abstraction layer
  -- https://github.com/nvim-treesitter/nvim-treesitter
  treesitter = true,

  -- ufo: Folding powered by lsp, treesitter and more
  -- https://github.com/kevinhwang91/nvim-ufo
  ufo = true,

  -- onedark: One Dark theme for Neovim
  -- https://github.com/navarasu/onedark.nvim
  onedark = true,

  -- project: Project management for Neovim
  -- https://github.com/ahmedkhalf/project.nvim
  project = true,

  -- rainbow: Rainbow parentheses for Neovim
  -- https://github.com/p00f/nvim-ts-rainbow
  rainbow = false,

  -- scope: Visualize and search Treesitter scopes
  -- https://github.com/tiagovla/scope.nvim
  scope = true,

  -- telescope: Highly extendable fuzzy finder over lists
  -- https://github.com/nvim-telescope/telescope.nvim
  telescope = true,

  -- toggleterm: Persist and toggle multiple terminals
  -- https://github.com/akinsho/toggleterm.nvim
  toggleterm = true,

  -- trouble: Pretty diagnostics, references, telescope results, quickfix and location list
  -- https://github.com/folke/trouble.nvim
  trouble = true,

  -- twilight: Dim inactive portions of the code you're editing
  -- https://github.com/folke/twilight.nvim
  twilight = true,

  -- whichkey: Displays a popup with possible keybindings of the command you started typing
  -- https://github.com/folke/which-key.nvim
  whichkey = true,

  -- windline: Animations for Neovim's statusline
  -- https://github.com/windwp/windline.nvim
  windline = true,

  -- zen: Distraction-free coding for Neovim
  -- https://github.com/folke/zen-mode.nvim
  zen = true,
}

-- add extra plugins in here
M.plugins = {
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("null-ls").setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "nvim_lsp" })               -- LSP completions
      table.insert(opts.sources, { name = "tailwindcss-colorizer-cmp" }) -- color squares
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Prevent default Tab mapping
      vim.g.copilot_no_tab_map = true

      -- Accept all suggestion
      vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Accept("")', { silent = true, expr = true, noremap = true })

      -- Accept suggestion for current line
      vim.api.nvim_set_keymap(
        "i",
        "<C-J>",
        'copilot#Accept("\\n")',
        { silent = true, expr = true, noremap = true }
      )
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- core Copilot plugin
      { "nvim-lua/plenary.nvim" }, -- utility functions
    },
    build = "make tiktoken",     -- required for token counting
    opts = {
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float'
        width = 0.5,     -- 50% of screen width
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewRefresh" },
    config = function()
      require("diffview").setup({})
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  -- {
  -- 	"https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git",
  -- 	lazy = false,
  -- 	dependencies = {
  -- 		"hrsh7th/nvim-cmp",
  -- 	},
  -- 	config = function()
  -- 		require("trae").setup({})
  -- 	end,
  -- },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy", -- load it lazily on certain events to speed startup
    config = function()
      -- optional configuration
      require("illuminate").configure({
        -- your config options here (see below)
      })
    end,
  },
  {
    "uga-rosa/translate.nvim",
    cmd = { "Translate" }, -- lazy-load on command
    config = function()
      require("translate").setup({
        -- you can customize here (engine, output mode, etc.)
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- or "VeryLazy"
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
          python = { "autopep8" },
          go = { "goimports", "gofumpt" },
          cpp = { "clang_format" },
          java = { "google_java_format" },
        },
      })

      -- keymap to format manually
      vim.keymap.set("n", "<leader>fj", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format file" })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- use latest stable
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "junegunn/vim-easy-align",
    event = "BufReadPre",
  },
  {
    "chentoast/marks.nvim",
    event = "BufReadPre",
    config = function()
      local marks = require("marks")

      -- Set your preferred mode here: true = virtual text, false = sign column
      local virtual_mode = false

      marks.setup({
        default_mappings = false, -- avoid keymap conflicts
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 250,
        excluded_filetypes = {},
        sign_priority = {
          lower = 5, -- keep below gitsigns
          builtin = 7,
          bookmark = 6, -- bookmarks below gitsigns
        },
        bookmark_0 = {
          sign = virtual_mode and "" or "⚑",
          virt_text = virtual_mode and "⚑" or "",
        },
        bookmark_1 = {
          sign = virtual_mode and "" or "★",
          virt_text = virtual_mode and "★" or "",
        },
        bookmark_2 = {
          sign = virtual_mode and "" or "📌",
          virt_text = virtual_mode and "📌" or "",
        },
        bookmark_3 = {
          sign = virtual_mode and "" or "🔖",
          virt_text = virtual_mode and "🔖" or "",
        },
        mappings = {}, -- keep default mappings off
      })
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*", -- use stable v2 API
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
        other_win_hl_color = "#e35e4f",
      })
    end,
  },
}

M.lsp_config = {
  clangd = {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
  },
  tsserver = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
  thriftls = {
    cmd = { "thriftls", "--stdio", "-I", vim.loop.cwd() },
    filetypes = { "thrift" },
    root_dir = function(fname)
      local util = require("lspconfig.util")
      local root = util.root_pattern(".git")(fname)
      if root ~= nil then
        return root
      end
      return util.path.dirname(fname)
    end,
  },
}

local function align_adjacent_comment_blocks()
  local total_lines = vim.fn.line("$")
  local in_block = false
  local start_line = 0

  for lnum = 1, total_lines + 1 do
    local line = vim.fn.getline(lnum)
    local is_comment = line:match("%s*//")

    if is_comment and not in_block then
      in_block = true
      start_line = lnum
    elseif not is_comment and in_block then
      -- We've reached the end of a comment block
      local end_line = lnum - 1
      -- Run EasyAlign on that block using our 's' rule
      vim.cmd(string.format("silent! %d,%dEasyAlign s", start_line, end_line))
      in_block = false
    end
  end
end

-- add extra configuration options here, like extra autocmds etc.
-- feel free to create your own separate files and require them in here
M.user_conf = function()
  vim.cmd([[
  autocmd VimEnter * lua vim.notify("Welcome to CyberNvim!", "info", {title = "Neovim"})]])
  -- require("user.autocmds")
  -- vim.cmd("colorscheme elflord")
  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
      vim.opt.relativenumber = false
      vim.opt.number = true
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    callback = function()
      vim.opt.relativenumber = true
      vim.opt.number = true
    end,
  })

  vim.api.nvim_set_keymap(
    "n",
    "<leader>k",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_del_keymap("n", "m")

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf, lsp_fallback = true })

      -- If this is a Thrift file, run custom alignment afterward
      local ft = vim.bo[args.buf].filetype
      if ft == "thrift" then
        if type(align_adjacent_comment_blocks) == "function" then
          local view = vim.fn.winsaveview()
          align_adjacent_comment_blocks()
          vim.fn.winrestview(view)
        else
          vim.notify("align_adjacent_comment_blocks() not defined", vim.log.levels.WARN)
        end
      end
    end,
  })

  vim.opt.clipboard = ""

  -- vim.g.trae_no_map_tab = true
  -- vim.keymap.set("i", "<C-h>", "trae#Accept()", {
  -- 	silent = true,
  -- 	expr = true,
  -- 	nowait = true,
  -- })

  vim.opt.shell = "zsh -l"

  -- New dd-prefix keybindings
  vim.keymap.set("n", "<leader>ddo", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
  vim.keymap.set("n", "<leader>ddc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
  vim.keymap.set("n", "<leader>ddh", ":DiffviewFileHistory<CR>", { desc = "File history" })
  vim.keymap.set("n", "<leader>ddf", ":DiffviewToggleFiles<CR>", { desc = "Toggle files panel" })
  vim.keymap.set("n", "<leader>ddr", ":DiffviewRefresh<CR>", { desc = "Refresh Diffview" })

  -- Keymaps for translating
  -- Normal mode: translate current line (comment)
  vim.keymap.set("n", "<leader>tc", function()
    vim.cmd("Translate EN")
  end, { desc = "Translate line/comment to English" })

  -- Visual mode: translate selection
  vim.keymap.set("v", "<leader>tc", function()
    vim.cmd("'<,'>Translate EN")
  end, { desc = "Translate selection to English" })
  -- LSP root configuration

  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

  local root_files = { "package.json", "tsconfig.json", ".git" }
  -- TypeScript / JavaScript
  lspconfig.ts_ls.setup({
    root_dir = util.root_pattern(unpack(root_files)),
    settings = {
      workingDirectory = { mode = "auto" },
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayVariableTypeHints = true,
        },
      },
    },
  })

  -- Start EasyAlign in visual mode
  vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {})
  -- Start EasyAlign for motion/text object
  vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {})

  vim.g.easy_align_delimiters = {
    s = { pattern = "//\\+", delimiter_align = "l", ignore_groups = { "!Comment" } },
    m = { pattern = "--\\+", delimiter_align = "l", ignore_groups = { "!Comment" } },
    h = { pattern = "#\\+", delimiter_align = "l", ignore_groups = { "!Comment" } },
  }

  -- Keybind to align comment blocks on demand
  -- vim.keymap.set("n", "<leader>ga", function()
  -- 	align_adjacent_comment_blocks()
  -- end, { desc = "Align adjacent comment blocks" })
  local opts = { noremap = true, silent = true }

  -- Open Copilot Chat
  vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>CopilotChat<CR>", opts)

  -- Close Copilot Chat
  vim.api.nvim_set_keymap("n", "<leader>cq", "<cmd>CopilotChatClose<CR>", opts)

  -- Scroll up/down in chat
  vim.api.nvim_set_keymap("n", "<C-u>", "<cmd>CopilotChatScroll(-5)<CR>", opts)
  vim.api.nvim_set_keymap("n", "<C-d>", "<cmd>CopilotChatScroll(5)<CR>", opts)

  -- Send a message to chat
  vim.api.nvim_set_keymap("i", "<C-Enter>", "<cmd>CopilotChatSend<CR>", opts)

  -- Switch between chat sessions (if multiple)
  vim.api.nvim_set_keymap("n", "<leader>cs", "<cmd>CopilotChatSwitch<CR>", opts)
  vim.opt.splitright = true

  lspconfig.tailwindcss.setup({
    filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    root_dir = lspconfig.util.root_pattern("tailwind.config.js", "postcss.config.js", "package.json", ".git"),
  })

  require("neo-tree").setup({
    filesystem = {
      commands = {
        create_cpp_dir = function(state)
          local node = state.tree:get_node()
          local base_path = node.path

          -- prompt for directory name
          vim.ui.input({ prompt = "Directory name: ", default = base_path .. "/" }, function(dir_name)
            if not dir_name or dir_name == "" then
              return
            end

            vim.fn.mkdir(dir_name, "p") -- create directory

            -- prompt for number of files
            vim.ui.input({ prompt = "Number of files: ", default = "1" }, function(num_files)
              local n = tonumber(num_files) or 1
              local letters = "abcdefghijklmnopqrstuvwxyz"

              -- template C++ code
              local template = [[
#include <bits/stdc++.h>
using namespace std;

int main() {
    // freopen("input.txt", "r", stdin);
    // freopen("output.txt", "w", stdout);

    std::ios::sync_with_stdio(false);
    cin.tie(0);

    int n;
}
]]

              for i = 1, n do
                local fname = dir_name .. "/" .. letters:sub(i, i) .. ".cpp"
                local f = io.open(fname, "w")
                if f then
                  f:write(template)
                  f:close()
                end
              end
            end)
          end)
        end,
      },
      window = {
        mappings = {
          ["<leader>cf"] = "create_cpp_dir", -- keybinding
        },
      },
    },
  })
end

return M
