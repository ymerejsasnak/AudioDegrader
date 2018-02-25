class Degrader
{
  AudioContext ac;
  
  SamplePlayer inputSampler;
  Sample outputSample;
    
  Degrader(AudioContext ac) 
  {
    this.ac = ac;
    
  }
  
  
  void temp() 
  {
    inputSampler = sampler.getSampler();
    inputSampler.setPosition(0);
    
    //inputSampler.setKillOnEnd(true);    
    //inputSampler.setKillListener(new AudioContextStopTrigger(ac));
    
    outputSample = new Sample(inputSampler.getSample().getLength());
    RecordToSample recorder = new RecordToSample(ac, outputSample, RecordToSample.Mode.FINITE);
    
    Gain gain = new Gain(ac, 1, 0.9);
    
    gain.addInput(inputSampler);
    recorder.addInput(gain);
    ac.out.addDependent(recorder);
        
    recorder.setKillListener(new Bead() {
      public void messageReceived(Bead message)
      {
        sampler.loadNew(outputSample);
      }
      
    });
    
    
    ac.runNonRealTime();
    inputSampler.start();
    
    
    
    
    
  }
  
  

}