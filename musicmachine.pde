import processing.serial.*;
import processing.sound.*;

Serial ESP32Connection;
String incomingValue;

float redBeat, blueBeat, yellowBeat, redPitch, bluePitch, yellowPitch, waveType;
float noteFreq, noteDur;

//SinOsc sine;
//SqrOsc sqr;
//SawOsc saw;

//Env sineEnv, sqrEnv, sawEnv;

SinOsc ySine, rSine, bSine;
SqrOsc ySqr, rSqr, bSqr;
SawOsc ySaw, rSaw, bSaw;

Env ySineEnv, ySqrEnv, ySawEnv, rSineEnv, rSqrEnv, rSawEnv, bSineEnv, bSqrEnv, bSawEnv;

float attackTime, sustainTime, sustainLevel, releaseTime;

void setup() {
  size(800, 600);
  colorMode(HSB, TWO_PI, 1, 1);
  //printArray(Serial.list());
  ESP32Connection = new Serial(this, Serial.list()[1], 9600);
  ESP32Connection.bufferUntil('\n');

  //sine = new SinOsc(this);
  //sineEnv = new Env(this);

  //sqr = new SqrOsc(this);
  //sqrEnv = new Env(this);

  //saw = new SawOsc(this);
  //sawEnv = new Env(this);

  ySine = new SinOsc(this);
  ySineEnv = new Env(this);

  ySqr = new SqrOsc(this);
  ySqrEnv = new Env(this);

  ySaw = new SawOsc(this);
  ySawEnv = new Env(this);

  rSine = new SinOsc(this);
  rSineEnv = new Env(this);

  rSqr = new SqrOsc(this);
  rSqrEnv = new Env(this);

  rSaw = new SawOsc(this);
  rSawEnv = new Env(this);

  bSine = new SinOsc(this);
  bSineEnv = new Env(this);

  bSqr = new SqrOsc(this);
  bSqrEnv = new Env(this);

  bSaw = new SawOsc(this);
  bSawEnv = new Env(this);
}

void draw() {
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

  if (redBeat == 0) {
    noteDur = 0;
  } else if (redBeat == 1) {
    noteDur = .5;
    attackTime = 0.05;
    sustainTime = 0.54;
    sustainLevel = 0.22;
    releaseTime = 0.1;
  } else if (redBeat == 2) {
    noteDur = .25;
    attackTime = 0.02;
    sustainTime = 0.3;
    sustainLevel = 0.9;
    releaseTime = 0.5;
  } else if (redBeat == 3) {
    noteDur = 1;
    attackTime = 0.06;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.03;
  }

  if (waveType > 0 && waveType < 1502) {
    rSine.play(noteFreq, noteDur);
    rSineEnv.play(rSine, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 1502 && waveType < 2788) {
    rSqr.play(noteFreq, noteDur);
    rSqrEnv.play(rSqr, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 2788 && waveType < 4095) {
    rSaw.play(noteFreq, noteDur);
    rSawEnv.play(rSaw, attackTime, sustainTime, sustainLevel, releaseTime);
  }

  delayBetweenNotes();
}

void blueLayer() {

  noteFreq = bluePitch;

  if (blueBeat == 0) {
    noteDur = 0;
  } else if (blueBeat == 1) {
    noteDur = .5;
    attackTime = 0.05;
    sustainTime = 0.54;
    sustainLevel = 0.22;
    releaseTime = 0.1;
  } else if (blueBeat == 2) {
    noteDur = .25;
    attackTime = 0.02;
    sustainTime = 0.3;
    sustainLevel = 0.9;
    releaseTime = 0.5;
  } else if (blueBeat == 3) {
    noteDur = 1;
    attackTime = 0.06;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.03;
  }

  if (waveType > 0 && waveType < 1502) {
    bSine.play(noteFreq, noteDur);
    bSineEnv.play(bSine, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 1502 && waveType < 2788) {
    bSqr.play(noteFreq, noteDur);
    bSqrEnv.play(bSqr, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 2788 && waveType < 4095) {
    bSaw.play(noteFreq, noteDur);
    bSawEnv.play(bSaw, attackTime, sustainTime, sustainLevel, releaseTime);
  }

  delayBetweenNotes();
}

void yellowLayer() {

  noteFreq = yellowPitch;

  if (yellowBeat == 0) {
    noteDur = 0;
  } else if (yellowBeat == 1) {
    noteDur = .5;
    attackTime = 0.05;
    sustainTime = 0.54;
    sustainLevel = 0.22;
    releaseTime = 0.1;
  } else if (yellowBeat == 2) {
    noteDur = .25;
    attackTime = 0.02;
    sustainTime = 0.3;
    sustainLevel = 0.9;
    releaseTime = 0.5;
  } else if (yellowBeat == 3) {
    noteDur = 1;
    attackTime = 0.06;
    sustainTime = 0.3;
    sustainLevel = 0.5;
    releaseTime = 0.03;
  }

  if (waveType > 0 && waveType < 1502) {
    ySine.play(noteFreq, noteDur);
    ySineEnv.play(ySine, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 1502 && waveType < 2788) {
    ySqr.play(noteFreq, noteDur);
    ySqrEnv.play(ySqr, attackTime, sustainTime, sustainLevel, releaseTime);
  } else if (waveType > 2788 && waveType < 4095) {
    ySaw.play(noteFreq, noteDur);
    ySawEnv.play(ySaw, attackTime, sustainTime, sustainLevel, releaseTime);
  }

  delayBetweenNotes();
}



//quiet space between notes

void delayBetweenNotes() {
  float quietSpaceDuration = 0.2; // in seconds
  delay(floor(quietSpaceDuration * 1000)); // converted to ms
}
