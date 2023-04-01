# import board
# import digitalio
# import pwmio
# import time

# # Initialize RGB LED pins
# red_pin = board.D14
# green_pin = board.A1
# blue_pin = board.D37

# red_led = pwmio.PWMOut(red_pin, frequency=5000, duty_cycle=0)
# green_led = pwmio.PWMOut(green_pin, frequency=5000, duty_cycle=0)
# blue_led = pwmio.PWMOut(blue_pin, frequency=5000, duty_cycle=0)

# i=0
# while True:

#     # try:
#     # # Wait for input of 3 bytes
#     #     input_bytes = input("")
#     #     r, g, b = map(int, input_bytes.split())

#     # except:
#     #     continue
#     i+=16
#     r,g,b=i,0,0


#     # Scale the values from 0-255 to 0-65535 (PWM duty cycle range)
#     r = int(r * 65535 / 255)
#     g = int(g * 65535 / 255)
#     b = int(b * 65535 / 255)

#     # Set the PWM duty cycles for each color
#     red_led.duty_cycle = r
#     green_led.duty_cycle = g
#     blue_led.duty_cycle = b

#     # Wait for a short time before getting the next input
#     time.sleep(0.1)

import board
import digitalio
import time


leds=[]
for pin in [board.A0,board.A1,board.D37]:
  dd=digitalio.DigitalInOut(pin)
  dd.direction=digitalio.Direction.OUTPUT
  leds.append(dd)

r,g,b=leds

r.value,g.value,b.value=0,1,1;time.sleep(.5)

while True:
    try:
    # Wait for input of 3 bytes
        input_bytes = input("")
        R, G, B = map(int, input_bytes.split())
    except:continue

    r.value,g.value,b.value=R,G,B
    # r.value,g.value,b.value=0,1,1;time.sleep(.5)
    # r.value,g.value,b.value=1,0,1;time.sleep(.5)
    # r.value,g.value,b.value=1,1,0;time.sleep(.5)
    # r.value,g.value,b.value=0,0,0;time.sleep(.5)