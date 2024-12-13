#define FADER_ONE 13    
#define SPEED_ONE 2    
#define FADER_TWO 33    
#define SPEED_TWO 32    


void setup() {
  Serial.begin(115200); // Initialize serial communication
  pinMode(FADER_ONE, INPUT);
  pinMode(SPEED_ONE, INPUT);
  pinMode(FADER_TWO, INPUT);
  pinMode(SPEED_TWO, INPUT);
}

void loop() {
  int faderOne = analogRead(FADER_ONE);
  int speedOne = analogRead(SPEED_ONE);
  int faderTwo = analogRead(FADER_TWO);
  int speedTwo = analogRead(SPEED_TWO);
  Serial.printf("%d,%d,%d,%d\n", faderOne, speedOne, faderTwo, speedTwo);  
  delay(200);                    // Small delay for stability
}