# -*- coding: utf-8 -*- 

CurKeySet = "PC" ## >>>    PC or GameShell   <<<

DontLeave = False

BackLight = "/sys/class/backlight/backlight/brightness"
AudioControl = "Power Amplifier"

# We don't use a real device here, just two files: voltage and charging
Battery   =  {}
Battery["charging"] = "/usr/lib/pocketchip-batt/charging"
Battery["voltage"] = "/usr/lib/pocketchip-batt/voltage"

UPDATE_URL="https://raw.githubusercontent.com/clockworkpi/CPI/master/launcher_ver.json"

VERSION="pocket 1.24"

SKIN="../skin/pocket"

## three timer values in seconds: dim screen, close screen,PowerOff
## zero means no action
PowerLevels = {}
PowerLevels["supersaving"] = [10,30,120]
PowerLevels["powersaving"] = [40,120,300]
PowerLevels["server"]      = [40,120,0]
PowerLevels["balance_saving"] = [40,0,0]

PowerLevel = "balance_saving"

##sys.py/.powerlevel

