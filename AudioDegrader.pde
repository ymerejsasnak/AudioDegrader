/*
AUDIO DEGRADER


*/

import controlP5.*;
import beads.*;

GUI gui;
Sampler sampler;


void setup()
{
  size(800, 600);
  background(100);
  
  gui = new GUI(this);
  sampler = new Sampler();
}



void draw()
{
  
  gui.drawSample();
  
}