// Code for an R-2R ladder DAC
// Set this to be the least significant bit pin of your DAC -
// other pins in descending order.
int b0 = 13;
// Number of bits
int bits = 9;

void setup() {
  Serial.begin(9600);
  for(int i=0;i<bits;i++) {
      pinMode(b0-i,OUTPUT);
  }
  
  for(int i=0;i<(1<<bits);i++) {
     setR2R(i);
     int a = analogRead(A0);
    Serial.print(i);
     Serial.print("\t");
    Serial.println(a); 
  }
}

void setR2R(int v) {
   for(int b=0;b<bits;b++) {
    digitalWrite(b0-b, v % 2);
      v >>= 1;
   } 
}

void loop() {
  // put your main code here, to run repeatedly: 
  
}
