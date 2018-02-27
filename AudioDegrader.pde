/*
AUDIO DEGRADER


- currently ignoring stereo waveforms, just drawing channel 0 whether mono or not


*/

import controlP5.*;
import beads.*;


Sampler sampler;
Degrader degrader;
GUI gui;


void setup()
{
  size(800, 600);
  background(20);
  noStroke();
  
  sampler = new Sampler(); 
  degrader = new Degrader(sampler.getAudioContext());
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