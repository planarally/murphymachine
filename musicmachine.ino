//potentiometer variables

#define RED A0
#define BLUE A1
#define YELLOW A2

#define WAVE A3

//button variables
const int buttonPins[] = {13, A5, 21};
const int numberOfButtons = sizeof(buttonPins) / sizeof(buttonPins[0]);

int buttonStates[numberOfButtons];
int lastButtonStates[numberOfButtons];

int currentStates[numberOfButtons];
int numberOfStates = 4;

void setup() {
  for (int i = 0; i < numberOfButtons; i++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
  Serial.begin(9600);
}

void loop() {

  //potentiometer reads

  int redVal = analogRead(RED);
  int blueVal = analogRead(BLUE);
  int yellowVal = analogRead(YELLOW);
  int waveVal = analogRead(WAVE);


  //button changes between 4 states based on how many times it is pressed

  for (int i = 0; i < numberOfButtons; i++) {
    buttonStates[i] = digitalRead(buttonPins[i]);

    if (buttonStates[i] == LOW && lastButtonStates[i] == HIGH) {
      // Button is pressed
      currentStates[i] = (currentStates[i] + 1) % numberOfStates;
    }

    lastButtonStates[i] = buttonStates[i];

    // //button reads
    Serial.print(currentStates[0]);
    Serial.print(',');
    Serial.print(currentStates[1]);
    Serial.print(',');
    Serial.print(currentStates[2]);
    Serial.print(',');
    
  }

//potreads
  Serial.print(redVal);
  Serial.print(',');
  Serial.print(blueVal);
  Serial.print(',');
  Serial.print(yellowVal);
  Serial.print(',');
  Serial.println(waveVal);

  delay(100);

}
