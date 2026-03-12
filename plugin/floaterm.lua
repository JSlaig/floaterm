vim.api.nvim_create_user_command("FloatermToggle", function()
  require("floaterm").toggle()
end, {})

vim.api.nvim_create_user_command("FloatermOpenInNewTerm", function()
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

vim.api.nvim_create_user_command("FloatermExec", function(opts)
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


