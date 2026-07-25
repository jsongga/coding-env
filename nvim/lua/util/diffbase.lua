local M = {}

M.state = { rev = nil, resolved = nil, merge_base = false, root = nil }
M.adapters = {}

local TITLE = "Diff Base"
local NO_CONFIG = {}
local gitsigns_base
local minidiff_buffers = {}
local neotree_base = {}
local neotree_raw_status_cache
local neotree_subscribed = false

local function buffer_dir(buf)
  buf = buf or 0
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" and not name:match("^%w+://") then
    name = vim.fs.normalize(name)
    local stat = (vim.uv or vim.loop).fs_stat(name)
    return stat and stat.type == "directory" and name or vim.fs.dirname(name)
  end
  return assert((vim.uv or vim.loop).cwd())
end

local function git(args, cwd)
  local cmd = { "git" }
  vim.list_extend(cmd, args)
  return vim.system(cmd, { cwd = cwd or buffer_dir(), text = true }):wait()
end

local function stdout(result)
  return vim.trim(result.stdout or "")
end

local function stderr_suffix(result)
  local err = vim.trim(result.stderr or "")
  return err == "" and "" or "\n" .. err
end

local function repo_root(buf)
  local out = git({ "rev-parse", "--show-toplevel" }, buffer_dir(buf))
  return out.code == 0 and stdout(out) ~= "" and vim.fs.normalize(stdout(out)) or nil
end

local function load_plugin(name)
  local ok, config = pcall(require, "lazy.core.config")
  local plugin = ok and config.plugins[name] or nil
  if not plugin then
    return false
  end
  if not plugin._.loaded then
    require("lazy").load({ plugins = { name } })
  end
  return plugin._.loaded ~= nil
end

local function apply_adapters(buf)
  for name, fn in pairs(M.adapters) do
    local ok, err = pcall(fn, M.state, buf)
    if not ok then
      M.notify(("%s adapter failed: %s"):format(name, err), vim.log.levels.WARN)
    end
  end
end

function M.notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = TITLE })
end

function M.label()
  if not M.state.rev then
    return nil
  end
  return M.state.rev .. (M.state.merge_base and "…" or "")
end

--- Resolve the repo's default branch, preferring origin/HEAD.
function M.default_branch()
  local root = repo_root()
  if not root then
    return
  end

  local out = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, root)
  if out.code == 0 and stdout(out) ~= "" then
    return stdout(out)
  end
  for _, candidate in ipairs({ "origin/main", "origin/master", "main", "master" }) do
    if git({ "rev-parse", "--verify", "--quiet", candidate }, root).code == 0 then
      return candidate
    end
  end
end

function M.set(rev, merge_base)
  rev = vim.trim(tostring(rev or ""))
  if rev == "" then
    return M.notify("A Git revision is required", vim.log.levels.WARN)
  end

  local root = repo_root()
  if not root then
    return M.notify("The current buffer is not in a Git repository", vim.log.levels.ERROR)
  end

  local tip = git({ "rev-parse", "--verify", "--quiet", "--end-of-options", rev .. "^{commit}" }, root)
  if tip.code ~= 0 or stdout(tip) == "" then
    return M.notify("Could not resolve " .. rev .. stderr_suffix(tip), vim.log.levels.ERROR)
  end

  local resolved = stdout(tip)
  if merge_base then
    local out = git({ "merge-base", "HEAD", resolved }, root)
    if out.code ~= 0 or stdout(out) == "" then
      return M.notify("No merge base with " .. rev .. stderr_suffix(out), vim.log.levels.ERROR)
    end
    resolved = stdout(out)
  end

  if M.state.rev and M.state.root and M.state.root ~= root then
    M.state = { rev = nil, resolved = nil, merge_base = false, root = M.state.root }
    apply_adapters()
  end

  M.state = { rev = rev, resolved = resolved, merge_base = merge_base or false, root = root }
  M.apply()

  local short = resolved:sub(1, 7)
  if merge_base then
    M.notify(("Comparing against **%s** (merge base `%s`)"):format(rev, short))
  else
    M.notify(("Comparing against **%s** (tip `%s`)"):format(rev, short))
  end
end

function M.clear()
  if not M.state.rev then
    local root = repo_root()
    if root then
      M.state = { rev = nil, resolved = nil, merge_base = false, root = root }
      M.apply()
    end
    return M.notify("Already comparing against the index", vim.log.levels.WARN)
  end
  M.state = { rev = nil, resolved = nil, merge_base = false, root = M.state.root }
  M.apply()
  M.notify("Comparing against the index")
