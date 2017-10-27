/*
  General Neural Network
  Author: Aniekan Umoren
  Created: Sun Sep 10, 2017
*/



Neuro_Evolution NeuroEvo;

float [][] inputs = new float[1][5];

void setup() {
  fullScreen();
  //size(1000, 700);
  NeuroEvo = new Neuro_Evolution(new float[0], false);

  
}

void draw() {
  background(255,255,255);
  frameRate(10);
  for (int i = 0; i < 5; i++){
    inputs[0][i] = random(-1, 1);
  }
  NeuroEvo.forward(inputs);
  NeuroEvo.render();
}