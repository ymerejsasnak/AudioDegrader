class GUI
{
  final int BUTTON_WIDTH = 50;
  final int BUTTON_HEIGHT = 25;
  
  ControlP5 cp5;
  PApplet parent;
  Button loadButton, playButton, stopButton;
  
  GUI(PApplet parent)
  {
    this.parent = parent;   
    cp5 = new ControlP5(parent); 
    
    loadButton = cp5.addButton("load")
                    .setCaptionLabel("LOAD")
                    .setPosition(20, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(this);
    
    playButton = cp5.addButton("play")
                    .setCaptionLabel("PLAY")
                    .setPosition(120, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(this);
                    
    stopButton = cp5.addButton("stopIt")
                    .setCaptionLabel("STOP")
                    .setPosition(220, 200)
                    .setSize(BUTTON_WIDTH, BUTTON_HEIGHT)
                    .plugTo(this);
  }
  
  
  void drawSample()
  {
    fill(0);
    rect(10, 10, 400, 150);
  }
  
  void load()
  {
    println("load"); 
  }
  
  void play()
  {
    println("play");
  }
  
  void stopIt()
  {
    println("stop"); 
  }
  
  
}