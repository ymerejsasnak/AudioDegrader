/*
AUDIO DEGRADER


- still glitch graphics with playback indicator (keeps going beyond window...can't fig why)

- really short sounds don't look good now (well, only some, depending on length and freq/shape)
(maybe draw mode depends on length...short enough, just draw every x sample?)
(or maybe draw lines connecting the min/max vertical lines??)

- currently ignoring stereo waveforms, just drawing channel 0 whether mono or not


*/

import controlP5.*;
import beads.*;


Sampler sampler;
GUI gui;


void setup()
{
  size(800, 600);
  background(20);
  noStroke();
  
  sampler = new Sampler();  
  gui = new GUI(this);

}



void draw()
{
  
  gui.display();
  
 // println(frameRate);
}


void mousePressed()
{
  if (mouseX > gui.PADDING && mouseX < gui.PADDING + gui.SAMPLE_WINDOW_WIDTH &&
      mouseY > gui.PADDING && mouseY < gui.PADDING + gui.SAMPLE_WINDOW_HEIGHT)
      {
        sampler.mousePlay(mouseX - gui.PADDING); 
      }
  
}