local wezterm = require("wezterm")

-- ■ イベント設定：モード切替時に設定を一時的に上書きする
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()

	-- 現在の設定上書き状態を取得（なければ空のテーブル）
	local overrides = window:get_config_overrides() or {}

	if name then
		-- 【モード中】
		-- まだタブバーが出ていなければ、出すように設定変更
		if not overrides.enable_tab_bar then
			overrides.enable_tab_bar = true
			window:set_config_overrides(overrides)
		end

		-- 右上にモード名を表示（目立つように赤色などで）
		window:set_right_status(wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { AnsiColor = "Fuchsia" } }, -- ピンク色で目立たせる
			{ Text = "  MODE: " .. name .. "  " },
		}))
	else
		-- 【通常時】
		-- タブバーが出たままなら、非表示に戻す
		if overrides.enable_tab_bar then
			overrides.enable_tab_bar = false
			window:set_config_overrides(overrides)
		end

		-- ステータス文字も消す
		window:set_right_status("")
	end
end)

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 15.0
config.line_height = 1.06
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- ■ 基本設定：普段はタブバーを非表示（tmux用）
config.enable_tab_bar = false
config.use_fancy_tab_bar = false -- 出現したときもシンプルにする

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false

return config
