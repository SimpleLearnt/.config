-- jupytext :: open .ipynb files as plain text
--
-- Notebooks are JSON with embedded outputs -- unreadable and unmergeable in an
-- editor. This converts on read and back on write, so you edit a .ipynb as
-- ordinary Python and it stays a valid notebook on disk.
--
-- Pairs with molten: jupytext gives you the CODE as text, molten runs it and
-- (via :MoltenImportOutput / :MoltenExportOutput) round-trips the OUTPUTS.
--
-- Requires the `jupytext` CLI on PATH -- see the install notes.

return {
  "GCBallesteros/jupytext.nvim",
  lazy = false, -- must be loaded before a .ipynb is opened, not after

  opts = {
    -- "hydrogen" style writes cells as `# %%` markers in a normal .py file,
    -- which is the format molten's cell navigation understands and which every
    -- other Python tool can still read.
    style = "hydrogen",
    output_extension = "auto",
    force_ft = nil,
  },
}
