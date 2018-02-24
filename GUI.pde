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
  PGraphics samplePlot;
  
    
  GUI(PApplet parent)
  {
    this.parent = parent;   
    cp5 = new ControlP5(parent); 
    
    samplePlot = createGraphics(SAMPLE_WINDOW_WIDTH, SAMPLE_WINDOW_HEIGHT);
    
    loadButton = cp5.addButton("load")
                    .setCaptionLabel("LOAD")
                    .setPosition(PADDING, SAMPLE_WINDOW_HEIGHT + PADDING * 2)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);
    
    playButton = cp5.addButton("play")
                    .setCaptionLabel("PLAY")
                    .setPosition(PADDING * 2 + BUTTON_WIDTH, SAMPLE_WINDOW_HEIGHT + PADDING * 2)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);
                    
    stopButton = cp5.addButton("stopIt")
                    .setCaptionLabel("STOP")
                    .setPosition(PADDING * 3 + BUTTON_WIDTH * 2, SAMPLE_WINDOW_HEIGHT + PADDING * 2)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(sampler);

  }
  
  
  void plotSample()
  {
    sampleData = sampler.getSampleData(); 
    int sampleLength = sampleData[0].length;
    
    samplePlot.beginDraw();
    samplePlot.background(10);
    samplePlot.stroke(50, 0, 0);
    samplePlot.line(0, SAMPLE_WINDOW_HEIGHT / 2, SAMPLE_WINDOW_WIDTH, SAMPLE_WINDOW_HEIGHT / 2);
    samplePlot.stroke(200);
    for (float index = 0; index < SAMPLE_WINDOW_WIDTH - 1; index++)
    {
      float x1 = index;
      float y1 = map(sampleData[0][int(index / SAMPLE_WINDOW_WIDTH * sampleLength)], -1, 1, SAMPLE_WINDOW_HEIGHT, 0);
      float x2 = index + 1;
      float y2 = map(sampleData[0][int((index + 1) / SAMPLE_WINDOW_WIDTH * sampleLength)], -1, 1, SAMPLE_WINDOW_HEIGHT, 0);
      
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
      float playPos = (float) sampler.getPosition();
      println(sampler.getPosition());
      playPos = map(playPos, 0, (float)sampler.getLength() - 1, PADDING, PADDING + SAMPLE_WINDOW_WIDTH - 1);
      stroke(100);
      line(playPos, PADDING, playPos, PADDING + SAMPLE_WINDOW_HEIGHT - 1);
    }
    else
    {
      fill(10);
      noStroke();
      rect(PADDING, PADDING, SAMPLE_WINDOW_WIDTH, SAMPLE_WINDOW_HEIGHT);
      stroke(50, 0, 0);
      line(PADDING, PADDING + SAMPLE_WINDOW_HEIGHT / 2, PADDING + SAMPLE_WINDOW_WIDTH, PADDING + SAMPLE_WINDOW_HEIGHT / 2);
    }
  }
  

  
  
}