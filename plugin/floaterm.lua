vim.api.nvim_create_user_command("FloatermToggle", function()
  require("floaterm").toggle()
end, {})

vim.api.nvim_create_user_command("FloatermOpenInNewTerm", function()
  require("floaterm").open()
  require("floaterm.api").new_term()
end, {})


