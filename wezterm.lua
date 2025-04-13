local wezterm = require('wezterm')

local act = wezterm.action
local act_cb = wezterm.action_callback
local config = wezterm.config_builder()

local function is_tmux(pane)
  local proc_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
  return proc_name == 'tmux'
end

config.color_scheme = 'nord'
config.font = wezterm.font('Maple Mono NF')
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }
config.window_frame = { font_size = 13 }
config.window_decorations = 'RESIZE'
config.font_size = 16
config.window_close_confirmation = 'NeverPrompt'
config.automatically_reload_config = false

config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 5000 }
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey({ key = 'b', mods = 'ALT' }),
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey({ key = 'f', mods = 'ALT' }),
  },
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey({ key = 'a', mods = 'CTRL' }),
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey({ key = 'e', mods = 'CTRL' }),
  },
  {
    key = 'Backspace',
    mods = 'CMD',
    action = act.SendKey({ key = 'u', mods = 'CTRL' }),
  },
  {
    key = 's',
    mods = 'LEADER',
    action = act.SplitVertical,
  },
  {
    key = 'v',
    mods = 'LEADER',
    action = act.SplitHorizontal,
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Left'),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Right'),
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Down'),
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection('Up'),
  },
  {
    key = 'h',
    mods = 'CTRL',
    action = act_cb(function(win, pane)
      if is_tmux(pane) then
        win:perform_action({ SendKey = { key = 'h', mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = 'Left' }, pane)
      end
    end),
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = act_cb(function(win, pane)
      if is_tmux(pane) then
        win:perform_action({ SendKey = { key = 'l', mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = 'Right' }, pane)
      end
    end),
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = act_cb(function(win, pane)
      if is_tmux(pane) then
        win:perform_action({ SendKey = { key = 'j', mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = 'Down' }, pane)
      end
    end),
  },
  {

    key = 'k',
    mods = 'CTRL',
    action = act_cb(function(win, pane)
      if is_tmux(pane) then
        win:perform_action({ SendKey = { key = 'k', mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = 'Up' }, pane)
      end
    end),
  },

  {
    key = 't',
    mods = 'LEADER',
    action = act.ActivateCommandPalette,
  },
  {
    key = 'd',
    mods = 'LEADER',
    action = act.ShowDebugOverlay,
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
  {
    key = 'C',
    mods = 'LEADER',
    action = act.QuickSelect,
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'q',
    mods = 'LEADER',
    action = act.CloseCurrentPane({ confirm = true }),
  },
  {
    key = 'Q',
    mods = 'LEADER',
    action = act.CloseCurrentTab({ confirm = true }),
  },
  {
    key = 'R',
    mods = 'LEADER',
    action = act.ReloadConfiguration,
  },
}

wezterm.on('window-config-reloaded', function(window, pane)
  window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
end)

return config
