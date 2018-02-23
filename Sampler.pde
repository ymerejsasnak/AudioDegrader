public class Sampler
{
  AudioContext ac;
  SamplePlayer sampler;
  
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
    if (sampler == null)
    {
      sampler = new SamplePlayer(ac, SampleManager.sample(fileName)); 
      sampler.pause(true);
      sampler.setKillOnEnd(false);
      ac.out.addInput(sampler);
    }
    else
    {
      sampler.setSample(SampleManager.sample(fileName)); 
      sampler.pause(true);
    }
    
  }
  
  void play() 
  {
    if (sampler != null)
    {
      sampler.setPosition(0);
      sampler.start(); 
    }
  }
  
  
  void stopIt()
  {
    println("Stop"); 
  }
}