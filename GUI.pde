class GUI
{
  
  final int PADDING = 10;
  final int SPACER = PADDING * 5;
  
  final int BUTTON_WIDTH = 50;
  final int BUTTON_HEIGHT = 25;
  
  final int KNOB_SIZE = 20;
  
  final int SAMPLE_WINDOW_WIDTH = width - PADDING * 2;
  final int SAMPLE_WINDOW_HEIGHT = 150;
  
  final int SAMPLE_CENTER_Y = SAMPLE_WINDOW_HEIGHT / 2;
  
  final int DEGRADE_BUTTONS_Y = SAMPLE_WINDOW_HEIGHT + BUTTON_HEIGHT + SPACER * 2;
  
  ControlP5 cp5;
  PApplet parent;
  Button loadButton, playButton, stopButton;
  PGraphics samplePlot;
  
  Button crushButton, unevenGainButton, averagerButton;
  Knob crushKnob, gainChangeKnob, gainRangeKnob, avgPassesKnob;
  
    
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
                    
                    
                    
    crushButton = cp5.addButton("crush")
                    .setPosition(PADDING, DEGRADE_BUTTONS_Y)
                    .plugTo(degrader);
                    
    crushKnob = cp5.addKnob("crushValue")
                   .setPosition(PADDING * 2 + BUTTON_WIDTH + SPACER, DEGRADE_BUTTONS_Y)
                   .setRange(2, 20)
                   .setValue(10)
                   .setSize(KNOB_SIZE, KNOB_SIZE)
                   .plugTo(degrader);
      
                    
    unevenGainButton = cp5.addButton("unevenGain")
                          .setPosition(PADDING, DEGRADE_BUTTONS_Y + SPACER + BUTTON_HEIGHT)
                          .plugTo(degrader);
                          
    gainChangeKnob = cp5.addKnob("gainChange")
                  .setPosition(PADDING * 2 + BUTTON_WIDTH + SPACER, DEGRADE_BUTTONS_Y + SPACER + BUTTON_HEIGHT)
                  .setRange(0.0002, 1)
                  .setValue(0.02)
                  .setSize(KNOB_SIZE, KNOB_SIZE)
                  .plugTo(degrader);
                  
    gainRangeKnob = cp5.addKnob("gainRange")
                  .setPosition(PADDING * 2 + BUTTON_WIDTH + SPACER * 2, DEGRADE_BUTTONS_Y + SPACER + BUTTON_HEIGHT)
                  .setRange(0.1, 1)
                  .setValue(0.5)
                  .setSize(KNOB_SIZE, KNOB_SIZE)
                  .plugTo(degrader);
        
                  
    averagerButton = cp5.addButton("averager")
                           .setPosition(PADDING, DEGRADE_BUTTONS_Y + SPACER * 2 + BUTTON_HEIGHT * 2)
                           .plugTo(degrader);
                           
    avgPassesKnob = cp5.addKnob("averagerPasses")
                  .setPosition(PADDING * 2 + BUTTON_WIDTH + SPACER * 2, DEGRADE_BUTTONS_Y + SPACER * 2 + BUTTON_HEIGHT * 2)
                  .setRange(1, 100)
                  .setValue(2)
                  .setSize(KNOB_SIZE, KNOB_SIZE)
                  .plugTo(degrader);


  }
  
  
  void plotSample()
  {
    long numFrames = sampler.getNumFrames();
        
    float framesPerPixel = numFrames / (float)SAMPLE_WINDOW_WIDTH;
    samplePlot.beginDraw();
    samplePlot.background(10);
    samplePlot.stroke(50, 0, 0);
    samplePlot.line(0, SAMPLE_CENTER_Y, SAMPLE_WINDOW_WIDTH, SAMPLE_CENTER_Y);
    samplePlot.stroke(200);
    
    for (int index = 0; index < SAMPLE_WINDOW_WIDTH; index++)
    {
      int x = index;
      
      float[] minMaxFrame = sampler.getMinMaxInFrames(index * framesPerPixel, framesPerPixel);
            
      float y1 = map(minMaxFrame[0], -1, 1, SAMPLE_WINDOW_HEIGHT, 0);
      float y2 = map(minMaxFrame[1], -1, 1, SAMPLE_WINDOW_HEIGHT, 0);
      
      // quick fix to make very short sounds look better
      if (numFrames < SAMPLE_WINDOW_WIDTH * 2)
      {
        y1 = map(y1, SAMPLE_WINDOW_HEIGHT, 0, 0, SAMPLE_WINDOW_HEIGHT); 
      }
     
      samplePlot.line(x, y1, x, y2); 
    }
    
    samplePlot.endDraw();
  }
  
  
  void display()
  {
    if (sampler.isLoaded())
    {
      image(samplePlot, PADDING, PADDING);   
      // playback position
      int playPos = (int) map((float)sampler.getPosition(), 
                               0,       (float)sampler.getLength() - 1, 
                               PADDING, PADDING + SAMPLE_WINDOW_WIDTH - 1);
      stroke(100);
      line(playPos, PADDING, playPos, PADDING + SAMPLE_WINDOW_HEIGHT - 1);
      
      fill(200);
      text("frames in sample:" + sampler.getNumFrames(), 500, 60);
      text("current position:" + sampler.getPosition(), 500, 50);
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