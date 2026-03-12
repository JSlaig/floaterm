vim.api.nvim_create_user_command("FloatermToggle", function()
  require("floaterm").toggle()
end, {})

vim.api.nvim_create_user_command("FloatermNewTerm", function()
  local state = require("floaterm.state")
  if not state.volt_set then
    require("floaterm").open()
    require("floaterm.api").new_term()
  else
    require("floaterm").toggle()
  end
end, {})

vim.api.nvim_create_user_command("FloatermSend", function(opts)
  local cmd = opts.args
  require("floaterm.api").send_cmd({ cmd = cmd })
end, { nargs = "*" })

vim.api.nvim_create_user_command("FloatermSendNew", function(opts)
  local args = opts.args
  local state = require("floaterm.state")
  
  -- Parse arguments: format "name:command" or just "command"
  local name, cmd
  local colon_pos = args:find(":")
  if colon_pos then
    name = args:sub(1, colon_pos - 1)
    cmd = args:sub(colon_pos + 1)
  else
    cmd = args
  end
  
  if not state.volt_set then
    require("floaterm").open()
  end
  
  local term_opts = { cmd = cmd }
  if name and name ~= "" then
    term_opts.name = name
  end
  
  require("floaterm.api").new_term(term_opts)
end, { nargs = "*" })

vim.api.nvim_create_user_command("FloatermList", function()
  local state = require("floaterm.state")
  if not state.terminals or #state.terminals == 0 then
    vim.notify("No terminals available", vim.log.levels.INFO)
    return
  end
  
  local lines = {}
  for i, term in ipairs(state.terminals) do
    table.insert(lines, string.format("%d: %s", i, term.name or "Terminal"))
  end
  
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("FloatermSendBg", function(opts)
  local args = opts.args
  local state = require("floaterm.state")
  
  -- Parse arguments: format "name:command" or just "command"
  local name, cmd
  local colon_pos = args:find(":")
  if colon_pos then
    name = args:sub(1, colon_pos - 1)
    cmd = args:sub(colon_pos + 1)
  else
    cmd = args
  end
  
  -- Ensure floaterm is initialized (but don't show it)
  if not state.volt_set then
    require("floaterm").open()
    require("floaterm").toggle() -- Hide it immediately
  end
  
  -- Find or create terminal
  local target_term = nil
  if name and name ~= "" then
    local bufdetails = require("floaterm.utils").get_term_by_key(name, "name")
    if bufdetails then
      target_term = bufdetails[2]
    end
  end
  
  -- Always create new terminal for SendBg (don't reuse existing ones)
  -- This ensures the command runs in background without showing terminal
  local term_opts = { cmd = cmd, hidden = true }
  if name and name ~= "" then
    term_opts.name = name
  end
  require("floaterm.api").new_term(term_opts)
end, { nargs = "*" })


