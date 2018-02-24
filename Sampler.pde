public class Sampler
{
  AudioContext ac;
  SamplePlayer sampler;
  Sample loadedSample;
  float[][] frameData;
  
  Sampler()
  {
    ac = new AudioContext();
    ac.start();
  }
  
  
  void load()
  {
    selectInput("load a file", "loader", dataFile("data"), this);
  }
  
  
  public void loader(File selection)
  {
     if (selection == null) {
       println("nothing selected");
     }
     else
     {
       setupSampler(selection.getAbsolutePath());
     }
  }
  
  
  void setupSampler(String fileName)
  {
    loadedSample = SampleManager.sample(fileName);
    frameData = new float[2][(int)loadedSample.getNumFrames()];
    loadedSample.getFrames(0, frameData);
    
    if (sampler == null)
    {
      sampler = new SamplePlayer(ac, loadedSample); 
      sampler.pause(true);
      sampler.setKillOnEnd(false);
      ac.out.addInput(sampler);
    }
    else
    {
      sampler.setSample(loadedSample); 
      sampler.pause(true);
    }
    
    gui.plotSample();
  }
  
  void play() 
  {
    if (sampler == null)  return;
    
    sampler.reTrigger(); 
  }
  
  
  void mousePlay(int _mouseX)
  {
    if (sampler == null)  return;
    
    float startPos = map(_mouseX, 0, gui.SAMPLE_WINDOW_WIDTH, 0, (float)loadedSample.getLength());
    sampler.start(startPos); 
  }
  
  void stopIt()
  {
    if (sampler == null)  return;
    
    sampler.pause(true);
    sampler.reset();
  }
  
  
  boolean isLoaded()
  {
    return sampler != null;  
  }
  
  
  float[][] getSampleData()
  {
    // ??temporarily will assume 1 channel (mono) audio
    return frameData;
  }
  
  
  double getPosition()
  {
    return sampler.getPosition(); 
  }
  
  
  double getLength()
  {
    return loadedSample.getLength(); 
  }
}