local ls = require "luasnip"
local types = require "luasnip.util.types"

--ls.config.set_config {
--history = true,
--
--updateevents = "TextChanged,TextChangedI",
--
--enable_autosnippets = true,
--ext_opts = {
--[types.choiceNode] = {
--active = {
--virt_text = { { "<-", "Error" } }
--}
--}
--}
--}
--
---- expand sninpped
--vim.keymap.set({ "i", "s" }, "<c-k>", function()
--if ls.expand_or_jumpable() then
--ls.expand_or_jump()
--end
--end, { silent = true }
--)
--
---- go back in snippet
--vim.keymap.set({ "i", "s" }, "<c-j>", function()
--if ls.jumpable(-1) then
--ls.jump(-1)
--end
--end, { silent = true }
--)
--
---- selecting with a list of options
--vim.keymap.set("i", "<c-l>", function()
--if ls.choice_active() then
--ls.change_choice(1)
--end
--end)

ls.add_snippets("all", {
	--available in any filetype
	ls.parser.parse_snippet("expand", "--this is wwww"),
})