end

function M.toggle_default()
  local root = repo_root()
  local branch = M.default_branch()
  if not branch then
    return M.notify("No default/main/master branch found", vim.log.levels.WARN)
  end
  if M.state.rev == branch and M.state.merge_base and M.state.root == root then
    return M.clear()
  end
  M.set(branch, true)
end

function M.pick()
  load_plugin("snacks.nvim")
  if not (_G.Snacks and Snacks.picker) then
    return M.notify("Snacks picker is not available", vim.log.levels.ERROR)
  end

  Snacks.picker.git_branches({
    confirm = function(picker, item)
      picker:close()
      local rev = item and (item.branch or item.commit)
      if rev then
        M.set(rev, true)
      else
        M.notify("Could not read a rev from that selection", vim.log.levels.WARN)
      end
    end,
  })
end

function M.apply(buf)
  apply_adapters(buf)
  if buf then
    return
  end
  vim.api.nvim_exec_autocmds("User", {
    pattern = "DiffBaseChanged",
    data = M.state,
    modeline = false,
  })
  vim.cmd.redrawstatus()
end

--- Apply globally so Gitsigns also uses the base for buffers attached later.
M.adapters.gitsigns = function(state)
  if not load_plugin("gitsigns.nvim") then
    return
  end
  local gs = require("gitsigns")

  local target = state.resolved or false
  if gitsigns_base == target then
    return
  end
  gitsigns_base = target

  gs.change_base(state.resolved, true, function(err)
    if not err then
      return
    end
    if gitsigns_base == target then
      gitsigns_base = nil
    end
    vim.schedule(function()
      M.notify("gitsigns adapter failed: " .. err, vim.log.levels.WARN)
    end)
  end)
end

local function neotree_invalidate_status(root)
  if not neotree_raw_status_cache then
    local status = require("neo-tree.git").status
    for index = 1, 20 do
      local name, value = debug.getupvalue(status, index)
      if not name then
        break
      end
      if name == "raw_status_text_cache" then
        neotree_raw_status_cache = value
        break
      end
    end
  end
  if neotree_raw_status_cache then
    neotree_raw_status_cache[root] = nil
  end
end

local function neotree_set_base(state, diffbase)
  if state.name ~= "git_status" or not diffbase.root then
    return
  end
  state.git_base_by_worktree = state.git_base_by_worktree or {}
  state.git_base_by_worktree[diffbase.root] = diffbase.resolved
  state.dirty = true
end

M.adapters.neotree = function(state, buf)
  if buf or not state.root or not load_plugin("neo-tree.nvim") then
    return
  end

  local events = require("neo-tree.events")
  local manager = require("neo-tree.sources.manager")
  if not neotree_subscribed then
    manager.subscribe("git_status", {
      event = events.STATE_CREATED,
      id = "diffbase.neo_tree_state",
      handler = function(neotree_state)
        neotree_set_base(neotree_state, M.state)
      end,
    })

    -- Neo-tree's synchronous status cache is keyed only by working-tree
    -- contents, not git_base. Invalidate it before status reads so changing
    -- only the comparison base still rebuilds the Git Status source.
    manager.subscribe("git_status", {
      event = events.BEFORE_GIT_STATUS,
      id = "diffbase.neo_tree_status",
      handler = function(args)
        if M.state.resolved and vim.fs.normalize(args.git_root) == M.state.root then
          neotree_invalidate_status(M.state.root)
        end
      end,
    })
    neotree_subscribed = true
  end

  local target = state.resolved or false
  local changed = neotree_base.root ~= state.root or neotree_base.resolved ~= target

  -- Ensure a state exists for this tab without opening Neo-tree, then update
  -- every existing Git Status state (including sidebars in other tabs).
  if changed then
    neotree_base = { root = state.root, resolved = target }
    neotree_set_base(manager.get_state("git_status"), state)
    manager._for_each_state("git_status", function(neotree_state)
      neotree_set_base(neotree_state, state)
    end)
    neotree_invalidate_status(state.root)
  end

  local position
  local current_tab = vim.api.nvim_get_current_tabpage()
  local renderer = require("neo-tree.ui.renderer")
  manager._for_each_state(nil, function(neotree_state)
    if not position and neotree_state.tabid == current_tab and renderer.window_exists(neotree_state) then
      position = neotree_state.current_position or neotree_state.window.position
    end
  end)

  require("neo-tree.command").execute({
    source = "git_status",
    action = "show",
    position = position,
    dir = state.root,
    git_base = state.resolved,
  })
end

