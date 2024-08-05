-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Macchiato"

-- set up font
config.font = wezterm.font("IosevkaTerm Nerd Font")
config.font_size = 19

config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 10000

config.audible_bell = "Disabled"

-- tabbar customization
-- https://github.com/nekowinston/wezterm-bar/tree/main
wezterm.plugin.require("https://github.com/nekowinston/wezterm-bar").apply_to_config(config, {
	position = "top",
	max_width = 32,
	dividers = "slant_left", -- or "slant_left", "arrows", "rounded", false
	indicator = {
		leader = {
			enabled = true,
			off = " ",
			on = " ",
		},
		mode = {
			enabled = true,
			names = {
				resize_mode = "RESIZE",
				copy_mode = "VISUAL",
				search_mode = "SEARCH",
			},
		},
	},
	tabs = {
		numerals = "arabic", -- or "roman"
		pane_count = "superscript", -- or "subscript", false
		brackets = {
			active = { "", ":" },
			inactive = { "", ":" },
		},
	},
	clock = { -- note that this overrides the whole set_right_status
		enabled = true,
		format = "%H:%M", -- use https://wezfurlong.org/wezterm/config/lua/wezterm.time/Time/format.html
	},
})

-- and finally, return the configuration to wezterm
return config
