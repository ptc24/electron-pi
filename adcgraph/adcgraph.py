#!/usr/bin/env python

from Tkinter import *
import Pmw
import spidev
import time

spi = 0
spi = spidev.SpiDev()
killed = 0

def callback():
    global killed
    killed = 1

def readadc(adcnum):
    if((adcnum > 7) or (adcnum < 0)):
        return -1
    r = spi.xfer2([1,(8+adcnum)<<4,0])
    adcout = ((r[1]&3) << 8) + r[2]
    return adcout

def main():
    spi.open(0,0)
    master = Tk()
    master.protocol("WM_DELETE_WINDOW", callback)
    g = Pmw.Blt.Graph(master)

    vx = Pmw.Blt.Vector()
    vy = Pmw.Blt.Vector()

    s = readadc(0)
    for i in range(100):
        vx.append(i)
        vy.append(s)

    g.pack(expand=1,fill='both')
    g.line_create("adc0",xdata=vx,ydata=vy)
    g.element_configure("adc0",symbol='')
    print g.yaxis_configure(min="0",max="1024")
    
    while not killed:
        vy.delete(0)
        vy.append(readadc(0))
        master.update()
        if not killed: master.after(20)
    
    master.quit()
    
        

if __name__=="__main__":
    main()
