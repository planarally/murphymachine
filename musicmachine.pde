import processing.serial.*;
import processing.sound.*;

Serial ESP32Connection;
String incomingValue;

float redBeat, blueBeat, yellowBeat, redPitch, bluePitch, yellowPitch, waveType;
float noteFreq, noteVol, delayTime;

SinOsc sine;
SqrOsc sqr;
SawOsc saw;

Env sineEnv, sqrEnv, sawEnv;

float attackTime, sustainTime, sustainLevel, releaseTime;

float circleAlpha = 0;

ArrayList<daCircle> circles = new ArrayList<daCircle>();
float hue;

void setup() {
  size(800, 600);
  colorMode(HSB, 360, 1, 1);
  background(0);
  //printArray(Serial.list());
  ESP32Connection = new Serial(this, Serial.list()[1], 9600);
  ESP32Connection.bufferUntil('\n');

  sine = new SinOsc(this);
  sineEnv = new Env(this);

  sqr = new SqrOsc(this);
  sqrEnv = new Env(this);

  saw = new SawOsc(this);
  sawEnv = new Env(this);
}

void draw() {
  background(0);

  redLayer();
  blueLayer();
  yellowLayer();
}




//read the arduino

void serialEvent(Serial connection) {
  incomingValue = connection.readString();
  //println(incomingValue);
  String[] values = split(incomingValue.trim(), ',');
  printArray(values);

  if (values.length == 13) {
    redBeat = float(values[0]);
    blueBeat = float(values[1]);
    yellowBeat = float(values[2]);
    redPitch = map(float(values[9]), 0, 4095, 261.63, 523.25);
    bluePitch = map(float(values[10]), 0, 4095, 261.63, 523.25);
    yellowPitch = map(float(values[11]), 0, 4095, 261.63, 523.25);
    waveType = float(values[12]);
  }
}

//each sound layer

void redLayer() {

  noteFreq = redPitch;
  hue = 8;

  if (redBeat == 0) {
    noteVol = 0;
  } else if (redBeat == 1) {
    noteVol = 1;
    delayTime = .25;
    attackTime = 0.2;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.5;
  } else if (redBeat == 2) {
    noteVol = 1;
    delayTime = .05;
    attackTime = 0.01;
    sustainTime = 0.03;
    sustainLevel = 0.5;
    releaseTime = 0.02;
  } else if (redBeat == 3) {
    noteVol = 1;
    delayTime = .3;
    attackTime = 0.5;
    sustainTime = 0.1;
    sustainLevel = 0.8;
    releaseTime = 0.1;
  }

  drawVisualizer(hue);
  waveSelector();
  delayBetweenNotes(delayTime);
}

void blueLayer() {

  noteFreq = bluePitch;
  hue = 209;

  if (blueBeat == 0) {
    noteVol = 0;
  } else if (blueBeat == 1) {
    noteVol = 1;
    delayTime = .25;
    attackTime = 0.2;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.5;
  } else if (blueBeat == 2) {
    noteVol = 1;
    delayTime = .05;
    attackTime = 0.01;
    sustainTime = 0.03;
    sustainLevel = 0.5;
    releaseTime = 0.02;
  } else if (blueBeat == 3) {
    noteVol = 1;
    delayTime = .5;
    attackTime = 0.05;
    sustainTime = 0.1;
    sustainLevel = 0.8;
    releaseTime = 0.1;
  }

  drawVisualizer(hue);
  waveSelector();
  delayBetweenNotes(delayTime);
}

void yellowLayer() {

  noteFreq = yellowPitch;
  hue = 42;

  if (yellowBeat == 0) {
    noteVol = 0;
  } else if (yellowBeat == 1) {
    noteVol = 1;
    delayTime = .25;
    attackTime = 0.2;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.5;
  } else if (yellowBeat == 2) {
    noteVol = 1;
    delayTime = .05;
    attackTime = 0.01;
    sustainTime = 0.03;
    sustainLevel = 0.5;
    releaseTime = 0.02;
  } else if (yellowBeat == 3) {
    noteVol = 1;
    delayTime = .5;
    attackTime = 0.05;
    sustainTime = 0.1;
    sustainLevel = 0.8;
    releaseTime = 0.1;
    drawVisualizer(hue);
  }

  drawVisualizer(hue);
  waveSelector();
  delayBetweenNotes(delayTime);
}

//delay
void delayBetweenNotes(float delayTime) {
  delay(floor(delayTime * 1000)); // sconverted to ms
}

//wave selection

void waveSelector() {
  if (waveType > 0 && waveType < 1502) {
    sine.play(noteFreq, noteVol);
    sineEnv.play(sine, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 1502 && waveType < 2788) {
    sqr.play(noteFreq, noteVol);
    sqrEnv.play(sqr, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 2788 && waveType < 4095) {
    saw.play(noteFreq, noteVol);
    sawEnv.play(saw, attackTime, sustainTime, sustainLevel, releaseTime);
  }
}

//VISUALIZER CODE

class daCircle {

  float posX, posY, radius, velX, velY, circleAlpha;
  color cColor;

  daCircle(float hue) {
    radius = random(15, 50);
    posX = random(width);
    posY = random(height);
    velX = random(-3, 3);
    velY = random(-3, 3);
    circleAlpha = 255;
    cColor = color(hue, .7, 1, circleAlpha);
  }

  void move() {
    posX += velX;
    posY += velY;
  }

  void display() {
    noStroke();
    
    // Update circle color based on current circleAlpha
    cColor = color(hue(cColor), saturation(cColor), brightness(cColor), circleAlpha);
    
    fill(cColor);
    ellipse(posX, posY, radius * 2, radius * 2);
  }

  

  void growAndDecay() {
    radius += 1;
    circleAlpha -= 10;
  }
}

//VISUALIZER FUNC

void drawVisualizer(float hue) {
  circles.add(new daCircle(hue));

  for (int i = circles.size() - 1; i >= 0; i--) {
    daCircle member = circles.get(i);
    member.display();
    member.move();
    member.growAndDecay();

    // Correct condition for removing circles
    if (member.circleAlpha <= 0) {
      circles.remove(i);
    }
  }
}
