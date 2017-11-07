/*
  General Neural Network
  Author: Aniekan Umoren
  Created: Sun Sep 10, 2017
*/



Neural_Network NN;

float [][] inputs = new float[1][5];

void setup() {
  fullScreen();
  //size(1000, 700);
  NN = new Neural_Network();
  float [][] in = new float[5][5];
  for (int i = 0; i < 5; i++){
    for (int j = 0; j < 5; j++){
      in[i][j] = random(-1,1);
    }
  }
  Matrix m = new Matrix(in);
  m.showMatrix();
  m.deleteLocal(3,1);
  m.showMatrix();
  
}

void draw() {
  background(255,255,255);
  frameRate(10);
  for (int i = 0; i < 5; i++){
    inputs[0][i] = random(-1, 1);
  }
  NN.forward(inputs);
  NN.render();
}
