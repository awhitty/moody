class SmileMachine {
    Capture cam;
    PSmile detector;
    PImage currentFrame;

    float currentMood;
    ArrayList<Float> mavgMoods;

    int MAVG_SMOOTHING = 100;
    int CAMERA_WIDTH = 320;
    int CAMERA_HEIGHT = 240;
    int FRAME_RATE = 25;
    
    SmileMachine(PApplet parent) {
        cam = new Capture(parent, CAMERA_WIDTH, CAMERA_HEIGHT, FRAME_RATE);
        detector = new PSmile(parent, CAMERA_WIDTH/2, CAMERA_HEIGHT/2);
        currentFrame = createImage(CAMERA_WIDTH/2, CAMERA_HEIGHT/2, ARGB);

        mavgMoods = new ArrayList<Float>(MAVG_SMOOTHING+1);
        currentMood = 0.0;

        cam.start();
    }

    void update() {
        
        
        cam.read();
        currentFrame.copy(cam, 0, 0, CAMERA_WIDTH, CAMERA_HEIGHT, 0, 0, CAMERA_WIDTH/2, CAMERA_HEIGHT/2);

        currentMood = detector.getSmile(currentFrame);
        mavgMoods.add(currentMood + 1);

        if (mavgMoods.size() > MAVG_SMOOTHING) mavgMoods.remove(0);
    }
    
    void draw() {
      tint(100*(getSmoothedMood() + 6)/12, 100, 255);
      image(currentFrame, 20,20,width-40, height-40);
    }

      
    float getMood() {
        return currentMood;
    }

    float getSmoothedMood() {
        float sum = 0;
        for (int i = 0; i<mavgMoods.size(); i++){
            sum += mavgMoods.get(i);
        }

        return sum / mavgMoods.size();
    }
}
