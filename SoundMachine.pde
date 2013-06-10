class SoundMachine {
    Minim minim;
    HashMap<String, Looper> loops;

    float currentMood;

    // Table moodSchemes;
    HashMap<Integer, String> moodSchemes;

    int MAX_MOOD = 5;
    int MIN_MOOD = -5;
    
    float MIN_GAIN = -100;
    float MAX_GAIN = 0;

    SoundMachine(PApplet parent) {
        minim = new Minim(parent);
                
        loops = new HashMap<String, Looper>();
        loops.put("Bb", new Looper("Bb.mp3"));
        loops.put("A", new Looper("A.mp3"));
        loops.put(" F", new Looper("F.mp3"));
        loops.put("D", new Looper("D.mp3"));
        loops.put("Ab", new Looper("Ab.mp3"));
        loops.put("E", new Looper("E.mp3"));
        loops.put("Eb", new Looper("Eb.mp3"));

        moodSchemes = new HashMap<Integer, String>();
        moodSchemes.put(0, "Bb ");

        moodSchemes.put(1, "Bb D ");
        moodSchemes.put(2, "Bb Eb ");
        moodSchemes.put(3, "Bb F ");
        moodSchemes.put(4, "Bb Eb F ");
        moodSchemes.put(5, "Bb D F ");
        
        moodSchemes.put(-1, "Bb E ");
        moodSchemes.put(-2, "Bb Eb E ");
        moodSchemes.put(-3, "Bb Eb E Ab ");
        moodSchemes.put(-4, "Bb Eb E A ");
        moodSchemes.put(-5, "Bb Eb E A Ab ");
    }

    void setMood(float mood) {
        currentMood = mood;
    }

    boolean noteInMood(int mood, String note) {
        if (mood > MAX_MOOD) mood = MAX_MOOD;
        if (mood < MIN_MOOD) mood = MIN_MOOD;

        return moodSchemes.get(mood).indexOf(note + " ") != -1;
    }

    void update() {
        int mood = (int) currentMood;

        for (String note : loops.keySet()) {
            Looper loop = loops.get(note);
            if (noteInMood(mood, note)) {
                loop.setGain(MAX_GAIN);
            } else {
              loop.setGain(MIN_GAIN);
            } 
        }
    }

    void draw() {
        int i = 0;
        for (String note : loops.keySet()) {
            Looper loop = loops.get(note);
            rect(width/2,i*10,MIN_GAIN - abs(loop.getGain()), 10);
            i++;
        }
    }

    class Looper {
        int NUM_LOOPS = 5;
  
        AudioPlayer[] players;
        float gain;
        
        LowPassSP lpf;
  
        Looper(String filename) {
            players = new AudioPlayer[NUM_LOOPS];
    
            for (int i = 0; i < NUM_LOOPS; i++) {
                players[i] = minim.loadFile(filename);
                lpf = new LowPassSP(1000, players[i].sampleRate());
                players[i].addEffect(lpf);
                players[i].setGain(MIN_GAIN);
                players[i].cue((int) random(0,10000));
                players[i].loop();
            }

            gain = MIN_GAIN;
            
            
        }
    
        void setGain(float _gain) {
            for (int i = 0; i < NUM_LOOPS; i++) players[i].setGain(_gain);
            gain = _gain;
        }

        float getGain() { return gain; }
    }
};
