-----------------
---- GENERAL ----
-----------------
-- Was: conf/general.conf

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 8,

    border_size = 2,

    col = {
      active_border = {
        colors = { "rgba(c63d7cff)", "rgba(9eced4ff)" },
        angle = 45,
      },
      inactive_border = "rgba(BD9FDFff)",
    },

    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },
})
