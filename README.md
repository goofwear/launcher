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

## Adding new shortcuts

To add a new shortcut, create a `.sh` file in the `~/launcher/Menu/GameShell` directory (you can copy one of the others).

The filename indicates the order, and must start with a number and underscore:

```
NN_Name Of Shortcut.sh
```

To set an icon for the shortcut, you need to add an 80x80 png in `~/launcher/skin/pocket/Menu/GameShell` with a filename that matches the app shortcut, but without the number and underscore prefix:

```
Name Of Shortcut.png
```

If you don't have an icon, the launcher will use the first letters of the shortcut and the blank icon found at `~/launcher/skin/pocket/sys.py/gameshell/blank.png`

If you have problems with applications not using the whole screen, or failing to start, you can try specifying the display at the start of your command, e.g.:

```
DISPLAY=":0" leafpad
```

Other than that, you can follow the instructions from the Gameshell wiki for launching games in emulators directly, if you have `retroarch` installed on your PocketCHIP: https://github.com/clockworkpi/GameShellDocs/wiki/New-ICONS-that-start-games-in-one-click-from-the-MENU

## Known problems and missing features

I've raised [issues](https://github.com/omgmog/launcher/issues) for everything I'm aware of. If you notice something else, please raise an issue!

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
