class Degrader
{
  AudioContext ac;
  
  SamplePlayer inputSampler;
  Sample outputSample;
  RecordToSample recorder;
  
  boolean isRunning;
    
  Degrader(AudioContext ac) 
  {
    this.ac = ac;
    isRunning = false;
  }
  
  
  boolean isRunning()
  {
    return isRunning;
  }
  
  
  void setupProcess()  
  {
    if (isRunning)  return;
    isRunning = true;
    
    sampler.stopIt();
    inputSampler = sampler.getSampler();
    inputSampler.setKillOnEnd(true);
    
    outputSample = new Sample(sampler.getLength());
    recorder = new RecordToSample(ac, outputSample, RecordToSample.Mode.FINITE);
    
    recorder.setKillListener(new Bead() {
      public void messageReceived(Bead message)
      {
        sampler.loadNew(outputSample);
        isRunning = false;
        ac.stop();
      }      
    });
    
    ac.out.addDependent(recorder);
  }
  
  
  void runProcess() 
  {       
    ac.stop();
    inputSampler.reTrigger();
    ac.runNonRealTime();
  }
  
  
  void crush()
  {
    setupProcess();
    
    NBitsConverter crush = new NBitsConverter(ac, 6);
    crush.addInput(inputSampler);
    recorder.addInput(crush);
    
    runProcess();
  }
  
  
  void unevenGain()
  {
    setupProcess();
    
    Envelope gainEnv = new Envelope(ac, 1);
    Gain gain = new Gain(ac, 1, gainEnv);
    
    for (int i = 0; i < outputSample.getLength(); i += 10)
    {
       gainEnv.addSegment(random(1.5), 10);
    }
    
    gain.addInput(inputSampler);
    recorder.addInput(gain);
    
    runProcess();
  }
  
  
  void unevenLPRez()
  {
    setupProcess();
    
    Envelope freqEnv = new Envelope(ac, 44100);
    Envelope rezEnv = new Envelope(ac, 0);
    LPRezFilter filter = new LPRezFilter(ac, freqEnv, rezEnv);
    
    for (int i = 0; i < outputSample.getLength(); i += 100)
    {
       freqEnv.addSegment(random(11025), 100);
       rezEnv.addSegment(random(.9), 100);
    }
    
    filter.addInput(inputSampler);
    recorder.addInput(filter);
    
    runProcess();
  }

}