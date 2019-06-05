require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
local USE_DBG = false
dbg = function (msg)
  if USE_DBG then
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "DBG MSG:",
      text = msg })
  end
end

dbgclient = function (event_name, c)
  dbg(event_name.." "..tostring(c.pid).." "..tostring(c.window).." "..(c.class or "_c").." "..(c.name or "_n"))
end
if awesome.startup_errors then
  if USE_DBG then
    naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors })
  end
end
do
  local in_error = false
  awesome.add_signal("debug::error", function (err)
    if USE_DBG then
      if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = err })
      in_error = false
    end
  end)
end
onboard = {}
home_screen = {}

focus_next_client = function ()
  if awful.client.next(1) == home_screen.client then
    awful.client.focus.byidx( 2 )
  else
    awful.client.focus.byidx( 1 )
  end

  if client.focus then
    client.focus:raise()
  end
end

focus_client_by_window_id = function (window_id)
  for _, c in ipairs(client.get()) do
    if c.window == window_id then
      client.focus = c
      if client.focus then
        client.focus:raise()
      end
    end
  end
end

launch_home_screen = function ()
  if home_screen.client then
    client:kill()
    home_screen = {}
  end
  awful.util.spawn_with_shell("/home/chip/launcher/load.sh")
end

focus_home_screen = function ()
  if home_screen.client then
    client.focus = home_screen.client
    if client.focus then
      client.focus:raise()
    end
  else
    launch_home_screen()
  end
end

hide_mouse_cursor = function ()
  awful.util.spawn_with_shell("xsetroot -cursor $HOME/.config/awesome/blank_ptr.xbm $HOME/.config/awesome/blank_ptr.xbm")
end

beautiful.init("/home/chip/launcher/awesome/themes/default/theme.lua")

local terminal = "xterm"
local editor = os.getenv("EDITOR") or "editor"
local editor_cmd = terminal .. " -e " .. editor
local modkey = "Mod1"

local layouts =
  {
    awful.layout.suit.max.fullscreen,
  }
local tags = {}
for s = 1, screen.count() do
  tags[s] = awful.tag({ 1 }, s, layouts[1])
end
root.buttons(awful.util.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
local globalkeys = awful.util.table.join(
  awful.key({ }                  , "XF86PowerOff", focus_home_screen),
  awful.key({ modkey,           }, "Tab", focus_next_client),
  awful.key({ "Control",        }, "Tab", focus_next_client),
  awful.key({ modkey,           }, "Return", function () awful.util.spawn("dmenu_run", false) end)
)

local clientkeys = awful.util.table.join(
  awful.key({ "Control"         }, "q",
    function (c)
      if c ~= home_screen.client then
        c:kill()
      end
    end)
)
local keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

local clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ "Control" }, 1, function (c) awful.util.spawn("xdotool click 3", false) end))

root.keys(globalkeys)

awful.rules.rules = {
  { rule = { },
    properties = { border_width = 0,
      border_color = beautiful.border_normal,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons } }
}

client.add_signal("focus", function (c)
  hide_mouse_cursor()
end)

client.add_signal("unfocus", function (c)
  if c == onboard.client then
    awful.util.spawn("xdotool search --name ahoy windowactivate", false)
  end
end)

client.add_signal("manage", function (c, startup)
  if c.name == "run.py" then
    home_screen.client = c
  elseif c.class == "ahoy" then
    onboard.client = c
    c.ontop = true
  end

  if not startup then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)
client.add_signal("unmanage", function (c)
  if c.name == "run.py" then
    home_screen = {}
  elseif c.class == "ahoy" then
    onboard = {}
  end
end)


hide_mouse_cursor()
awful.util.spawn_with_shell("/usr/sbin/pocketchip-load")
awful.util.spawn_with_shell("onboard $HOME/.config/onboard /usr/share/pocketchip-onboard/")
launch_home_screen()
