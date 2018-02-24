class GUI
{
  
  final int PADDING = 10;
  
  final int BUTTON_WIDTH = 50;
  final int BUTTON_HEIGHT = 25;
  
  final int SAMPLE_WINDOW_WIDTH = width - PADDING * 2;
  final int SAMPLE_WINDOW_HEIGHT = 150;
  
  ControlP5 cp5;
  PApplet parent;
  Button loadButton, playButton, stopButton;
  float[][] sampleData;
  float samplePos;
  PGraphics samplePlot;
  
    
  GUI(PApplet parent)
  {
    this.parent = parent;   
    cp5 = new ControlP5(parent); 
    
    samplePlot = createGraphics(SAMPLE_WINDOW_WIDTH, SAMPLE_WINDOW_HEIGHT);
    
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
  
  
  void plotSample()
  {
    sampleData = sampler.getSampleData(); 
    int sampleLength = sampleData[0].length;
    
    samplePlot.beginDraw();
    samplePlot.background(0);
    samplePlot.stroke(200);
    for (int index = 0; index < sampleLength - 1; index++)
    {
      float x1 = map(index, 0, sampleLength, PADDING, PADDING + SAMPLE_WINDOW_WIDTH);
      float y1 = map(sampleData[0][index], -1, 1, PADDING + SAMPLE_WINDOW_HEIGHT, PADDING);
      float x2 = map(index + 1, 0, sampleLength, PADDING, PADDING + SAMPLE_WINDOW_WIDTH);
      float y2 = map(sampleData[0][index + 1], -1, 1, PADDING + SAMPLE_WINDOW_HEIGHT, PADDING);
      
      samplePlot.line(x1, y1, x2, y2); 
    }
    samplePlot.endDraw();
  }
  
  
  void display()
  {
    if (sampler.isLoaded())
    {
      image(samplePlot, PADDING, PADDING);   
      // playback position
      samplePos = (float) sampler.getPosition();
      samplePos = map(samplePos, 0, (float)sampler.getLength(), PADDING, PADDING + SAMPLE_WINDOW_WIDTH);
      line(samplePos, PADDING, samplePos, PADDING + SAMPLE_WINDOW_HEIGHT);
    }
    else
    {
      fill(0);
      stroke(255);
      rect(PADDING, PADDING, SAMPLE_WINDOW_WIDTH, SAMPLE_WINDOW_HEIGHT);
    }
  }
  

  
  
}