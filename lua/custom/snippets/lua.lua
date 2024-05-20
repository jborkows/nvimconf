require('luasnip.session.snippet_collection').clear_snippets 'lua'

local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local rep = require('luasnip.extras').rep
local fmt = require('luasnip.extras.fmt').fmt
ls.add_snippets('lua', {
  s('ma',
    fmt('local {} = {{}}\nfor _,elem in ipairs({}) do\n table.insert({}, {}(elem)) \nend\n{}',
      { i(1), i(2), rep(1), i(3), i(4) })),
})
