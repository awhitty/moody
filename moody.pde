import processing.video.*;
import pSmile.PSmile;
import ddf.minim.*;
import ddf.minim.effects.*;
import tactu5.*;

SmileMachine moods;
SoundMachine sounds;


void setup() {
    size(800,600, P2D);
    moods = new SmileMachine(this);
    sounds = new SoundMachine(this);
    
    rectMode(CENTER);
    colorMode(HSB);
}

void draw() {
    background(0);
    moods.update();
    fill(100*(moods.getSmoothedMood() + 6)/12, 100, 100);
    rect(width/2,height/2,width, height);
    moods.draw();
    sounds.setMood(moods.getSmoothedMood());
    sounds.update();

    
//    sounds.draw();
    
}

void mouseDragged() {
    float mood = 12 * (((float) mouseX / width) - .5);
    sounds.setMood(mood);
    sounds.update();
    println("--------------");
//    println(mood);
}
