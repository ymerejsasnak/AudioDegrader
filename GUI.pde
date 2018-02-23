class GUI
{
  
  final int BUTTON_WIDTH = 50;
  final int BUTTON_HEIGHT = 25;
  
  ControlP5 cp5;
  PApplet parent;
  Button loadButton, playButton, stopButton;
  float[][] sampleData;
  
    
  GUI(PApplet parent)
  {
    this.parent = parent;   
    cp5 = new ControlP5(parent); 
    
    loadButton = cp5.addButton("load")
                    .setCaptionLabel("LOAD")
                    .setPosition(20, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);
    
    playButton = cp5.addButton("play")
                    .setCaptionLabel("PLAY")
                    .setPosition(120, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);
                    
    stopButton = cp5.addButton("stopIt")
                    .setCaptionLabel("STOP")
                    .setPosition(220, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);
  }
  
  
  void drawSample()
  {
    fill(0);
    rect(0, 0, 600, 100);
    
    if (sampler.hasSample())
    {
      sampleData = sampler.getSampleData();
      
      for (int index = 0; index < sampleData[0].length; index++)
      {
        float x = map(index, 0, sampleData[0].length, 0, 600);
        float y = map(sampleData[0][index], -1, 1, 100, 0);
        fill(255);
        ellipse(x, y, 3, 3);
          
      }
      
    }
  }
  

  
  
}