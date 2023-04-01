import serial
import colorsys


class LEDInterface:
    def __init__(self, baud_rate = 9600, serial_port_name: str = '/dev/tty.usbmodem86436901', rgb_max_calib = [215, 235, 255], rainbow_increment = 0.001):
        self.ser = serial.Serial(serial_port_name, 9600)
        self.rgb_max_calib = rgb_max_calib

        # rainbow_step variables
        self.rainbow_pos = 0.0
        self.rainbow_increment = rainbow_increment


    def write_rgb(self, red: int, green: int, blue: int) -> None:
        red_adjusted = red * self.rgb_max_calib[0] / 255
        green_adjusted = green * self.rgb_max_calib[1] / 255
        blue_adjusted = blue * self.rgb_max_calib[2] / 255

        self._write_rgb_raw(red_adjusted, green_adjusted, blue_adjusted)


    def rainbow_step(self) -> None:
        r, g, b = [int(x * 255) for x in colorsys.hsv_to_rgb(self.rainbow_pos, 1, 1)]
        self.write_rgb(r, g, b)

        self.rainbow_pos += self.rainbow_increment
        if self.rainbow_pos >= 1:
            self.rainbow_pos -= 1


    def rainbow_reset(self) -> None:
        self.rainbow_pos = 0.0


    def close(self) -> None:
        self.ser.close()


    def _write_rgb_raw(self, red: int, green: int, blue: int) -> None:
        bstr = (' '.join([str(int(num)) for num in [red, green, blue]]) + '\n').encode()
        print(bstr)
        self.ser.write(bstr)

def main():
    interface = LEDInterface()
    interface.write_rgb(0,0,0)
    return
    while True:
        interface.rainbow_step()
        time.sleep(0.01)