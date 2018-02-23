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

  }
  
  void play() 
  {
    if (sampler != null)
    {
      sampler.reTrigger();
    }
  }
  
  
  void stopIt()
  {
    println("Stop"); 
  }
  
  
  boolean hasSample()
  {
    return loadedSample != null;  
  }
  
  
  float[][] getSampleData()
  {
    // ??temporarily will assume 1 channel (mono) audio
    return frameData;
    
  }
}