class Degrader
{
  AudioContext ac;
  
  Sample inputSample;
  Sample outputSample;
  long numFrames;
  float[][] frameData;
  
  boolean isRunning;
    
    
  int crushValue;
  float gainChange, gainRange, averagerPasses;
  
    
  Degrader(AudioContext ac) 
  {
    this.ac = ac;
    isRunning = false;
    
    crushValue = 10;
    gainChange = .02;
    gainRange = .5;
    averagerPasses = 2;

  }
  
  
  boolean isRunning()
  {
    return isRunning;
  }
  
  
  private boolean setupProcess()  
  {   
    if (isRunning) return false;
    isRunning = true;
    
    sampler.sampler.pause(true);
        
    inputSample = sampler.getSample();
    numFrames = inputSample.getNumFrames();
    frameData = new float[2][(int)numFrames];
    inputSample.getFrames(0, frameData);
    
    outputSample = new Sample(inputSample.getLength());   

    return true;
  }
  
  
  private void endProcess()
  {
    normalize();
    sampler.loadDegraded(outputSample);
    isRunning = false;
  }
  
  
  private void normalize()
  {
    outputSample.getFrames(0, frameData);
    float maxAmp = max(max(frameData[0]), abs(min(frameData[0])));
    
    for (int frame = 0; frame < numFrames; frame++)
      {
        float inFrame = frameData[0][frame];
        float outFrame = map(inFrame, -maxAmp, maxAmp, -1, 1);
        outputSample.putFrame(frame, new float[]{outFrame, outFrame});
      }
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
      endProcess();
    }
    else 
    {
      return; 
    }
   
  }
  
  
  void unevenGain()
  {
    if (setupProcess())
    {
      int offset = millis();
      for (int frame = 0; frame < numFrames; frame++)
      {
        float inFrame = frameData[0][frame];
        float outFrame = inFrame * map(noise((frame + offset) * gainChange), 0, 1, 1 - gainRange, 1);
        outputSample.putFrame(frame, new float[]{outFrame, outFrame});
      }
      endProcess();
    }
    else 
    {
      return; 
    }
  }
  
  
  void averager()
  {
    if (setupProcess())
    {
      for(int pass = 0; pass < averagerPasses; pass++)
      {
        outputSample.putFrame(0, new float[]{0, 0});
        for (int frame = 1; frame < numFrames; frame++)
        {
          float inFrame1 = frameData[0][frame - 1];
          float inFrame2 = frameData[0][frame];
          float outFrame = (inFrame1 + inFrame2) / 2.0;
          
          outputSample.putFrame(frame, new float[]{outFrame, outFrame});
        }
        outputSample.putFrame((int)numFrames - 1, new float[]{0, 0});
        outputSample.getFrames(0, frameData);
      }
      endProcess();
    }
    else 
    {
      return; 
    }
  }

}