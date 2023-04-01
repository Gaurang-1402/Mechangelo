// Define the pins for the LED
const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

void setup() {
  // Start the serial communication
  Serial.begin(9600);
  // Set the pins as outputs
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  // Wait for input from the serial monitor
  while (Serial.available() < 3) {
    // Do nothing
  }
  // Read the input bytes and convert to integers
  int redValue = 255-Serial.parseInt();
  int greenValue = 255-Serial.parseInt();
  int blueValue = 255-Serial.parseInt();
  // Map the values from 0-255 to 0-1023 (for the Teensy's 10-bit PWM)

  // Set the PWM values for each pin
  analogWrite(redPin, redValue);
  analogWrite(greenPin, greenValue);
  analogWrite(bluePin, blueValue);
  // Wait for the next input
  Serial.read();
}
