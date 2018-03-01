class Degrader
{
  AudioContext ac;
  
  Sample inputSample;
  Sample outputSample;
  float sampleLength;
  SamplePlayer degradeSampler;
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
    ac.stop();
    
    inputSample = sampler.getSample();
    sampleLength = (float) inputSample.getLength();
    
    degradeSampler = new SamplePlayer(ac, inputSample);
    degradeSampler.pause(true);
    degradeSampler.setKillOnEnd(true);
    
    
    outputSample = new Sample(sampleLength);
    recorder = new RecordToSample(ac, outputSample, RecordToSample.Mode.FINITE);
    ac.out.addDependent(recorder);
        
    recorder.setKillListener(new Bead() {
      public void messageReceived(Bead message)
      {
        sampler.loadDegraded(outputSample);
        isRunning = false;
        ac.stop();
      }      
    });
   
  }
  
  
  void runProcess() 
  {       
    
    degradeSampler.reTrigger();
    ac.runNonRealTime();
  }
  
  
  void crush()
  {
    if (isRunning)  return;
    isRunning = true;
    
    setupProcess();
    
    NBitsConverter crush = new NBitsConverter(ac, 6);
    crush.addInput(degradeSampler);
    recorder.addInput(crush);
    
    runProcess();
  
  }
  
  
  void unevenGain()
  {
    if (isRunning)  return;
    isRunning = true;
    
    setupProcess();
    
    Envelope gainEnv = new Envelope(ac, random(.75, 1.5));
    Gain gain = new Gain(ac, 1, gainEnv);
    
    for (int i = 0; i < 10; i++)
    {
       gainEnv.addSegment(random(.75, 1.5), i * sampleLength / 10.0);
    }
    
    gain.addInput(degradeSampler);
    recorder.addInput(gain);
    
    runProcess();
  }
  
  
  void unevenLPRez()
  {
    if (isRunning)  return;
    isRunning = true;
    
    setupProcess();
    
    Envelope freqEnv = new Envelope(ac, random(100, 10000));
    Envelope rezEnv = new Envelope(ac, random(.1, .6));
    LPRezFilter filter = new LPRezFilter(ac, freqEnv, rezEnv);
    
    for (int i = 0; i < 10; i++)
    {
       freqEnv.addSegment(random(100, 10000), i * sampleLength / 10.0);
       rezEnv.addSegment(random(.1, .6), i * sampleLength / 10.0);
    }
    
    filter.addInput(degradeSampler);
    recorder.addInput(filter);
    
    runProcess();
  }

}