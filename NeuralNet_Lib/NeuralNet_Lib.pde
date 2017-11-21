/*
 General Neural Network
 Author: Aniekan Umoren
 Created: Sun Sep 10, 2017
 */

import java.util.*; 


Neural_Network NN, NN2;


UnitTest test = new UnitTest();

void setup() {
  //fullScreen();
  size(1000, 700);
  //NN = new Neural_Network(2, 3, 1, 1, 3);

  NN2 = new Neural_Network(1,3,1,3,3);
 // NN2.testNetwork();
  Matrix X = new Matrix("0.1;0.2;0.3", 3, 1);
  Matrix Y = new Matrix("0.2;0.4;0.6", 3, 1);  
  X.showMatrix();
  NN2.forward(X);
  println("Before Traning:");
  NN2.yHat.showMatrix();
  NN2.train(X, Y);
  println("\nRESULT:\n");
  NN2.yHat.showMatrix();
  print("ANSWER:\n");
  Y.showMatrix();
  
  //test.test();

  
  
}

void draw() {
  background(255, 255, 255);
  frameRate(10);

  //NN.forward(x);
  NN2.render();
}
