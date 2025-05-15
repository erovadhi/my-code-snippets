local wezterm = require 'wezterm'

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
local zoomed = ' 🗗 '
if tab.active_pane.is_zoomed then
    zoomed = ' 🗖 '
end

local index = ''
if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end

    return zoomed .. index .. tab.active_pane.title
    end)

function scheme_for_appearance(appearance)
if appearance:find 'Dark' then
    return 'Dracula'
    else
        return 'Piatto Light'
        end
        end

        function window_frame_for_appearance(appearance)
        local window_frame

        if appearance:find 'Dark' then
            -- Dark Mode. Based on Dracula colours.
            window_frame = {
                inactive_titlebar_fg = '#666',
                inactive_titlebar_bg = '#1e1f29',
                active_titlebar_bg = '#1e1f29',
                active_titlebar_fg = '#f8f8f2',
                active_titlebar_border_bottom = '#1e1f29',
                inactive_titlebar_border_bottom = '#1e1f29',
                button_fg = '#f8f8f2',
                button_bg = '#1e1f29',
                button_hover_fg = '#f8f8f2',
                button_hover_bg = '#44475a'
            }
            else
                -- Light Mode. Based on dayfox colours.
                window_frame = {
                    inactive_titlebar_fg = '#ccc',
                    inactive_titlebar_bg = '#eaeaea',
                    active_titlebar_bg = '#eaeaea',
                    active_titlebar_fg = '#666',
                    active_titlebar_border_bottom = '#eaeaea',
                    inactive_titlebar_border_bottom = 'white',
                    button_fg = '#666',
                    button_bg = '#eaeaea',
                    button_hover_fg = '#333',
                    button_hover_bg = '#ddd'
                }
                end

                -- Elements common to both colour schemes.
                window_frame.font = wezterm.font { family = 'Hack', weight = 'Regular' }
                window_frame.font_size = 10

                return window_frame
                end


                return {
                    adjust_window_size_when_changing_font_size = false,
                    color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
                    font = wezterm.font 'Hack',
                    font_size = 11.0,
                    hide_tab_bar_if_only_one_tab = true,
                    enable_wayland = true,
                    leader = { key = 'a', mods = 'CTRL' },

                    -- This makes WezTerm appear almost native on GNOME when combined
                    -- with the Rounded Window Corners extension.
                    -- However, it does not appear to behaving well with the
                    -- Tiling Assistant extension. Does not tile correctly.
                    -- window_decorations = "NONE",

                    window_padding = {
                        left = 20,
                        right = 20,
                        top = 20,
                        bottom = 0,
                    },

                    -- This is for light mode.
                    -- TODO: Also create style for dark mode and use the system setting to change it.
                    window_frame = window_frame_for_appearance(wezterm.gui.get_appearance()),

                    -- Ditto, these colors are for light mode.
                    colors = {
                        tab_bar = {
                            active_tab = {
                                bg_color = '#ddd',
                                fg_color = '#666'
                            },

                            inactive_tab = {
                                bg_color = '#eee',
                                fg_color = '#ccc'
                            },
                            inactive_tab_hover = {
                                bg_color = '#bbb',
                                fg_color = '#555'
                            },

                            new_tab = {
                                bg_color = '#efefef',
                                fg_color = '#333'
                            },
                            new_tab_hover = {
                                bg_color = '#bbb',
                                fg_color = '#555'
                            }
                        }
                    },

                    inactive_pane_hsb = {
                        saturation = 0.8,
                        brightness = 0.3,
                    },

                    keys = {
                        -- Split panel to the right.
                        {
                            key = 'r',
                            mods = 'CTRL|SHIFT',
                            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
                        },
                        {
                            key = 'd',
                            mods = 'CTRL|SHIFT',
                            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
                        },
                        {
                            key = 'r',
                            mods= 'CTRL|SHIFT|SUPER',
                            action = wezterm.action.SplitPane {
                                direction = 'Right',
                                top_level = true
                            }
                        },
                        {
                            key = 'd',
                            mods= 'CTRL|SHIFT|SUPER',
                            action = wezterm.action.SplitPane {
                                direction = 'Down',
                                top_level = true
                            },
                        },
                        -- Rotate panes --
                        -- See https://wezfurlong.org/wezterm/config/lua/keyassignment/RotatePanes.html --
                        {
                            key = 'LeftArrow',
                            mods = 'CTRL|SHIFT|SUPER',
                            action = wezterm.action.RotatePanes 'CounterClockwise',
                        },
                        {
                            key = 'RightArrow',
                            mods = 'CTRL|SHIFT|SUPER',
                            action = wezterm.action.RotatePanes 'Clockwise',
                        },
                        { key = 'LeftArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
                        { key = 'DownArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
                        { key = 'UpArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
                        { key = 'RightArrow', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
                        -- Thanks to https://gist.github.com/frabjous/28263aadd401ebca85e693b766537379
                        -- ctrl-c either copy or interrupts depending on selection
                        {
                            key = "c",
                            mods = "CTRL",
                            action = wezterm.action_callback(function(window, pane)
                            local has_selection = (
                                window:get_selection_text_for_pane(pane) ~= ""
                            )
                            if (has_selection) then
                                window:perform_action(
                                    wezterm.action({
                                        CopyTo="ClipboardAndPrimarySelection"
                                    }),
                                    pane
                                )
                                -- not implemented yet; don't want it probably
                                -- window:perform_action("ClearSelection", pane)
                            else
                                window:perform_action(
                                    wezterm.action({
                                        SendKey = { key = "c", mods = "CTRL"}
                                    }),
                                    pane
                                )
                                end
                                end)
                        },
                        -- ctrl-v and shift-ctrl-v pastes
                        { key = "v", mods = "CTRL", action = wezterm.action({
                            PasteFrom = "Clipboard"
                        })},
                        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action({
                            PasteFrom = "Clipboard"
                        })},
                    }
                }