local function minidiff_eligible(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.api.nvim_buf_is_loaded(buf)
    and vim.bo[buf].buftype == ""
    and vim.bo[buf].buflisted
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function minidiff_set_ref(diff, buf, state)
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local relpath = vim.fs.relpath(state.root, path)
  if not relpath or relpath == ".." or relpath:sub(1, 3) == "../" then
    return
  end

  local out = git({ "show", state.resolved .. ":" .. relpath }, state.root)
  local text = out.code == 0 and (out.stdout or "") or ""
  text = text:gsub("\r\n", "\n")
  if text:sub(-1) ~= "\n" then
    text = text .. "\n"
  end
  if minidiff_buffers[buf] then
    minidiff_buffers[buf].ref_text = text
  end
  diff.set_ref_text(buf, text)
end

local function minidiff_source(diff, state)
  return {
    name = "diffbase",
    attach = function(buf)
      local ok, err = pcall(minidiff_set_ref, diff, buf, state)
      if not ok then
        M.notify("mini.diff adapter failed: " .. err, vim.log.levels.WARN)
      end
    end,
    apply_hunks = function()
      M.notify("Clear the diff base before staging hunks", vim.log.levels.WARN)
    end,
  }
end

local function minidiff_apply(diff, buf, state)
  if not minidiff_eligible(buf) or repo_root(buf) ~= state.root then
    return
  end

  local saved = minidiff_buffers[buf]
  if saved and saved.resolved == state.resolved then
    return
  end
  if not saved then
    local config = vim.b[buf].minidiff_config
    local normally_enabled = diff.get_buf_data(buf) ~= nil
      or (vim.g.minidiff_disable ~= true and vim.b[buf].minidiff_disable ~= true)
    saved = {
      config = config == nil and NO_CONFIG or vim.deepcopy(config),
      enabled = normally_enabled,
    }
    minidiff_buffers[buf] = saved
  end

  local config = vim.b[buf].minidiff_config or {}
  config = vim.deepcopy(config)
  config.source = minidiff_source(diff, state)
  vim.b[buf].minidiff_config = config
  saved.resolved = state.resolved

  diff.disable(buf)
  diff.enable(buf)
end

local function minidiff_restore(diff, buf)
  local saved = minidiff_buffers[buf]
  if not saved then
    return
  end
  minidiff_buffers[buf] = nil

  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  diff.disable(buf)
  if saved.config == NO_CONFIG then
    vim.b[buf].minidiff_config = nil
  else
    vim.b[buf].minidiff_config = saved.config
  end
  if saved.enabled and minidiff_eligible(buf) then
    diff.enable(buf)
  end
end

M.adapters.minidiff = function(state, buf)
  if not load_plugin("mini.diff") then
    return
  end
  local diff = require("mini.diff")

  if state.resolved then
    local buffers = buf and { buf } or vim.api.nvim_list_bufs()
    for _, target in ipairs(buffers) do
      local ok, err = pcall(minidiff_apply, diff, target, state)
      if not ok then
        M.notify(("mini.diff adapter failed for buffer %d: %s"):format(target, err), vim.log.levels.WARN)
      end
    end
    return
  end

  local buffers = {}
  if buf then
    buffers[1] = buf
  else
    for target in pairs(minidiff_buffers) do
      buffers[#buffers + 1] = target
    end
  end
  for _, target in ipairs(buffers) do
    local ok, err = pcall(minidiff_restore, diff, target)
    if not ok then
      M.notify(("mini.diff restore failed for buffer %d: %s"):format(target, err), vim.log.levels.WARN)
    end
  end
end

--- Re-apply the selected base when a diff plugin or new buffer becomes available.
function M.setup()
  local group = vim.api.nvim_create_augroup("diffbase_reapply", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = group,
    callback = function(args)
      if not M.state.resolved then
        return
      end
      local buf = args.data and args.data.buffer
      if not buf or vim.api.nvim_buf_is_valid(buf) then
        apply_adapters(buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost" }, {
    group = group,
    callback = function(args)
      if not M.state.resolved then
        return
      end
      apply_adapters(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniDiffUpdated",
    group = group,
    callback = function(args)
      local saved = minidiff_buffers[args.buf]
      local diff = package.loaded["mini.diff"]
      if not (saved and saved.ref_text and diff) then
        return
      end
      local data = diff.get_buf_data(args.buf)
      if data and data.ref_text ~= saved.ref_text then
        diff.set_ref_text(args.buf, saved.ref_text)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      minidiff_buffers[args.buf] = nil
    end,
  })
end

return M
