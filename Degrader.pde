class Degrader
{
  AudioContext ac;
  
  Sample inputSample;
  Sample outputSample;
  double sampleLength;
  SamplePlayer degradeSampler;
  RecordToSample recorder;
  
  boolean isRunning;
  
  
  int crushValue;
  
    
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
        
    sampler.sampler.pause(true);    
        
    inputSample = sampler.getSample();
    sampleLength = inputSample.getLength();
    
    degradeSampler = new SamplePlayer(ac, inputSample);   
    degradeSampler.setKillOnEnd(true);
    
    outputSample = new Sample(sampleLength);
    recorder = new RecordToSample(ac, outputSample, RecordToSample.Mode.FINITE);
    ac.out.addDependent(recorder);
        
    recorder.setKillListener(new Bead() {
      public void messageReceived(Bead message)
      {
        ac.stop();
        sampler.loadDegraded(outputSample);
        isRunning = false;
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
    
    NBitsConverter crush = new NBitsConverter(ac, crushValue);
    crush.addInput(degradeSampler);
    recorder.addInput(crush);
    
    runProcess();
  println(crushValue);
  }
  
  
  void unevenGain()
  {
    if (isRunning)  return;
    isRunning = true;
    
    setupProcess();
    
    Envelope gainEnv = new Envelope(ac, random(.5, 1));
    Gain gain = new Gain(ac, 1, gainEnv);
    
    int changeFreq = (int) random(1000, 100000);
    for (int i = 0; i < changeFreq; i++)
    {
       gainEnv.addSegment(random(.5, 1), i * (float)(sampleLength / (float)changeFreq));
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
    Envelope rezEnv = new Envelope(ac, random(.3, .6));
    LPRezFilter filter = new LPRezFilter(ac, freqEnv, rezEnv);
    
    for (int i = 0; i < 10000; i++)
    {
       freqEnv.addSegment(random(100, 20000), i * (float)(sampleLength / 10000.0));
       rezEnv.addSegment(random(.3, .8), i * (float)(sampleLength / 10000.0));
    }
    
    filter.addInput(degradeSampler);
    recorder.addInput(filter);

    runProcess();
  }

}