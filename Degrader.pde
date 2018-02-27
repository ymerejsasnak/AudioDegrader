class Degrader
{
  AudioContext ac;
  
  SamplePlayer inputSampler;
  Sample outputSample;
  
  boolean isRunning;
    
  Degrader(AudioContext ac) 
  {
    this.ac = ac;
    isRunning = false;
  }
  
  
  void temp()  // a lot of this should be in sampler class instead?
  {
    if (isRunning)  return;
      
    isRunning = true;
    
    inputSampler = sampler.getSampler();
    inputSampler.setKillOnEnd(true);
    
    outputSample = new Sample(sampler.getLength());
    RecordToSample recorder = new RecordToSample(ac, outputSample, RecordToSample.Mode.FINITE);
    
    recorder.setKillListener(new Bead() {
      public void messageReceived(Bead message)
      {
        sampler.loadNew(outputSample);
        isRunning = false;
        ac.stop();
      }      
    });
    
    ac.out.addDependent(recorder);
        
    NBitsConverter crush = new NBitsConverter(ac, 6);
    crush.addInput(inputSampler);
        
    recorder.addInput(crush);
            
       
    ac.stop();
    inputSampler.reTrigger();
    ac.runNonRealTime();
    
  }
  
  

}