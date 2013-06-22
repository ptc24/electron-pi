#include <Wire.h>
#include <Adafruit_MCP4725.h>

Adafruit_MCP4725 dac;

void setup(void) {
  Serial.begin(9600);
  
  // Cribbed from the Adafruit tutorial
  dac.begin(0x62);
  long c;
    // Run through the full 12-bit scale
    for(c=0;c<4095;c++) {
      dac.setVoltage(c, false);
      Serial.print(c);
      Serial.print(",");
      Serial.println(analogRead(A0));
    }
    for(c=4095;c>0;c--) {
      dac.setVoltage(c, false);
      Serial.print(c);
      Serial.print(",");
      Serial.println(analogRead(A0));
    }
}

void loop(void) {
  // This is all controlled via the reset button
}
