class Degrader
{
  AudioContext ac;
  
  Sample inputSample;
  Sample outputSample;
  long numFrames;
  float[][] frameData;
  
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
  
  
  boolean setupProcess()  
  {   
    if (isRunning) return false;
    isRunning = true;
    
    sampler.sampler.pause(true);
        
    inputSample = sampler.getSample();
    numFrames = inputSample.getNumFrames();
    frameData = new float[2][(int)numFrames];
    inputSample.getFrames(0, frameData);
    
    outputSample = new Sample(inputSample.getLength());   

    println(inputSample.getNumChannels());
    return true;
  }
  
  
 
  
  void crush()
  {
    if (setupProcess())
    {
      for (int frame = 0; frame < numFrames; frame++)
      {
        float inFrame = frameData[0][frame];
        float outFrame = round(inFrame * crushValue) / (float)crushValue;
        outputSample.putFrame(frame, new float[]{outFrame, outFrame});
      }
      sampler.loadDegraded(outputSample);
      isRunning = false;
    }
    else 
    {
      return; 
    }
   
  }
  
  /*
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
*/
}