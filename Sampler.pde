public class Sampler
{
  AudioContext ac;
  SamplePlayer sampler;
  Sample loadedSample;
  
    
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
  
  
  float[] getMinMaxInFrames(int position, int numFrames)
  {
    float[][] frameData = new float[2][numFrames];
    loadedSample.getFrames(position, frameData);
    return new float[]{min(frameData[0]), max(frameData[0])};
  }
  
  
  double getPosition()
  {
    return sampler.getPosition() > getLength() ? getLength() : sampler.getPosition(); 
  }
  
  
  long getNumFrames()
  {
    return loadedSample.getNumFrames(); 
  }
  
  
  double getLength()
  {
    return loadedSample.getLength(); 
  }
}