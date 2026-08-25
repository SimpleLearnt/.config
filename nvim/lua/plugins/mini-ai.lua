-- mini.ai :: better `a` / `i` text objects
--
-- Adds next/last variants to Vim's builtin objects: `cin(` changes inside the
-- NEXT parens, `dal"` deletes around the LAST quotes. Also smarter quote and
-- bracket detection than the builtins.
--
-- OVERLAP WITH nvim-treesitter-textobjects -- resolved, not ignored:
-- textobjects maps the two-character sequences af/if, ac/ic, aa/ia, al/il,
-- ai/ii directly. mini.ai maps single-character `a` and `i` and then reads the
-- next key. Vim resolves the longest match, so the explicit two-char maps win
-- for code objects while mini.ai handles everything else -- ( [ { " ' ` b q t
-- and the next/last variants.
--
-- No perceptible delay: `da(` resolves the moment `(` is typed, because no
-- mapping `a(` exists. A pause is only possible if you type `da` and then stop.

return {
  "echasnovski/mini.ai",
  event = { "BufReadPost", "BufNewFile" },

  opts = function()
    return {
      -- How far to look for the next/last occurrence.
      n_lines = 500,

      -- Treesitter-backed code objects deliberately NOT declared here; see
      -- the header. mini.ai keeps its own defaults for delimiters.
      custom_textobjects = nil,
    }
  end,
}
