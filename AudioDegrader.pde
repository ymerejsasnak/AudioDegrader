/*
AUDIO DEGRADER


*/

import controlP5.*;
import beads.*;


Sampler sampler;
GUI gui;


void setup()
{
  size(800, 600);
  background(100);
  noStroke();
  
  sampler = new Sampler();  
  gui = new GUI(this);

}



void draw()
{
  
  gui.display();
  
  println(frameRate);
}