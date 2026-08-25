-- mini.pairs :: auto-insert and auto-delete bracket / quote pairs
--
-- Typing ( gives (), backspacing between them removes both.
--
-- The `neigh_pattern` entries stop it firing where a pair would be wrong --
-- most importantly, not auto-closing a quote when the cursor is already
-- against a word character, so typing an apostrophe in prose does not produce
-- `don''t`.

return {
  "echasnovski/mini.pairs",
  event = "InsertEnter",

  opts = {
    modes = { insert = true, command = false, terminal = false },

    mappings = {
      -- Do not auto-close before a word character.
      ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%w]" },
      ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%w]" },
      ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%w]" },

      -- Quotes: also skip inside strings/comments is not possible without
      -- treesitter, so the neighbour check does the heavy lifting.
      ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\][^%w]", register = { cr = false } },
      ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\][^%w]", register = { cr = false } },
      ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\][^%w]", register = { cr = false } },
    },
  },
}
