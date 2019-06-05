# GameShell launcher for PocketCHIP

This is the Launcher from the Gameshell, ported over to the PocketCHIP.

![](https://media.discordapp.net/attachments/422472890441793539/585821529913425923/2019-06-05-132318_480x272_scrot.png)

### Note

This is has been tested on my own PocketCHIP to ensure repeatability a couple of times, but you might encounter your own probems if you don't have a working `apt` for example.

## Installation

```
cd ~
git clone https://github.com/omgmog/launcher.git
cd launcher
chmod +x install.sh
bash ./install.sh
```

## Uninstallation

Uninstallation is quite lazy, it just restores the awesomewm config, and re-installs `pocket-home`.

```
bash ./install.sh -u
```

## Button configuration

The button layout is as follows:

- A/OK - `0`
- B/Back - `=`
- X - `9`
- Y - `-`
- D-pad - d-pad

This should be the most consistent with what you're used to on PocketCHIP, while also providing the additional buttons that the launcher uses.

You can also use `enter` to select things, and `escape` to go back.

The usual `ctrl`+`tab` and `ctrl`+`q` shortcuts from `pocket-home` will work everywhere too.

## Known problems and missing features

- Wifi GUI is a bit buggy so I've disabled it in the Settings menu.
- Battery display isn't hooked up yet, so I've disabled it for now
- There are still some references to ClockworkPi/Gameshell here and there...
- The brightness sometimes sets itself to the lowest value. For now, you can go to settings and turn the brightness back up yourself.
- Not all new strings are localized yet.

## Help!

Having problems with anything? Check these common problems below, or raise an issue:

#### Shutdown and Restart in the _PowerOFF_ menu don't do anything!

You need to make your user account (`chip`) passwordlessly use `sudo` for `shutdown` and `rebout`.

First, open `visudo` to edit the `sudoers` file

```
sudo visudo
``` 

Then add the following lines at the end of the file:

```
chip ALL = (root) NOPASSWD: /sbin/reboot
chip ALL = (root) NOPASSWD: /sbin/shutdown

# You can do this for any command, or make your sudo entirely
# passwordless... I wouldn't recommend that though...
```

Save and close `visudo` (this should use `nano` by default on the CHIP, so it's `ctrl`+`x` followed by `y` to save/close)

Now you should be able to Shutdown and Restart from the _PowerOFF_ menu.
