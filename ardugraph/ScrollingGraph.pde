/* ScrollingGraph

Loosely inspired by the code that came with Graph.
Reads values from serial, and plots a scrolling graph - 
and a Fourier transform of the graph.

Needs the .jar file from JTransforms: 
https://sites.google.com/site/piotrwendykier/software/jtransforms

*/

import processing.serial.*;

Serial myPort;
int [] buffer;
int bpos;
FloatFFT_1D ffft;

void setup() {
  size(800, 512); 
  buffer = new int[width];
  bpos = 0;
  
  myPort = new Serial(this, Serial.list()[0],115200);
  myPort.bufferUntil('\n');
  ffft = new FloatFFT_1D(width);
}

void draw() {
   background(0);
   stroke(255);
   float [] dft = new float[width];
   for(int x=0;x<width-1;x++) {
      int y0 = buffer[(x+bpos)%width];
      y0 = (int)map(y0, 0, 1023, 0, height);
      int y1 = buffer[(x+bpos+1)%width];
      y1 = (int)map(y1, 0, 1023, 0, height);
      line(x,height-y0-1,x+1,height-y1-1);
      
   }
   for(int x=0;x<width;x++) {
      dft[x] = 1.0 * buffer[(x+bpos)%width];
   }   
   ffft.realForward(dft);
   stroke(127);
   for(int i=0;i<(width/2)-1;i++) {
      int x1 = i*2;
      int x2 = i*2+2;
      int y1 = (int)sqrt(dft[(i*2)]*dft[(i*2)] + dft[(i*2)+1]*dft[(i*2)+1])/10;
      int y2 = (int)sqrt(dft[(i*2)+2]*dft[(i*2)+2] + dft[(i*2)+3]*dft[(i*2)+3])/10;
      line(x1,height-y1-1,x2,height-y2-1);
   } 
}

void serialEvent(Serial myPort) {
   String inString = myPort.readStringUntil('\n');
  if (inString != null) {
   inString = trim(inString);
   float inByte = float(inString); 
   buffer[bpos] = int(inByte);
   bpos++;
   bpos %= width;  
  } 
}
