# Provides an abstraction to the battery
from config import Battery

class BatteryAbstraction:
    VoltageNow = 0
    VoltageMax = 4250    
    Charging = 0

    @classmethod
    def readV(self):
        try: 
            f = open(Battery["voltage"])
        except IOError:
            print("Couldn't read voltage!")
        else:
            with f:
                self.VoltageNow = int(f.read())

    @classmethod
    def readC(self):
        try: 
            f = open(Battery["charging"])
        except IOError:
            print("Couldn't read charge state!")
        else:
            with f:
                self.Charging = int(f.read()) == 1
    @classmethod
    def CurrentVoltage(self):
        self.readV()
        return self.VoltageNow

    @classmethod
    def MaxVoltage(self):
        return self.VoltageMax
    
    @classmethod
    def AsPercentage(self):
        self.readV()
        perc_value = int(( float(self.VoltageNow) / float(self.VoltageMax) ) * 100)
        return perc_value
    
    @classmethod
    def IsCharging(self):
        self.readC()
        return self.Charging

    @classmethod
    def test(self):
        self.readC()
        self.readV()

        print True if self.Charging > 0 else False
        print("%s percent" % self.AsPercentage())
        print("%s / %s" % (self.VoltageNow, self.VoltageMax)) 


if __name__ == '__main__':
    BatteryAbstraction.test()