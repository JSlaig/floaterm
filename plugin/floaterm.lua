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

vim.api.nvim_create_user_command("FloatermSendNew", function(opts)
  local cmd = opts.args
  local state = require("floaterm.state")
  
  if not state.volt_set then
    require("floaterm").open()
  end
  require("floaterm.api").new_term({ cmd = cmd })
end, { nargs = "*" })


