// Define the pins for the LED
const int redPin = 15;
const int greenPin = 14;
const int bluePin = 37;

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
  int redValue = Serial.parseInt();
  int greenValue = Serial.parseInt();
  int blueValue = Serial.parseInt();
  // Map the values from 0-255 to 0-1023 (for the Teensy's 10-bit PWM)

  redValue = 255 - redValue;
  greenValue = 255 - greenValue;
  blueValue = 255 - blueValue;
  

  // full red is 0, 255, 255
  redValue = map(redValue, 0, 255, 0, 1023);

  // full green is 255, 0, 255
  greenValue = map(greenValue, 0, 255, 0, 1023);

  // full blue is 255, 255, 0
  blueValue = map(blueValue, 0, 255, 0, 1023);
  
  // Set the PWM values for each pin
  analogWrite(redPin, redValue);
  analogWrite(greenPin, greenValue);
  analogWrite(bluePin, blueValue);
  // Wait for the next input
  Serial.read();
}
