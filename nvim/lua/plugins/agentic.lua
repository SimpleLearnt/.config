-- agentic :: Grok as an in-editor agent, over ACP
--
-- The other side of the choice described in sidekick.lua. Grok Build speaks the
-- Agent Client Protocol natively -- `grok agent stdio`, JSON-RPC over
-- stdin/stdout -- so the agent never gets a terminal. It asks Neovim to make
-- edits, and this plugin renders them as diffs you approve before anything
-- reaches disk.
--
-- That is also the honest answer to "live updates": there is no reload step,
-- because the edit arrives as buffer state rather than as a file that changed
-- underneath you.
--
-- Requires the `grok` binary plus a completed `grok login` -- the OAuth token
-- is cached in ~/.grok/auth.json, so no API key needs to reach this config.

return {
  "carlos-algms/agentic.nvim",

  opts = {
    provider = "grok",

    -- Upstream ships entries for claude/gemini/codex/opencode and friends;
    -- Grok is not among them, so it is registered by hand. `stdio` is the ACP
    -- mode -- `grok agent --help` lists it alongside headless/serve/leader.
    acp_providers = {
      grok = {
        name = "Grok",
        command = "grok",
        args = { "agent", "stdio" },
      },
    },
  },

  keys = {
    -- Upstream's defaults are <C-\>, <C-'> and <C-,>. Moved onto <leader>i to
    -- match the rest of this config, and because <C-\> is already yazi's
    -- change-working-directory inside its float -- same key, two meanings,
    -- depending on which window has focus.
    {
      "<leader>ii",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v" },
      desc = "Grok (toggle)",
    },
    {
      "<leader>ic",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file/selection to context",
    },
    {
      "<leader>in",
      function()
        require("agentic").new_session()
      end,
      desc = "New session",
    },
    {
      "<leader>is",
      function()
        require("agentic").select_session()
      end,
      desc = "Switch session",
    },

    -- Feeds the buffer's diagnostics straight in, which is the one thing a
    -- terminal-wrapped CLI cannot see without you pasting it.
    {
      "<leader>id",
      function()
        require("agentic").add_buffer_diagnostics()
      end,
      desc = "Send buffer diagnostics",
    },
    {
      "<leader>ix",
      function()
        require("agentic").stop_generation()
      end,
      desc = "Stop generation",
    },
  },
}
