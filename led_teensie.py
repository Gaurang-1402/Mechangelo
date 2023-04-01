import board
import digitalio
import time

leds=[]
for pin in [board.A0,board.A1,board.D37]:
        dd=digitalio.DigitalInOut(pin)
        dd.direction=digitalio.Direction.OUTPUT
        leds.append(dd)

r,g,b=leds

while True:
        r.value,g.value,b.value=0,1,1;time.sleep(.5)
        r.value,g.value,b.value=1,0,1;time.sleep(.5)
        r.value,g.value,b.value=1,1,0;time.sleep(.5)
        r.value,g.value,b.value=0,0,0;time.sleep(.5)
