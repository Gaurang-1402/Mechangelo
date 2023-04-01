const int PIN_RED   = 6;
const int PIN_GREEN = 5;
const int PIN_BLUE  = 3;

void setup() {
  pinMode(PIN_RED,   OUTPUT);
  pinMode(PIN_GREEN, OUTPUT);
  pinMode(PIN_BLUE,  OUTPUT);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    String inputLine = Serial.readStringUntil('\n');
    char inputStr[inputLine.length() + 1];
    inputLine.toCharArray(inputStr, sizeof(inputStr));

    int R, G, B;
    if (sscanf(inputStr, "%d %d %d", &R, &G, &B) == 3) {
      writeRGB(R, G, B);
      Serial.print("RGB set to: ");
      Serial.print(R);
      Serial.print(", ");
      Serial.print(G);
      Serial.print(", ");
      Serial.println(B);
    } else {
      Serial.println("Invalid input. Please enter three integers separated by whitespaces.");
    }
  }
}

void writeRGB(int R, int G, int B) {
  analogWrite(PIN_RED, R);
  analogWrite(PIN_GREEN, G);
  analogWrite(PIN_BLUE, B);
}
