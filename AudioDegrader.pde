/*
AUDIO DEGRADER


- currently ignoring stereo waveforms, just drawing channel 0 whether mono or not

issues: first playback after first processing doesn't usually playback from start of sample (why?!?!?!)
        sometimes certain processes  seem to shift the sample as if something is recording at wrong time (???)
        
minor improvements to wav drawing would be nice

NEED TO ADD NORMALIZATION AFTER PROCESs! (OR AS BUTTON)
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