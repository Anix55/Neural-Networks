int sign(float n) {
  // This is the activation function
  if (n >= 0) {
    return 1;
  } else {
    return -1;
  }
}

class Perceptron {
  float [] weights;
  float slope, intercept;
  float lr = 0.01; //learning rate
  float[] pos = new float[2];
  int output = 0;

  // Constructor
  Perceptron(int n) {
    weights = new float[n];
    // Initialize the wights randomly
    for (int i = 0; i < weights.length; i++) {
      weights[i] = random(-1, 1);
    }
    slope = -1*(weights[0]/weights[1]);
    intercept = -1*weights[2]/weights[1];
    pos[0] = 100;
    pos[1] = 100;
  }

  int guess(float[] inputs) {
    float sum = 0;
    for (int i = 0; i < weights.length; i++) {
      sum += inputs[i]*weights[i];
    }
    output = sign(sum);
    return output;
  }

  void train(float[] inputs, int target) {
    int guess = guess(inputs);
    int error = target - guess;

    for (int i = 0; i < weights.length; i++) {
      weights[i] += error * inputs[i] * lr;
    }
    slope = -1*(weights[0]/weights[1]);
    intercept = -1*weights[2]/weights[1];
  }
  float guessY(float x){
    return -1*(weights[0]/weights[1])*x + -1*weights[2]/weights[1];
  }
  void visualize() {
    fill(100);
    ellipse(pos[0], pos[1], 200, 200);

    rectMode(CORNER);
    stroke(0);
    line(pos[0], pos[1], pos[0]-70, pos[1] -35);
    line(pos[0], pos[1], pos[0]-70, pos[1] +35);
    line(pos[0], pos[1], pos[0]+70, pos[1]);
    line(pos[0]-70, pos[1], pos[0], pos[1]);
    
    noStroke();
    fill(0);
    ellipse(pos[0], pos[1], 40, 40);
   
    // Labels
    fill(255);
    text(String.format("w0: %.2f", weights[0]), pos[0]-70, pos[1]); //w0
    text(String.format("w1: %.2f", weights[1]), pos[0]-70, pos[1]+35); //w1
    text(String.format("w2: %.2f", weights[2]), pos[0]-70, pos[1]-35); // bias
    text(String.format("y = %.2fx + %.2f", slope, intercept), pos[0]-55, pos[1]+70); // equation of line
    stroke(0,255,0);
    
    fill(0,0,255);
    text("x", pos[0]-85, pos[1]);
    text("y", pos[0]-85, pos[1]+35);
    text("b", pos[0]-85, pos[1]-35);
    fill(0,255,0);
    text("out", pos[0]+74, pos[1]+4);
  }
}